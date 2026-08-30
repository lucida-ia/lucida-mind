---
quando_usar: entender o nível de ensino e os objetivos da turma, e a armadilha do enum de stage
última_revisão: 2026-08-25
status: canônico
---

# Nível e objetivos da turma

A turma deixou de ter só "série" e passou a carregar **nível de ensino** (stage `FUNDAMENTAL`/`MEDIO`/
`SUPERIOR`/`CUSTOM` + série livre) e **objetivos de aprendizagem** (BNCC ou personalizados) — contexto que
alimenta geração e análises. Atenção ao **enum de stage da turma ser diferente do Segment** do plano de
aula/Biblioteca (`FACULDADE`/`INFOPRODUTOR`). Gotcha de implementação (salvar apaga se não popular ambos)
em [tecnico/dominios.md](../../tecnico/dominios.md); os dois enums lado a lado em
[produto/glossario.md](../glossario.md).
