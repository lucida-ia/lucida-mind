---
quando_usar: criar/mover domínio, decidir camada, DI manual, ordem de middleware, como os apps conversam
última_revisão: 2026-06
status: canônico
---

# Arquitetura

## Backend — Clean Architecture + DDD por feature
Cada feature é um **bounded context** em `apps/api/src/domains/<feature>/` com 4 camadas e direção de
dependência fixa:

```
presentation ──▶ application ──▶ domain ◀── infrastructure
```

- **domain/** — TypeScript **puro**. Entities, value objects, interfaces de repositório, domain
  services, erros. **Zero libs externas** (nem Zod, nem Mongoose, nem Express; só `node:crypto`).
- **application/** — use cases. Uma classe = uma operação, com `execute(input): Promise<output>`.
  Recebe dependências por construtor (interfaces). DTOs planos de entrada/saída, nunca entidades cruas.
- **infrastructure/** — Mongoose (schema, repositório, **mapper** domínio↔documento). Implementa as
  interfaces do `domain/`. Nunca vaza `Document` para fora.
- **presentation/** — Express + **Zod** (só aqui). Controller fino: valida `req`, chama use case,
  responde HTTP.

Estrutura típica de um domínio:
```
domains/exam/
  domain/{entities,value-objects,repositories,services,errors}/
  application/use-cases/<acao>/<acao>.use-case.ts + .dto.ts
  infrastructure/persistence/{schema,repository,mapper}
  presentation/{schemas,controller,routes}
```

## Erros
Violação de regra = `throw` de subclasse de **`DomainError`** com `statusCode`. Sem Result/Either.
Um error middleware global mapeia `DomainError` → HTTP. Faixas: 404 não encontrado, 409 conflito de
estado, 401 sem auth, 403 sem permissão, 422 regra de negócio (input válido), 400 input malformado (Zod).

## Composition root (DI manual)
Tudo é instanciado em **`apps/api/src/main.ts`** — sem container, sem decorators. Ordem: repositórios →
use cases → controllers → routers. Quando `main.ts` cresce, extrai-se uma factory por feature
(`<feature>.module.ts`). App Express montado em `app.ts`; entrypoint em `server.ts`; envs validadas por
Zod em `env.ts`.

## Ordem de middleware (não reordenar)
Em `app.ts`: CORS → **handler do BetterAuth** (`/api/auth/*`) → **routers de raw-body** (ex.: webhook
Stripe, que precisa do corpo cru) → `express.json()` global → rotas normais → error handler.
Inverter raw-body com `express.json()` quebra a verificação de assinatura do Stripe.

## Como os apps conversam
O browser fala só com o Next (3000); o Next reescreve para a api (3333). O browser nunca chama `:3333`.

```
Browser → Next (3000)
  rewrites: /api/auth/* → api:3333/api/auth/*   (BetterAuth)
            /v1/*       → api:3333/v1/*          (rotas autenticadas + públicas)
            /ingest/*   → us.i.posthog.com/*     (reverse proxy PostHog)
  → @lucida/api (3333) → MongoDB, Stripe, OpenAI, Resend, serviços Python
```

Auth = BetterAuth, cookie `lucida.session_token` (`__Secure-` em prod). O middleware do web protege
`/app`, `/analytics`, `/kintal` só checando presença do cookie no edge; o gating por role fica no
layout/use cases do servidor.

## SSE
Geração longa de IA faz **streaming via SSE** (`shared/http/sse.ts`) para não estourar timeout de proxy.
O cliente escuta com `EventSource`. Headers: `text/event-stream`, `no-cache`, `X-Accel-Buffering: no`.
