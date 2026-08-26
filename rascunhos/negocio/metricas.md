---
quando_usar: reportar tração, falar de MRR, retenção, base pagante, métricas de uso
última_revisão: 2026-08-25
status: rascunho
---

# Métricas atuais

> **Rascunho — nunca validado.** Números de jun/2026, vindos de contexto de negócio e não conferidos
> por ninguém do time. Não afirme nada daqui como fato da Lucida. Além da idade: o re-baseline de
> checkout de jun/2026 reiniciou a base pagante, então o histórico de 40 pagantes e MRR R$ 749,55 é
> referência, não posição.

## Situação atual (jun/2026)

| Métrica | Valor atual | Histórico (pré-re-baseline) |
|---|---|---|
| Pagantes ativos | **2** (1 instituição + 1 infoprodutor) | 40 professores |
| MRR | ~R$ 250 (estimado) | R$ 749,55 |
| Total pagantes histórico | 84 | — |
| Retenção anual | ~50% | — |
| Usabilidade (respostas/prova) | 80% da base ativa | — |
| Instagram | ~1k seguidores | — |
| Leads trial frios | >3k | — |

## Leitura estratégica

**Maior alavanca de curto prazo:** migrar a base histórica e os leads frios para o preço de tabela
atual (R$ 49,90+) — ticket realizado histórico era R$ 18,74; fechar essa defasagem vale mais que
aquisição nova no imediato.

**Break-even:** dezenas de pagantes no preço de tabela — ver custos fixos em
[negocio/monetizacao-creditos.md](../../negocio/monetizacao-creditos.md).

## Notas de interpretação

- **Churn involuntário ≠ cancelamento.** Falha de pagamento não é o cliente pedindo para sair —
  separar sempre ao reportar retenção (ver [regras/comunicacao.md](../../regras/comunicacao.md)).
- Usabilidade 80% = 80% da base ativa respondeu ao menos uma prova; não confundir com NPS ou
  satisfação.

## De onde sai cada número

Não há relatório único.

- **Receita e assinatura** — Stripe, mais as transações do domínio `billing`. O `/kintal/financeiro`
  cruza receita com despesa operacional.
- **Uso do produto** — `/kintal/metricas`, combinando Mongo (provas, submissões, correções) com
  PostHog via HogQL (funil de signup, assinatura, top-up, geração, submissão).
- **Leads e social** — fora do produto. Ver [negocio/canais-aquisicao.md](canais-aquisicao.md).
