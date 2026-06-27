---
quando_usar: integrar/depurar Stripe, PIX, NFE.io, Resend, Classroom, OMR, YouTube, PostHog, cron
última_revisão: 2026-06
status: canônico
---

# Integrações externas

Padrão geral: envs **opcionais** → sem elas, a feature degrada (503/502) mas o resto da api segue.
Fonte central de envs: `apps/api/src/env.ts`. Obrigatórias mínimas para subir: `MONGODB_URI`,
`AUTH_SECRET` (≥32), `AUTH_BASE_URL`, `WEB_ORIGIN`, `GOOGLE_CLIENT_ID/SECRET`, `RESEND_API_KEY`,
`EMAIL_FROM`, `OPENAI_API_KEY`.

## Stripe (assinatura + top-up)
Checkout/portal e webhook em `/v1/billing/webhook`. **Usa raw body** — montado antes do
`express.json()` (não reordenar). Envs: `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET` e os
`STRIPE_*_PRICE_ID` (basic/pro mensal/anual; topup 2k/5k/15k). Os créditos do plano vêm da tabela em
`billing/domain/plan.ts`, não do Stripe.

## AbacatePay (PIX)
Top-up via PIX (alternativa ao cartão). Envs: `ABACATEPAY_API_KEY`, `ABACATEPAY_WEBHOOK_SECRET`.
Webhook em `/v1/billing/topup/webhook/abacatepay`.

## NFE.io (NFS-e)
Emissão de nota fiscal de serviço por transação de billing, idempotente por referência externa.
Envs: `NFEIO_API_KEY`, `NFEIO_BASE_URL` (default **sandbox** para não emitir por acidente),
`NFEIO_COMPANY_ID`, `NFEIO_WEBHOOK_HMAC_SECRET`. Domínio `invoicing`.

## Resend (e-mail) + Tickets Inbound
E-mails transacionais: verificação, reset, convites, recibos, form de ajuda. Envs: `RESEND_API_KEY`,
`EMAIL_FROM`. **Resend Inbound** alimenta tickets de suporte (`TICKETS_INBOUND_SECRET`,
`TICKETS_FROM_EMAIL`) → fila staff no Kintal.

## Google Classroom
OAuth **próprio**, separado do BetterAuth (`access_type=offline` + `prompt=consent`), state HMAC-assinado;
tokens cifrados em repouso (**AES-256-GCM**). Importa turmas/alunos com reconciliação por e-mail; vínculo
em `class.classroomCourseId`. Envs: `CLASSROOM_OAUTH_CLIENT_ID/SECRET`, `CLASSROOM_OAUTH_REDIRECT_URI`,
`CLASSROOM_TOKEN_ENC_KEY` (≥32). Sem elas o card fica indisponível. Setup em
`docs/INTEGRACAO_GOOGLE_CLASSROOM.md`. **Fase 1 feita; 2/3 engatilhadas; bloqueio: projeto GCP.**

## OMR (serviço Python `services/omr`)
Proxy de `/v1/scan` para o serviço FastAPI (OpenCV). Pipeline: 4 ArUco → perspectiva → QR → fill-ratio;
QR por aluno (`LUCIDA1|examId|studentId`); preset A4 50×5. PDF gerado pelo servidor; scoring na API.
Envs: `OMR_SERVICE_URL`, `OMR_SERVICE_SECRET`, `OMR_SERVICE_TIMEOUT_MS` (default 60s). Sem URL → 502
via `UnavailableOmrClient`.

## YouTube transcript (serviço Python `services/youtube-transcript`)
Transcrição de vídeo (yt-dlp + Whisper) como fonte de conteúdo. Envs: `TRANSCRIPT_SERVICE_URL`,
`TRANSCRIPT_SERVICE_SECRET`, `TRANSCRIPT_SERVICE_TIMEOUT_MS` (default 180s). No serviço,
`YTDLP_PLAYER_CLIENTS` (default `android,web`) é obrigatório; escape hatches `YTDLP_PROXY`,
`YTDLP_COOKIES_FILE`. Fallback JS frágil. Deploy Railway.

## PostHog (analytics + error tracking)
Cloud US. Web usa `posthog-js` com reverse proxy `/ingest/*` → `us.i.posthog.com`. API usa
`AnalyticsCaptureClient` **fire-and-forget** (nunca aguardada); sem `POSTHOG_API_KEY` vira no-op.
A aba "Produto" de `/kintal/metricas` (HogQL/Query API) exige `POSTHOG_PERSONAL_API_KEY` +
`POSTHOG_PROJECT_ID`, senão 503. Session replay e feature flags adiados.

## Public API + webhooks
API keys **HMAC** (`api-access`) gateiam `/v1/public/*` (`public-api`). Submissões finalizadas disparam
`submission.completed` para os endpoints cadastrados (`webhook-dispatch`).

## CRON interno
`POST /v1/internal/expire-credits` (header `CRON_SECRET`) expira wallets vencidas. Sem env → 503.
