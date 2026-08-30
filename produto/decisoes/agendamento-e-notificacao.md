---
quando_usar: entender por que o agendamento usa outbox em Mongo e não fila, e o bloqueio de ops do cron
última_revisão: 2026-08-25
status: canônico
tags: [billing]
---

# Agendamento de prova + notificação por e-mail

A prova ganhou **janela de resposta** (abre/fecha) e a opção de **avisar os alunos por e-mail quando abrir**.
Decisões: o envio usa um **outbox em Mongo** (uma linha por aluno) — **sem Redis nem fila externa**, para
não somar infra; idempotência por índice único `(examId, studentId)` e **lease** para o drain não duplicar
em runs concorrentes; o disparo é por **cron do Railway** batendo num endpoint interno (`CRON_SECRET`), com
**reenvio manual** pelo professor como rede de segurança. É **feature de assinante** (mesma política da
Biblioteca).

**Bloqueio de ops**: o cron ainda não foi registrado no Railway — até lá, só o reenvio manual
dispara e-mail. Mecânica em [tecnico/calendario.md](../../tecnico/calendario.md).
