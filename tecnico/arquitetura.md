---
quando_usar: criar/mover domínio, decidir camada, DI manual, ordem de middleware, como os apps conversam
última_revisão: 2026-08-25
status: canônico
---

# Arquitetura

Versões, libs, comandos e layout do monorepo em [tecnico/stack.md](stack.md).

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
- **infrastructure/** — Mongoose (schema + repositório). Implementa as interfaces do `domain/`.
  Nunca vaza `Document` para fora.
- **presentation/** — Express + **Zod** para validar **input** (controller fino: valida `req`, chama use
  case, responde HTTP). Zod também é aceitável em **infrastructure/** para fazer parsing de **respostas de
  APIs externas** (OpenAI, AbacatePay, NFE.io, Resend) — nunca em application/domain.

O hook `check-layer-purity` bloqueia import de infraestrutura em `domain/` ou `application/`.

## Estrutura de pastas: layout plano
Dentro de cada camada os arquivos ficam **direto na pasta**, um por conceito. **Não** há
subpastas por tipo (`entities/`, `value-objects/`, `repositories/`, `use-cases/`, `persistence/`)
nem sufixos `.use-case.ts` / `.dto.ts`, e **não existe mapper** — o mapeamento domínio↔documento é
inline no repositório. O teste fica **co-localizado**, ao lado do fonte.

```
domains/exam/
  domain/         exam.ts  exam-id.ts  exam-schedule.ts  question.ts  rubric.ts
                  activity-type.ts  exam-repository.ts  exam-errors.ts
  application/    create-exam.ts + create-exam.test.ts
                  copy-exam-to-class.ts  schedule-exam.ts  get-exam.ts  …
  infrastructure/ mongoose-exam-repository.ts  exam-schema.ts
  presentation/   exam-controller.ts  exam-routes.ts  exam-schemas.ts
```

> O skill `backend-clean-ddd/references/folder-structure.md` do monorepo descreve uma estrutura
> aninhada que **o código não segue**. Vale o que está aqui: layout plano.

Nem todo domínio tem as 4 camadas — a camada existe quando é necessária. Hoje: `calendar` não tem
`infrastructure/` (lê pelo repositório de `exam`), `support` só tem `presentation/`,
`webhook-dispatch` só tem `application/` + `infrastructure/`.

## O kernel fora de `domains/`
- `shared/errors/` — `DomainError` (abstrata, com `code` + `statusCode`) e `InvalidIdError`.
- `shared/access/subscriber-access-policy.ts` — a política única de feature de assinante.
- `shared/http/sse.ts` — helpers de streaming.
- `shared/observability/` — porta `AnalyticsCaptureClient`, cliente PostHog e o stub no-op.
- `shared/persistence/` — porta `TransactionRunner` + `MongooseTransactionRunner`, para escrita
  atômica que cruza domínios (ex.: `update-class` propaga `courseId` para student/exam/submission
  dentro de uma transação).
- `shared/security/exam-link-token.ts` — token de link de prova por aluno.
- `infrastructure/database/mongodb/connection.ts` e `infrastructure/middlewares/error-handler.ts`.

## Erros
Violação de regra = `throw` de subclasse de **`DomainError`** com `statusCode`. Sem Result/Either.
Um error middleware global mapeia `DomainError` → HTTP e `ZodError` → 400.

Faixas em uso, por frequência: **400** (a mais comum — input malformado, Zod **e** regra de formato),
404 não encontrado, 422 regra de negócio com input válido, 409 conflito de estado, 403 sem permissão,
**503** dependência não configurada (degradação graciosa), **502** falha de serviço externo,
**402** paywall de assinante, 401 sem auth, 413/415/410 em casos pontuais.

## Composition root (DI manual)
Tudo é instanciado em **`apps/api/src/main.ts`** — sem container, sem decorators. É um arquivo único
e grande (~1.750 linhas); **não** há factory por feature (`<feature>.module.ts` não existe), e está
registrado que ele fica fora da meta de cobertura.

Ordem em `buildApp()`, que **não** deve ser invertida:

1. `connectMongo` → `getAuthDb`
2. **observability** — criada primeiro para que auth hook, webhooks e error handler capturem eventos.
   Sem `POSTHOG_API_KEY`, entra um stub no-op e a api sobe igual.
3. **billing** — *"Must exist before auth to feed the welcome-credits hook"*, e antes dos controllers
   de ai-ops para o gate de saldo.
4. **auth (BetterAuth) + `requireAuth`** — o hook `onUserCreated` concede welcome credits.
5. repositórios compartilhados → blocos por domínio → array `routers` → `rawBodyRouters`.

Não há uma fase separada de "use cases": eles são instanciados **inline** no objeto `Deps` do
controller (`new CourseController({ createCourse: new CreateCourseUseCase(courseRepository), … })`).
É esse `Deps` nomeado que permite testar `presentation` como unit, sem `supertest`.

App Express montado em `app.ts`; entrypoint em `server.ts`; envs validadas por Zod em `env.ts`
(o hook `check-env-access` bloqueia `process.env` cru fora de `env.ts`).

## Ordem de middleware (não reordenar)
Em `app.ts`: CORS → **handler do BetterAuth** (`app.all("/api/auth/*splat")`, wildcard nomeado do
Express 5, antes do json porque lê o corpo cru) → **`rawBodyRouters`** (webhook Stripe, webhook
NFE.io, tickets público) → `express.json({ limit: "15mb" })` → `/health` → `routers` → error handler.

Inverter raw-body com `express.json()` quebra a verificação de assinatura do Stripe. O limite de
15MB acomoda foto de folha OMR em base64.

## Como os apps conversam
O browser fala só com o Next (3000); o Next reescreve para a api (3333). O browser nunca chama `:3333`.

```
Browser → Next (3000)
  rewrites: /ingest/static/* → us-assets.i.posthog.com  (assets do PostHog)
            /ingest/*        → us.i.posthog.com         (ingestão do PostHog)
            /api/auth/*      → api:3333/api/auth/*      (BetterAuth)
            /v1/*            → api:3333/v1/*
  → @lucida/api (3333) → MongoDB, Stripe, OpenAI, Resend, serviços Python
```

Mais `skipTrailingSlashRedirect: true` (exigido pela ingestão do PostHog) e um redirect
`www.lucidaexam.com` → apex.

**Nem toda rota da api está sob `/v1`.** `roadmap` e `notifications` montam sob **`/api/`**
(`/api/roadmap`, `/api/notifications`) e **não** têm rewrite — são chamadas server-side pelo
`apiFetch` (`server-only`), que usa `NEXT_PUBLIC_API_URL` direto. Prefixos reais:
`/v1/{ai,analytics,billing,classes,courses,exams,grading,iam,integrations,internal,invoicing,
lesson-plans,library,me,public,scans,students,support,tickets}`, `/api/auth`, `/api/roadmap`,
`/api/notifications`, `/health`.

As rotas `/v1/internal/*` são de **cron**, gateadas por `CRON_SECRET` — ver [tecnico/integracoes.md](integracoes.md).

Auth = BetterAuth, cookie `lucida.session_token` (`__Secure-` em prod). O middleware do web protege
`/app`, `/analytics`, `/kintal` só checando presença do cookie no edge, com a exceção
`/kintal/entrar`, e cada prefixo redireciona para um sign-in próprio com `?next=`. O gating por role
fica no layout/use cases do servidor.

## SSE
Geração longa de IA faz **streaming via SSE** (`shared/http/sse.ts`) para não estourar timeout de proxy.
Headers: `Content-Type: text/event-stream`, `Cache-Control: no-cache, no-transform`,
`Connection: keep-alive`, `X-Accel-Buffering: no`.

O cliente **não usa `EventSource`** — `EventSource` é GET-only e não manda corpo. O front faz
`POST` + leitura manual do stream (`res.body.pipeThrough(new TextDecoderStream()).getReader()`,
em `features/app/provas/sse-client.ts`).

Do lado do servidor, `server.ts` desarma os timeouts do Node para a resposta não ser cortada:
`requestTimeout = 0`, `keepAliveTimeout = 120_000`, `headersTimeout = 125_000` (o headers precisa ser
maior que o keepAlive). O heartbeat do controller cuida do proxy.
