---
quando_usar: falar de preços, planos, assinatura, top-ups, créditos de boas-vindas, modelo de receita
última_revisão: 2026-06
status: canônico
---

# Monetização — assinatura + créditos

Modelo **assinatura + consumo**. O professor assina um plano que deposita créditos por ciclo; cada ação
de IA **debita créditos**. Quem esgota antes do fim do ciclo compra **top-ups** avulsos. Tudo em **BRL**.

> Mecânica técnica de wallet/ledger/débito e o custo exato por operação ficam em
> tecnico/billing-ledger.md. Aqui é o modelo comercial.

## Planos (Stripe)
A fonte de verdade dos planos é o código, não o Stripe — o webhook lê estes valores para depositar
créditos. Fonte: `apps/api/src/domains/billing/domain/plan.ts`.

| Plano | Período | Preço | Créditos/ciclo | Suporte |
|---|---|---|---|---|
| Básico | Mensal | R$ 49,90 | 5.000 / mês | Padrão |
| Básico Anual | Anual | R$ 479,00 | 60.000 / ano | Padrão |
| Pro | Mensal | R$ 99,90 | 15.000 / mês | Prioritário |
| Pro Anual | Anual | R$ 959,00 | 180.000 / ano | Prioritário |

Os anuais têm ~20% de economia vs. mensal. Todos: alunos e provas ilimitados, correção automática
ilimitada, análises por turma e aluno.

## Top-ups (avulsos)
Para esgotamento fora do ciclo. Mesmos pacotes via **Stripe (cartão)** e **PIX (AbacatePay)**.
Validade de **365 dias**. Fonte: `apps/api/src/domains/billing/domain/topup.ts`.

| Pacote | Créditos | Preço | Destaque |
|---|---|---|---|
| Início | 2.000 | R$ 29,90 | — |
| Plus | 5.000 | R$ 59,90 | Popular |
| Power | 15.000 | R$ 149,90 | Melhor valor |

## Créditos de boas-vindas
Todo usuário novo recebe **créditos de boas-vindas** no cadastro — valor configurável via
`WELCOME_CREDITS` (default **2000**). É **idempotente**: retry do hook de criação não duplica.
Concedido no `onUserCreated` da auth. Fonte: `billing/application/grant-welcome-credits.ts`.

## Faturamento fiscal
Cada transação de billing (assinatura ou top-up) pode gerar **NFS-e via NFE.io**, idempotente por
referência externa. Detalhe em tecnico/integracoes.md (seção NFE.io) e domínio `invoicing`.

## Custo interno (o que se paga ao OpenAI)
A relação tokens→créditos é rastreada como **telemetria** (~5,5 tokens por crédito, com desconto de
prompt caching), mas **não é o que se cobra**: o preço por operação é uma **tabela determinística**
(ver tecnico/billing-ledger.md). No dashboard financeiro staff, custo de IA entra como `ai_inference`.
