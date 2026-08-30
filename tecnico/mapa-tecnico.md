---
quando_usar: se orientar na área técnica — por onde começar e como os doze docs se encadeiam
última_revisão: 2026-08-30
status: canônico
---

# Mapa técnico

Doze docs sobre o `lucida-monorepo`. O código é a fonte primária: divergiu, o doc está velho, e o
`check-drift.sh` aponta onde.

## Fundação — leia nesta ordem

1. **[tecnico/stack.md](stack.md)** — o que roda: versões, libs, comandos, layout do monorepo, como
   subir local.
2. **[tecnico/arquitetura.md](arquitetura.md)** — Clean Architecture + DDD, as quatro camadas e a
   direção da dependência, o composition root, ordem de middleware, como web e api conversam.
3. **[tecnico/dominios.md](dominios.md)** — os 27 bounded contexts e as entidades centrais de cada um.
   É o mapa; o vocabulário está em [produto/glossario.md](../produto/glossario.md).

## Os dois motores

[tecnico/ai-ops.md](ai-ops.md) **gera e corrige**; [tecnico/billing-ledger.md](billing-ledger.md)
**cobra por isso**. Toda ação de IA passa pelos dois — um decide o que o modelo faz, o outro debita a
carteira. A metade comercial do billing está em
[negocio/monetizacao-creditos.md](../negocio/monetizacao-creditos.md).

## As features com doc próprio

- **[tecnico/biblioteca.md](biblioteca.md)** — arquivos do professor como fonte reutilizável de
  geração: upload presigned, extração única, gate de assinante.
- **[tecnico/calendario.md](calendario.md)** — janela de resposta da prova e o e-mail de abertura por
  outbox e cron.

As duas compartilham a mesma política de acesso (`SubscriberAccessPolicy`) e são as duas features
gateadas por assinatura.

## As bordas

- **[tecnico/integracoes.md](integracoes.md)** — tudo que é de fora: Stripe, NFE.io, Resend, Classroom,
  OMR, YouTube, PostHog, e como cada uma degrada quando a env falta.
- **[tecnico/eventos-posthog.md](eventos-posthog.md)** — a taxonomia de eventos, para montar funil ou
  instrumentar evento novo.

## Como se escreve aqui

- **[tecnico/convencoes-de-codigo.md](convencoes-de-codigo.md)** — nome de arquivo, idioma, import ESM,
  clean code. As regras invioláveis, com os hooks que bloqueiam, estão em
  [regras/codigo.md](../regras/codigo.md).
- **[tecnico/testes.md](testes.md)** — estratégia por camada, como rodar a suíte, o trio de testes de
  posse que todo endpoint novo exige.
- **[tecnico/framework-claude.md](framework-claude.md)** — inventário do `.claude/` **do monorepo**
  (skills, agents, comandos, hooks). É o único doc desta pasta que não descreve o produto, e o
  `lucida-mind` não herda nada dele.

---

Outras áreas: [negocio/mapa-do-negocio.md](../negocio/mapa-do-negocio.md) · [produto/mapa-do-produto.md](../produto/mapa-do-produto.md) · [ui/mapa-da-ui.md](../ui/mapa-da-ui.md) · [regras/mapa-das-regras.md](../regras/mapa-das-regras.md)
