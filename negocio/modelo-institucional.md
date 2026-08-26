---
quando_usar: discutir preço institucional, canal parceiro vs. direto, desconto por volume, GTM professor-led
última_revisão: 2026-08-25
status: rascunho
---

# Modelo institucional

> **Rascunho — nunca validado.** Preços e faixas são de jun/2026 e ninguém do time conferiu. **Não
> cotar cliente com esta tabela.** Nada disso está no código: o produto só conhece os quatro planos
> individuais, e contrato institucional é negociado fora do sistema, liquidado com crédito manual no
> escopo `org` da carteira.

## Precificação

### Canal parceiro (hoje)
R$ 149,90/mês **líquido para a Lucida** = ~30% do que o cliente paga ao parceiro (~R$ 500).
O parceiro retém 70%.

### Preço direto-alvo
Start × 10 professores × 0,75 (25% off) = **R$ 374,25/mês**.
Vender direto captura ~2,5× mais que pelo canal parceiro atual.

### Faixas por volume (direto)

| Faixa | Desconto | Preço/prof | Receita/mês | Margem |
|---|---|---|---|---|
| 10 profs | 25% | R$ 37,42 | R$ 374,25 | ~81% |
| 20 profs | 32% | R$ 33,93 | R$ 678,64 | ~85% |
| 30 profs | 38% | R$ 30,94 | R$ 928,14 | ~86% |
| 40 profs | 45% | R$ 27,45 | R$ 1.097,80 | ~86% |
| 50 profs | 50% | R$ 24,95 | R$ 1.247,50 | ~86% |

O desconto não derruba a margem (custo de IA é centavos). Desconto é arma comercial, não sacrifício
— há folga para ser agressivo em redes grandes.

## GTM professor-led (a motion institucional)

```
Professor adota (gancho de eficiência)
  → ama o produto
  → vira afiliado
  → pressiona a instituição a adquirir
  → instituição implanta para os demais professores
  → instituição fornece acesso ao aluno
```

**Ordem importa:** o movimento institucional é *downstream* do amor do professor pelo produto.
Não empurrar a venda institucional antes de o gancho de eficiência do professor estar cravado.

## O que já existe no produto

- **Organização** = `organization` do plugin do BetterAuth. `organizationId = null` → professor
  individual. Convite por e-mail com aceite em `/accept-invite`.
- **Pooling de créditos por org**: a `CreditWallet` tem `scope` (`user` | `org`) — a instituição
  banca o consumo dos professores membros. Ver [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).
- **Dashboard de instituição** (`/analytics`, frente roxa): overview, professor, turma, aluno, prova
  e membros; envio de notificações pelo admin da org; preferências por organização.
- **Kintal** tem visão de instituição (`/kintal/instituicoes/[orgId]`) para o time operar contratos.

## O que ainda não existe

- **Plano institucional como SKU** — sem faixa por volume, sem assinatura de org no Stripe.
- **Área do aluno** — o aluno não tem login hoje (ver [regras/produto.md](../regras/produto.md)).
- **Modelo multi-tenant fechado** — proposto no ADR de mesmo nome (instituição = `organization`,
  org-padrão por professor, `organizationId` obrigatório, roles owner/admin/secretary/teacher, aluno
  como usuário só-por-convite). Está **em branch, não no `main`**. É a fundação da milestone
  "Instituição".

## LGPD e dado do aluno

A instituição é a **camada de consentimento LGPD** para o dado do aluno menor.
`organizationId` no modelo de dados é o controlador de dado; o professor avulso responde como
controlador individual. Detalhe: [produto/suite.md](../produto/suite.md) §ambiente-do-aluno.
