---
quando_usar: entender por que o analytics é um cubo parametrizável e não relatórios fixos
última_revisão: 2026-08-25
status: canônico
tags: [analytics]
---

# Analytics como "cubo" parametrizável

Motor de analytics **calculado on-read** (sem materialização — volume baixo justifica), parametrizado
por escopo + corte (breakdown) + filtros + período. **Discriminação de item** usa o **índice dos 27%**
(grupos superior/inferior; split na mediana quando N<10). **Habilidades BNCC por questão** ficaram no
**roadmap** (as questões ainda não carregam tag de habilidade). Endpoints legados continuam vivos; a
contração para o cubo é faseada. Front novo em `features/analytics-cube`.

Os parâmetros de escopo e corte estão em [produto/glossario.md](../glossario.md) (`CubeScope`,
`CubeBreakdown`).
