---
destino: negocio/modelo-institucional.md (arquivo novo)
acao: criar
origem: contexto-externo.md §6
quando_usar: discutir preço institucional, canal parceiro vs. direto, desconto por volume, GTM professor-led
última_revisão: 2026-06
status: rascunho
---

# Modelo institucional

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

## LGPD e dado do aluno

A instituição é a **camada de consentimento LGPD** para o dado do aluno menor.
`organizationId` no modelo de dados é o controlador de dado; o professor avulso responde como
controlador individual. Detalhe: produto/suite.md §ambiente-do-aluno.
