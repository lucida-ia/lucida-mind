---
quando_usar: integrar/depurar Stripe, PIX, NFE.io, Resend, Classroom, OMR, YouTube, PostHog, S3/Biblioteca, cron
última_revisão: 2026-06-30
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

## AbacatePay (PIX) — **DESATIVADO**
Top-up via PIX está **temporariamente desativado por kill-switch**: `PIX_TOPUP_ENABLED = false` em
`billing-controller.ts` faz o endpoint de criação lançar `PixTopupDisabledError` (503) **antes** de
checar config — ou seja, fica off mesmo com `ABACATEPAY_API_KEY`/`ABACATEPAY_WEBHOOK_SECRET` setados. O
web espelha o flag e **esconde** o botão PIX (`topups-section.tsx`). O **webhook**
(`/v1/billing/topup/webhook/abacatepay`) **continua vivo** para liquidar cobranças já emitidas — e cria a
wallet com `source = "topup"` (não há mais `source = "pix"`). **Reativar** = flipar `PIX_TOPUP_ENABLED`
nos dois lados (controller + componente).

## NFE.io (NFS-e)
Emissão de nota fiscal de serviço por transação de billing, idempotente por referência externa.
Envs: `NFEIO_API_KEY`, `NFEIO_BASE_URL` (default **sandbox** para não emitir por acidente),
`NFEIO_COMPANY_ID`, `NFEIO_WEBHOOK_HMAC_SECRET`. Domínio `invoicing`.

## Object storage — S3 / Railway Buckets (Biblioteca)
A **Biblioteca** (`library`) guarda os binários do professor fora da API: o browser sobe **direto ao S3**
via **presigned URL** (`@aws-sdk/client-s3` + `@aws-sdk/s3-request-presigner`; adapter S3-compatível com
`forcePathStyle: true` — serve S3 ou Railway Buckets). Envs: `LIBRARY_S3_ENDPOINT`, `LIBRARY_S3_BUCKET`,
`LIBRARY_S3_REGION` (default `us-east-1`), `LIBRARY_S3_ACCESS_KEY_ID`, `LIBRARY_S3_SECRET_ACCESS_KEY`,
`LIBRARY_UPLOAD_MAX_BYTES` (default 50 MB). Sem elas → `UnavailableFileStorage` devolve **503** e o resto
da api segue. **Gotcha**: o bucket precisa de **CORS** liberado ao `WEB_ORIGIN` (upload/download vêm do
browser; não há fallback de proxy). Detalhe em tecnico/biblioteca.md.

## Resend (e-mail) + Tickets Inbound
E-mails transacionais: verificação, reset, convites, recibos, form de ajuda e **notificação de abertura de
atividade** (domínio `exam-notification` — ver tecnico/calendario.md). Envs: `RESEND_API_KEY`,
`EMAIL_FROM`, `SUPPORT_EMAIL` (default `contato@lucidaexam.com`). **Resend Inbound** alimenta tickets de
suporte (`TICKETS_INBOUND_SECRET`, `TICKETS_FROM_EMAIL`) → fila staff no Kintal.

## Google Classroom
OAuth **próprio**, separado do BetterAuth (`access_type=offline` + `prompt=consent`), state HMAC-assinado;
tokens cifrados em repouso (**AES-256-GCM**). Importa turmas/alunos com reconciliação por e-mail; vínculo
em `class.classroomCourseId`. Envs: `CLASSROOM_OAUTH_CLIENT_ID/SECRET`, `CLASSROOM_OAUTH_REDIRECT_URI`
(opcional; default `${AUTH_BASE_URL}/v1/integrations/classroom/oauth/callback`), `CLASSROOM_TOKEN_ENC_KEY`
(≥32). Sem elas o card fica indisponível. Setup em
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
`YTDLP_COOKIES_FILE` e `YTDLP_COOKIES_B64` (cookies.txt em base64, para hosts como Railway que não montam
arquivo). Fallback JS frágil. Deploy Railway.

## PostHog (analytics + error tracking)
Cloud US. Web usa `posthog-js` com reverse proxy `/ingest/*` → `us.i.posthog.com`. API usa
`AnalyticsCaptureClient` **fire-and-forget** (nunca aguardada); sem `POSTHOG_API_KEY` vira no-op. Envs:
`POSTHOG_API_KEY` (sem ela → no-op), `POSTHOG_HOST` (default `https://us.i.posthog.com`). A aba "Produto"
de `/kintal/metricas` (HogQL/Query API) exige `POSTHOG_PERSONAL_API_KEY` + `POSTHOG_PROJECT_ID`, senão
503. Session replay e feature flags adiados.

## Public API + webhooks
API keys **HMAC** (`api-access`) gateiam `/v1/public/*` (`public-api`). Submissões finalizadas disparam
`submission.completed` para os endpoints cadastrados (`webhook-dispatch`).

## CRON interno
Endpoints internos protegidos pelo header `CRON_SECRET` (≥16). Sem a env → **503**; secret errado na rota
de notificações → **404** (não vaza existência). Disparados por scheduler do Railway.
- `POST /v1/internal/expire-credits` — expira wallets vencidas (billing).
- `POST /v1/internal/dispatch-exam-window-notifications` — drena o outbox de notificações de abertura de
  prova (`exam-notification`). **Ainda não registrado no Railway** — até registrar, só o reenvio manual do
  professor envia e-mail. Ver tecnico/calendario.md.
