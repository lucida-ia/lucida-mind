---
quando_usar: mexer em créditos, wallet, ledger, débito atômico, expiração, custo por operação de IA
última_revisão: 2026-06-27
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
- **Ledger**: registra cada movimento (crédito/débito), incluindo `tokensUsed` para **telemetria**
  (não é o que se cobra).
- **Welcome credits**: concedidos no `onUserCreated`, idempotentes, valor por `WELCOME_CREDITS`
  (default 2000). Billing precisa estar inicializado **antes** da auth no composition root.

## Débito atômico
`AtomicDebitService` debita usando `session.withTransaction` (MongoDB) para evitar corrida em operações
paralelas. **Exige replica set** — em dev, suba Mongo com `--replSet rs0` + `rs.initiate()` ou use Atlas.
Sem replica set, qualquer débito quebra. Há pré-check de saldo (`EnsureSufficientBalanceUseCase`) antes
de operações de IA.

## Expiração
Wallets vencidas são zeradas por `ExpireStaleWalletsUseCase`, disparado por CRON:
`POST /v1/internal/expire-credits` (header `CRON_SECRET`). Sem a env → 503.

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
