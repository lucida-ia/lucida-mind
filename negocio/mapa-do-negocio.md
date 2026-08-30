---
quando_usar: se orientar na área de negócio — por onde começar e como os quatro docs se encadeiam
última_revisão: 2026-08-30
status: canônico
---

# Mapa do negócio

Quatro docs. Eles respondem, nesta ordem: o que a Lucida é, como ela se apresenta, como cobra e para
quem vende.

## Ordem de leitura

1. **[negocio/visao-geral.md](visao-geral.md)** — o que é, os três problemas que ataca (criar prova,
   corrigir aberta, acompanhar desempenho) e o que entrega. É a porta de entrada da base inteira, não
   só desta área.
2. **[negocio/posicionamento.md](posicionamento.md)** — uma marca, três frentes por cor e qualificador.
   Define professor, instituição e aluno como públicos distintos.
3. **[negocio/monetizacao-creditos.md](monetizacao-creditos.md)** — assinatura mais consumo de
   créditos: planos, top-ups, créditos de boas-vindas, quem paga.
4. **[negocio/icp-beachhead.md](icp-beachhead.md)** — público-alvo. É `parcial` de propósito: só o que
   o código evidencia. ICP detalhado, wedge e GTM estão em rascunho e **não validados** — ver
   [rascunhos/negocio/icp-beachhead.md](../rascunhos/negocio/icp-beachhead.md).

## Onde esta área encosta nas outras

- **O preço é código.** Planos, créditos por ciclo e o kill-switch do PIX saem do
  `lucida-monorepo` e o `check-drift.sh` confere. A mecânica está em
  [tecnico/billing-ledger.md](../tecnico/billing-ledger.md); o par
  `monetizacao-creditos` ↔ `billing-ledger` é a metade comercial e a metade técnica do mesmo assunto.
- **As três frentes viram cor e tipografia** em [ui/identidade-visual.md](../ui/identidade-visual.md)
  e token CSS em [ui/design-tokens.md](../ui/design-tokens.md).
- **O que se pode afirmar publicamente** sobre tração e churn está em
  [regras/comunicacao.md](../regras/comunicacao.md).
- **O que a Lucida entrega hoje**, módulo a módulo, está em [produto/suite.md](../produto/suite.md).

## O que aqui é negócio puro

Preço de contrato institucional, tração e cenário competitivo não têm fonte no repositório e nenhum
script alcança. Tudo isso vive em `rascunhos/negocio/` e não vale como fato — convenção em
[rascunhos/LEIA-ME.md](../rascunhos/LEIA-ME.md).

---

Outras áreas: [produto/mapa-do-produto.md](../produto/mapa-do-produto.md) · [tecnico/mapa-tecnico.md](../tecnico/mapa-tecnico.md) · [ui/mapa-da-ui.md](../ui/mapa-da-ui.md) · [regras/mapa-das-regras.md](../regras/mapa-das-regras.md)
