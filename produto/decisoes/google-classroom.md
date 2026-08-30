---
quando_usar: entender o estado real da integração com o Google Classroom (o que é feito, o que é código morto)
última_revisão: 2026-08-25
status: canônico
tags: [classroom]
---

# Integração Google Classroom

**Fase 1 feita**: OAuth próprio (separado do BetterAuth, `access_type=offline` + `prompt=consent`),
tokens cifrados em repouso (AES-256-GCM), importação de turmas/alunos com **reconciliação por e-mail**.
Fases 2 (enviar prova → `courseWorkId`) e 3 (passback de nota) estão **implementadas e testadas, mas
não wired**: `SendExamToClassroomUseCase` e `PushGradeToClassroomUseCase` existem com teste e não são
referenciados por controller, rota ou UI em lugar nenhum — e o cliente da API do Google para elas é
stub. Pela regra do projeto ("feature não wired não existe", ver
[regras/processo.md](../../regras/processo.md)), é **código morto** hoje, não feature engatilhada.

**Bloqueio**: projeto GCP ainda não criado (verificação OAuth leva semanas). Sem as envs, o card fica
indisponível (degradação graciosa).
