---
quando_usar: falar de preços, planos, assinatura, top-ups, créditos de boas-vindas, modelo de receita
última_revisão: 2026-10-22
status: canônico
tags: [billing]
---

# Monetização — assinatura + créditos

Modelo **assinatura + consumo**. O professor assina um plano que deposita créditos por ciclo; cada ação
de IA **debita créditos**. Quem esgota antes do fim do ciclo compra **top-ups** avulsos. Tudo em **BRL**.

> Mecânica técnica de wallet/ledger/débito e o custo exato por operação ficam em
> [tecnico/billing-ledger.md](../tecnico/billing-ledger.md). Aqui é o modelo comercial.

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
Para esgotamento fora do ciclo. Pacotes via **Stripe (cartão)** — existem no produto, embora o
FAQ da página `/precos` do site ainda diga que avulsos virão "em breve" (divergência interna do site). O **PIX (AbacatePay)** está
**temporariamente desativado** (kill-switch `PIX_TOPUP_ENABLED = false`; ver [tecnico/integracoes.md](../tecnico/integracoes.md)) —
apenas cartão por enquanto. Validade de **365 dias**. Fonte: `apps/api/src/domains/billing/domain/topup.ts`.

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
referência externa. Detalhe em [tecnico/integracoes.md](../tecnico/integracoes.md) (seção NFE.io) e domínio `invoicing`.

## Fontes de crédito (wallet)
Toda wallet tem uma `source` que define a prioridade de consumo (gasto primeiro → por último):
`subscription` → `topup`/`admin_grant` → `promo` → `welcome`. **Não existe mais** `source = pix` (top-up
PIX desativado; cobranças PIX residuais que liquidam viram `topup`). Detalhe em [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).

## Custo interno (o que se paga ao OpenAI)
A relação tokens→créditos é rastreada como **telemetria** (~5,5 tokens por crédito, com desconto de
prompt caching) **apenas para análise de custo/auditoria** — **não é o que se cobra do cliente**: o preço
por operação é uma **tabela determinística** (ver [tecnico/billing-ledger.md](../tecnico/billing-ledger.md)). No dashboard financeiro
staff, custo de IA entra como `ai_inference`.

## Quem paga: professor ou instituição
O débito resolve o alvo antes de descontar. Organização **sem** configuração de billing cai no
default fail-safe: cobra da carteira **pessoal** do professor. A instituição só passa a pagar quando
adota explicitamente um modo — hoje **`pool`** (créditos compartilhados; carteiras pessoais dos
membros ficam congeladas) ou **`unlimited`** (sem checagem de saldo, mas com ledger para auditoria).
`per_teacher` e `pay_per_use` existem no tipo mas estão **reservados, não ligados**.

Consequência comercial: quando o pool da instituição acaba, o erro é `InstitutionOutOfCredits` — quem
precisa comprar é o **admin**, não o professor que travou. É outra conversa de suporte e outra copy.

O site já vende um plano **Instituição** com preço **"Sob medida"** (pool de créditos institucional,
análises consolidadas, onboarding dedicado, CTA "Falar com a gente"). Não há SKU institucional no
código: o contrato é negociado fora do sistema.

**Para onde vai (decidido, não executado):** o ADR-0013 do monorepo (status **proposto**) faz da
organização a raiz da conta. Todo crédito vira **pool único da org** — o professor solo é um pool de
1 — e o direito a recurso pago passa a vir do **plano** (assinatura individual ou plano Instituição),
não de pertencer a uma org. **O código atual ainda usa a carteira pessoal** com o fail-safe descrito
acima.

## O que não consome crédito
- **"Meu estilo"** exige acesso de assinante (assinatura ativa, membro de instituição ou staff), mas
  **destilar o perfil não debita**. Gerar com o estilo custa o mesmo que gerar sem.
- **Ler a instrução do professor** (transformar "foque em X" em intenções estruturadas) não debita;
  é limitado por rate limit.

## Expiração por fonte
- **Assinatura** — expira no fim do ciclo (`expiresAt = currentPeriodEnd`). No mensal os créditos
  **não acumulam**.
- **Top-up** — 365 dias.
- **Welcome** — **nunca expira**.

## Faixa de preço por ação (para a conversa comercial)
Derivado da tabela determinística (detalhe em [tecnico/billing-ledger.md](../tecnico/billing-ledger.md)):

| Ação | Faixa em créditos |
|---|---|
| Prova objetiva (1–50 questões) | 275 – 2.500 |
| Prova discursiva (1–30 questões) | 310 – 2.050 |
| Correção de discursiva | 30 por resposta (em branco não cobra) |
| Plano de aula | 300 – 400, conforme o segmento |

> **Cuidado com o `docs/CREDITOS_E_PRECOS.md` do monorepo.** Ele está **mais defasado que esta base**:
> lista uma origem de carteira `custom` que não existe, omite `promo` e `admin_grant`, e diz que
> top-up sai por PIX ignorando o kill-switch. Se precisar conferir, vá ao código.
