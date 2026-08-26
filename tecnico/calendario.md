---
quando_usar: mexer em agendamento de prova (janela de resposta), calendário, notificação de abertura por e-mail, outbox, cron de notificações
última_revisão: 2026-08-25
status: canônico
---

# Calendário — agendamento de provas e notificação de abertura

Três peças que trabalham juntas: o **VO `ExamSchedule`** (no domínio `exam`), o domínio **`calendar`**
(visão de leitura) e o domínio **`exam-notification`** (envio dos e-mails de "atividade disponível"). É
uma feature **de assinante** — gateada pela `SubscriberAccessPolicy` compartilhada (a mesma da Biblioteca).

## Janela de resposta — `ExamSchedule` (VO no domínio `exam`)
Fonte: `apps/api/src/domains/exam/domain/exam-schedule.ts`. Campos:
- `availableFrom: Date | null` — abertura.
- `availableUntil: Date | null` — encerramento.
- `notifyOnOpen: boolean` — opta a atividade no e-mail-quando-abrir.

Regras: `create()` valida `availableFrom < availableUntil` (senão `ExamScheduleInvalidError`, 422). **Prova
sem schedule é sempre respondível** (comportamento legado preservado — `isEmpty()`). `availabilityAt(now)`
devolve `open | not_open_yet | closed`; `hasOpenedBy(now)` é o que o cron usa. O `Exam` carrega
`schedule` + um campo de rastreio `notificationsMaterializedAt` (marca que os jobs de e-mail já foram
criados, evita re-materializar). O professor define a janela no detalhe da prova
(`features/app/provas/components/schedule-activity-card.tsx` + `schedule-activity-dialog.tsx`).

## Domínio `calendar` — visão de leitura
Domínio **só de consulta**, sem persistência própria. `ListScheduledExamsUseCase` recebe
`{ ownerId, from, to }`, busca provas cuja `schedule.availableFrom` cai no intervalo
(`exams.findScheduledByOwner`), junta o nome da turma e devolve `ScheduledExamView[]` (id, title,
activityType, classId, className, availableFrom, availableUntil, shareId, notifyOnOpen).

- **Rota**: `GET /v1/calendar/exams?from&to` (ISO). Gate: `requireAuth` + `requireCalendarAccess`.
- **Acesso negado**: `CalendarAccessDeniedError` → **402** (`CALENDAR_ACCESS_DENIED`).
- **UI**: `/app/calendario` → `features/app/calendario/` (`calendar-view`, `month-grid`, `calendar-upsell`).
  Sem acesso, mostra upsell (`getCanAccessCalendar()` espelha a política no servidor web).

## Domínio `exam-notification` — outbox de e-mails (sem Redis)
**Outbox transacional em Mongo** (coleção `scheduledExamNotifications`) — não há Redis nem fila externa.

Entidade `ScheduledExamNotification` (uma linha por aluno): `examId`, `studentId`, `recipientEmail`
(snapshot do e-mail do aluno na materialização), `status`, `attempts`/`maxAttempts`, `lastError`,
`claimedAt`/`leaseExpiresAt` (lease), `sentAt`. `status` =
`pending | processing | sent | failed | skipped` (`skipped` = aluno sem e-mail). Índices: **único
`(examId, studentId)`** (idempotência), `(status, leaseExpiresAt)` (drain), `(examId, status)` (dashboard).

**Padrão lease**: `claimBatch(now, leaseMs, limit, examId?)` faz `findOneAndUpdate` atômico transicionando
`pending`/`failed`/`processing-com-lease-expirado` → `processing` com `leaseExpiresAt = now + leaseMs`.
Dois runs concorrentes nunca pegam a mesma linha. Envio é **isolado por job** — um destinatário ruim não
aborta o lote.

Use cases (`application/`):
- `DispatchExamWindowNotificationsUseCase` — **drain do cron**: acha provas prontas
  (`findReadyToNotify` = `notifyOnOpen` **e** `availableFrom != null` **e** `availableFrom <= now`
  **e** `notificationsMaterializedAt == null` **e** janela ainda não fechada — `availableUntil == null`
  ou `>= now`; ordenado por `availableFrom`, com limite),
  materializa os jobs (1 por aluno), marca a prova, dá `claimBatch` e envia. Devolve
  `{ materializedExams, claimed, sent, failed }`. **Idempotente** (índice único barra duplicata).
  Limites: `MATERIALIZE_LIMIT = 50`, `DRAIN_LIMIT = 100`, `LEASE_MS = 5 min`, `maxAttempts` default 5.
  Aluno sem e-mail nasce **`skipped`** já na materialização — não é transição posterior. Se a prova
  sumiu na hora do envio, o job é marcado `failed` com "Atividade não encontrada ao enviar."; sem nome
  de turma, o template usa o fallback "sua turma".
- `ResendExamNotificationsUseCase` — **reenvio manual do professor**: materializa se faltou, reseta os
  `failed` (`resetForRetry`), faz claim **só dessa prova** e reenvia.
- `GetExamNotificationStatusUseCase` — dashboard: `enabled`, `materialized`, `counts` por status,
  `items` por aluno (nome, e-mail, status, tentativas, erro, sentAt).

**E-mail**: `ResendExamNotificationMailer` reusa o transporte Resend do `iam` (`send-email`) e o template
`windowOpenTemplate` (assunto "Atividade disponível: …", CTA azul para `${WEB_ORIGIN}/exam/${shareId}`,
prazo formatado em `America/Sao_Paulo`). Não cria client Resend novo.

### Rotas
| Método/rota | Quem | Nota |
|---|---|---|
| `POST /v1/internal/dispatch-exam-window-notifications` | **cron** (header `x-cron-secret`) | Secret errado → **404** (não vaza existência); sem `CRON_SECRET` → **503** (`CRON_NOT_CONFIGURED`). |
| `GET /v1/exams/:examId/notifications` | professor (`requireAuth` + dono) | status/contagens. |
| `POST /v1/exams/:examId/notifications/resend` | professor (`requireAuth` + dono) | reenvio manual. |

A rota interna é montada nos **`routers` normais**, depois do `express.json()` — ela não precisa de
corpo cru. (Os `rawBodyRouters` só têm o webhook Stripe, o webhook NFE.io e o inbound de tickets.)
Wiring em `main.ts`: controller e use cases junto do bloco de `exam-notification`, e os routers no
array `routers` — o autenticado e o `makeExamNotificationInternalRouter`.

## Env e degradação
- `CRON_SECRET` (≥16) — gate da rota de dispatch. Sem ela, **só o reenvio manual do professor funciona**;
  o cron devolve 503. É a **mesma** env do `expire-credits` (ver [tecnico/integracoes.md](../tecnico/integracoes.md)).
- **Gotcha de ops**: o código está pronto, mas o **cron do Railway ainda não foi registrado** — até
  registrar (`POST .../dispatch-exam-window-notifications` com `x-cron-secret`, sugerido a cada 15 min/hora),
  a abertura automática não dispara e-mail sozinha; depende do botão de reenvio.

## Relações
- Vive **em cima** do `exam` (lê `schedule`/`notificationsMaterializedAt`); **não** acopla a `submission`
  (o e-mail é sobre a oportunidade, não sobre ter respondido). O gate de submissão por janela fica nos use
  cases de `begin-exam*` (`schedule.availabilityAt(now)`), não aqui.
- Acesso de assinante: `SubscriberAccessPolicy` (staff, membro de org, ou assinatura ativa) —
  **compartilhada com a Biblioteca** (ver [tecnico/biblioteca.md](../tecnico/biblioteca.md)). Custo: a feature **não debita crédito**.
