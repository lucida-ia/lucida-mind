---
destino: negocio/monetizacao-creditos.md
acao: substituir (adiciona framing pay-to-use, fórmula de créditos, unit economics, custos fixos)
origem: contexto-externo.md §5
quando_usar: falar de preços, planos, top-ups, créditos, modelo de receita, unit economics
última_revisão: 2026-06
status: rascunho
---

# Monetização — assinatura + créditos

**Lógica central (pay-to-use):** a assinatura é o **barateamento por fidelização** do consumo de
créditos — não uma taxa de acesso. Créditos renovam mensalmente com o plano (não acumulam entre
ciclos). Para consumir acima da franquia, o usuário evolui de faixa ou compra avulso.

> Mecânica técnica de wallet/ledger/débito e o custo exato por operação ficam em
> tecnico/billing-ledger.md. Aqui é o modelo comercial.

## Planos

| Plano | Preço/mês | Créditos/mês | Anual (−20%) |
|---|---|---|---|
| Básico | R$ 49,90 | 5.000 | ~R$ 39,90/mês |
| Pro | R$ 99,90 | 15.000 | ~R$ 79,90/mês |

Todos: alunos e provas ilimitados, correção automática ilimitada, análises por turma e aluno.

## Top-ups (avulsos)

Para esgotamento fora do ciclo. Mesmos pacotes via **Stripe (cartão)** e **PIX (AbacatePay)**.
Validade de **365 dias**.

| Pacote | Créditos | Preço | R$/crédito |
|---|---|---|---|
| Início | 2.000 | R$ 29,90 | R$ 0,01495 |
| Plus | 5.000 | R$ 59,90 | R$ 0,01198 |
| Power | 15.000 | R$ 149,90 | R$ 0,00999 |

## Trial (créditos de boas-vindas)

Todo usuário novo recebe créditos de boas-vindas no cadastro — **2.000 créditos**. É idempotente:
retry não duplica. Custo de servir ≈ R$ 0,17 — calibrar por ativação/conversão, não por custo.

## Fórmula de consumo

```
Créditos = base 250 + (custo/questão × nº de questões)
```

| Tipo / Estilo | Custo/questão | 10q | 20q | 50q |
|---|---|---|---|---|
| Objetiva simple | 25 | 500 | 750 | 1.500 |
| Objetiva analytical | 42 | 670 | 1.090 | 2.350 |
| Objetiva reflective / contextual | 45 | 700 | 1.150 | 2.500 |
| Discursiva (1–30q) | 60 | 850 | 1.450 | 2.050 (30q) |

**Plano de aula (backbone):** ≤ 30% do custo de uma prova equivalente (~210 créditos pela referência
de uma prova reflective de 10q = 700). Deliberadamente barato para maximizar densidade de dado —
monetiza-se o output (prova, slides) e os assentos, nunca o backbone.

## Unit economics

**Custo de IA (GPT-4.1 mini — $0,40/M input, $1,60/M output; câmbio ~R$ 5,70):**
- Prova objetiva reflective de 10q: ~R$ 0,06.
- Prova-livro extrema (50q analytical + 324 págs): ~R$ 0,26.
- Custo de IA por professor: R$ 0,18–1,65/mês mesmo em uso 100% pesado (< 2% da receita).
- O teto de créditos do plano é o teto natural de custo.

**Custos fixos (~R$ 3.010/mês):**
| Item | Valor |
|---|---|
| Colaborador | R$ 1.560 |
| Pró-labore founders | R$ 0 (remuneram-se em outros negócios) |
| Marketing | R$ 1.000 (30% institucional / 70% B2C) |
| Infra/hosting | R$ 150 (semi-fixo, escala lentamente) |
| Outros | R$ 300 |

**Variáveis:** gateway ~4,5% da receita · Simples Nacional 6%.

**Break-even:** dezenas de pagantes no preço de tabela. Maior alavanca: fechar a defasagem entre
ticket realizado histórico (R$ 18,74) e preço de tabela atual (R$ 49,90+).

## Faturamento fiscal

Cada transação pode gerar **NFS-e via NFE.io**, idempotente por referência externa.
Detalhe em tecnico/integracoes.md e domínio `invoicing`.
