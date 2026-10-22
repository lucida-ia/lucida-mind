---
quando_usar: consultar o que o ADR da questão rastreável (ADR-0012 na base) propôs e por que o épico #141 o substituiu para KC
última_revisão: 2026-10-22
status: canônico
---

# ADR-0012 — a questão como objeto rastreável

> **Parado.** No monorepo o texto é o **ADR 0009**, só na branch `adr/0010-multi-tenant-institution`
> (ago/2026), status `proposto`, nunca mesclado. Não existe arquivo 0012 em nenhuma branch. Para KC, foi
> substituído pelo contrato do épico #141. **Não implementado.**

O que propunha: cada questão recebe um **`questionId` estável** embutido no snapshot do `Exam`; a
metadata pedagógica mutável (`kc[]`, `kc_status`, `family_id`, `nivel_cognitivo`,
`distrator_diagnostico`) vive num bounded context `learning-object` — a Q-matrix, um documento por
`questionId`; e a `Submission` passa a persistir o `questionId` de cada resposta, além do índice
posicional. Escopo só da Fase 0→1: não decidia BKT, feedback nem área do aluno.

O que sobreviveu no #141: a metadata pedagógica fora do `Exam` (corrigir KC não muda nota já dada) e a
necessidade de id estável por questão, que virou a issue #135 (aberta) e é pré-requisito da Fase 2 do
épico. O que caiu: o domínio `learning-object`, o `family_id`, o nível cognitivo e o distrator
diagnóstico gravados. No lugar, um catálogo de conceitos por organização (domínio `knowledge`) e um
fato imutável por resposta.

Detalhe do #141 e comparação com o schema proposto em
[produto/objeto-de-aprendizagem.md](../objeto-de-aprendizagem.md). Entidades atuais em
[tecnico/dominios.md](../../tecnico/dominios.md).
