---
quando_usar: decidir comportamento de produto — degradação, idiomas, rubrica, aprovação, replica set, acesso do aluno
última_revisão: 2026-06
status: canônico
---

# Regras de produto

Invariantes de comportamento que o produto respeita. Mecânica em tecnico/*.

## Degradação graciosa
Integrações são **opcionais por env**. Sem a env, a feature correspondente devolve **503/502** mas o
resto da api continua. Vale para OMR (502), Stripe/PIX, NFE.io, Classroom (card indisponível), PostHog
(no-op), transcrição, CRON (503). Nunca derrubar o app por falta de integração secundária. Detalhe em
tecnico/integracoes.md.

## Geração e correção
- **Três idiomas** de geração: pt-BR, inglês, espanhol.
- **Questão aberta exige rubrica** — não existe aberta sem critérios/níveis.
- **Correção de aberta é assistida, não automática**: a IA sugere nível por critério; **só conta no
  score depois da aprovação do professor**. A IA nunca arbitra a nota numérica sozinha.
- Preço de IA é **determinístico por config** — o que é cotado é o que é debitado (tecnico/billing-ledger.md).

## Créditos
- Toda ação de IA **debita créditos**; há pré-check de saldo antes de operações caras.
- Mongo **precisa de replica set** — o débito atômico usa transação. Sem isso, qualquer cobrança quebra.
- Welcome credits são **idempotentes** (não duplicar em retry).

## Acesso do aluno
- O aluno **não tem login**. Responde a prova apenas pelo **link público** `/exam/[shareId]`.
- A frente "aluno" (azul claro) é marca futura; não há produto autenticado para aluno hoje.

## Organização vs. professor individual
- `organizationId = null` → professor individual. Com organização, há billing/analytics no escopo da
  instituição (frente roxa, `/analytics`).

## Backoffice
- `/kintal` é **staff-only** e nunca exposto ao cliente. Gating por role fica no servidor, não no edge.
