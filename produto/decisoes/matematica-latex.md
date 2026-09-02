---
quando_usar: entender como fórmula matemática entra na questão e por que existe pipeline de reparo
última_revisão: 2026-08-25
status: canônico
tags: [ia]
---

# Matemática nas questões (LaTeX + KaTeX)

Fórmulas são **LaTeX inline no texto** da questão (sem campo dedicado), renderizadas com **KaTeX**. Como o
modelo às vezes devolve LaTeX que o `JSON.parse` corrompe (barras viram caracteres de controle), a geração
passa por um **pipeline de normalização/reparo** (inclui reescrever comandos em pt-BR como `\sen`/`\tg`), e
um **backfill** repara provas antigas. Mecânica em [tecnico/ai-ops.md](../../tecnico/ai-ops.md).
