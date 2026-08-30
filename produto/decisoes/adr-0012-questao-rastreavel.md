---
quando_usar: consultar o que o ADR-0012 decidiu sobre a questão como objeto rastreável
última_revisão: 2026-08-25
status: canônico
---

# ADR-0012 — a questão como objeto rastreável

> Status `proposto`, em branch no `lucida-monorepo`. **Não implementado.**

Cada questão recebe um **`questionId` estável** embutido no snapshot do `Exam`; a metadata pedagógica
mutável (`kc[]`, `kc_status`, `family_id`, `nivel_cognitivo`, `distrator_diagnostico`) vive num **novo
bounded context `learning-object`** — a Q-matrix, um documento por `questionId`; e a `Submission` passa
a persistir o `questionId` de cada resposta, além do índice posicional.

O `Exam` continua **snapshot imutável** — reeditar questão nunca pode mudar nota histórica.

**Escopo:** só a Fase 0→1. Não decide BKT, feedback nem área do aluno.

Detalhe do schema e a razão de a metadata viver fora do `Exam` em
[produto/objeto-de-aprendizagem.md](../objeto-de-aprendizagem.md). Entidades atuais em
[tecnico/dominios.md](../../tecnico/dominios.md).
