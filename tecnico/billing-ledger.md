---
quando_usar: mexer em créditos, wallet, ledger, débito atômico, expiração, custo por operação de IA
última_revisão: 2026-08-25
status: canônico
---

# Billing — wallets, ledger e custo por operação

Domínio `billing`. O lado comercial (planos/top-ups) está em negocio/monetizacao-creditos.md; aqui é a
mecânica.

## Wallets e ledger
- **CreditWallet**: saldo com `scope` (`user`/`org`), `source` (`subscription`/`topup`/`welcome`/
  `promo`/`admin_grant`), `balance` e `expiresAt`. Um dono pode ter várias wallets. Consumo segue a
  prioridade da `source`: `subscription` (0) → `topup`/`admin_grant` (1) → `promo` (2) → `welcome` (3,
  por último). **Não existe mais `source = pix`**: o PIX (AbacatePay) foi desativado e cobranças PIX que
  ainda liquidam pelo webhook criam wallet com `source = "topup"`.
- **Ledger**: registra cada movimento (crédito/débito). Além de `tokensUsed` (telemetria, não é o que
  se cobra), a entrada carrega `scope`, `actorUserId`, `billingPeriodId`, `walletSource`,
  `relatedAction`, `metadata` e um `reason` de **conjunto fechado** (9 valores, incluindo
  `expiration`). Coleções: `credit_wallets` e `credit_ledger`.
  Valores de `relatedAction` gravados hoje: `generate_exam`, `generate_open_exam`,
  `regenerate_question`, `regenerate_open_question`, `grade_open_answer`, `generate_lesson_plan`,
  `regenerate_lesson_block`, `topup_<topupId>`.
- **Welcome credits**: concedidos no `onUserCreated`, idempotentes, valor por `WELCOME_CREDITS`
  (default 2000). Billing precisa estar inicializado **antes** da auth no composition root.

## Quem paga: user ou organização
Antes de cada débito, o **`BillingTargetResolver`** decide se a conta é do professor (`scope: "user"`)
ou da instituição (`scope: "org"`). O default é fail-safe: organização **sem**
`OrganizationBillingSettings` resolve para `user`, então a carteira pessoal continua valendo.

Modos de billing de organização (`OrgBillingMode`) — atenção, **só dois estão ligados**:

| Modo | Estado | O que faz |
|---|---|---|
| `pool` | ativo | Créditos compartilhados pré-pagos; as carteiras pessoais dos membros ficam congeladas |
| `unlimited` | ativo | Pula o pré-check de saldo, mas **ainda grava ledger** para auditoria, com wallet simbólica `unlimited:<orgId>` e `walletSource: "admin_grant"` |
| `per_teacher` | **reservado, não wired** | Teto mensal pré-pago por membro |
| `pay_per_use` | **reservado, não wired** | Pós-pago, faturado via Stripe |

Quando o pool da instituição acaba, o erro é **`InstitutionOutOfCreditsError`** (402,
`INSTITUTION_OUT_OF_CREDITS`) — distinto do `InsufficientCreditsError` do professor individual. A
mensagem de UI precisa distinguir os dois: num, o professor compra; no outro, quem compra é o admin.

## Débito atômico
`AtomicDebitService` debita usando `session.withTransaction` (MongoDB) para evitar corrida em operações
paralelas. **Exige replica set** — em dev, suba Mongo com `--replSet rs0` + `rs.initiate()` ou use Atlas.
Sem replica set, qualquer débito quebra. Há pré-check de saldo (`EnsureSufficientBalanceUseCase`) antes
de operações de IA.

Sob concorrência o saldo pode ficar obsoleto entre o plano e a escrita: o `DebitCreditsUseCase`
recebe `StaleBalanceError` e **replaneja**, até `MAX_RETRIES` (5).

## Expiração
Wallets vencidas são zeradas por `ExpireStaleWalletsUseCase`, disparado por CRON:
`POST /v1/internal/expire-credits` (header `x-cron-secret`). Sem a env → **503**; secret errado → **404**.
Devolve `{ scanned, expired, creditsExpired }` e grava ledger com `reason: "expiration"`.

Prazos por fonte: crédito de **assinatura** expira no fim do ciclo (`expiresAt = currentPeriodEnd`);
**top-up** vale 365 dias; **welcome** nunca expira (`expiresAt: null`).

## Custo por operação (tabela determinística)
Preço é **função pura da config** — o valor cotado, pré-checado e debitado é idêntico. Fontes:
`apps/api/src/domains/ai-ops/domain/{exam-pricing,grading-pricing,lesson-plan-pricing}.ts`.

### Geração de prova objetiva
`250 (base) + porQuestão × quantidade`, onde **porQuestão** depende do estilo:

| Estilo | Crédito/questão |
|---|---|
| simple | 25 |
| analytical | 42 |
| reflective | 45 |
| contextual | 45 |

Ex.: 10 questões `simple` → 250 + 25×10 = **500**. **Regenerar** 1 questão = só o por-questão (sem base,
porque o prompt já foi cacheado).

### Geração de prova com questões abertas
`250 (base) + 60 × quantidade`. Regenerar 1 aberta = **60**.

### Correção de resposta aberta por IA
**30 créditos por resposta** corrigida (lote = 30 × nº de respostas). Resposta em branco não é cobrada.

### Plano de aula (por segmento)
| Segmento | Créditos |
|---|---|
| FUNDAMENTAL | 300 |
| MEDIO | 300 |
| FACULDADE | 400 |
| INFOPRODUTOR | 350 |

Regenerar um bloco do plano = **60**.

> Os preços de plano de aula são marcados como **provisórios** no código ("recalibrate once token usage
> is measured"). Os de prova/correção são estáveis.

## Telemetria tokens→créditos (não-faturável)
Estimativa interna: ~**5,5 tokens por crédito**, com ~50% de desconto em tokens de input cacheados;
mínimo 1 crédito. Usada para análise de custo, **não** para cobrar. Fonte:
`ai-ops/infrastructure/estimate-credits.ts`.
