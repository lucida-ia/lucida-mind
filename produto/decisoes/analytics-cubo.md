---
quando_usar: entender por que o analytics é um cubo parametrizável e não relatórios fixos
última_revisão: 2026-10-22
status: canônico
tags: [analytics]
---

# Analytics como "cubo" parametrizável

Motor de analytics **calculado on-read** (sem materialização — volume baixo justifica), parametrizado
por escopo + corte (breakdown) + filtros + período. **Discriminação de item** usa o **índice dos 27%**
(grupos superior/inferior; split na mediana quando N<10). Endpoints legados continuam vivos; a
contração para o cubo é faseada. Front novo em `features/analytics-cube`.

Todo recorte sai com um selo **Confiável** ou **Direcional** pelo número de respondentes: Confiável a
partir de 15 (`RELIABLE_MIN_N`). O domínio por critério de rubrica tem dois modos: por prova, ou por
nome do critério entre provas — este sempre Direcional, porque não há taxonomia comum.

**Corte por habilidade:** modelado, sempre vazio (`bySkill: []` com a nota "BNCC ainda não mapeado
nas questões"), porque as questões não carregam habilidade. Quem preenche é a Fase 4 do épico #141
(conhecimento-chave por questão, em construção) — ver
[produto/decisoes/indicadores-por-kc.md](indicadores-por-kc.md).

Os parâmetros de escopo e corte estão em [produto/glossario.md](../glossario.md) (`CubeScope`,
`CubeBreakdown`).
