---
quando_usar: integrar/depurar Stripe, PIX, NFE.io, Resend, Classroom, OMR, YouTube, PostHog, S3/Biblioteca, cron, lead público, demo institucional
última_revisão: 2026-10-22
status: canônico
tags: [analytics, billing, classroom, omr]
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
(`POST /v1/billing/abacatepay/webhook`) **continua vivo** para liquidar cobranças já emitidas — e cria a
wallet com `source = "topup"` (não há mais `source = "pix"`). **Reativar** = flipar `PIX_TOPUP_ENABLED`
nos dois lados (controller + componente).

O `ABACATEPAY_WEBHOOK_SECRET` chega como **query param** `?webhookSecret=`, não header nem corpo cru —
por isso o router do AbacatePay traz um `express.json()` local em vez de entrar nos `rawBodyRouters`.

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
browser; não há fallback de proxy). Detalhe em [tecnico/biblioteca.md](biblioteca.md).

## Resend (e-mail) + Tickets Inbound
E-mails transacionais: verificação, reset, convites, recibos, form de ajuda e **notificação de abertura de
atividade** (domínio `exam-notification` — ver [tecnico/calendario.md](calendario.md)). Envs: `RESEND_API_KEY`,
`EMAIL_FROM`, `SUPPORT_EMAIL` (default `contato@lucidaexam.com`). **Resend Inbound** alimenta tickets de
suporte (`TICKETS_INBOUND_SECRET`, `TICKETS_FROM_EMAIL`) → fila staff no Kintal.

## Google Classroom
OAuth **próprio**, separado do BetterAuth (`access_type=offline` + `prompt=consent`), state HMAC-assinado;
tokens cifrados em repouso (**AES-256-GCM**). Importa turmas/alunos com reconciliação por e-mail; vínculo
em `class.classroomCourseId`. Envs: `CLASSROOM_OAUTH_CLIENT_ID/SECRET`, `CLASSROOM_OAUTH_REDIRECT_URI`
(opcional; default `${AUTH_BASE_URL}/v1/integrations/classroom/oauth/callback`), `CLASSROOM_TOKEN_ENC_KEY`
(≥32). Sem elas o card fica indisponível. Setup em
`docs/INTEGRACAO_GOOGLE_CLASSROOM.md`. **Fase 1 feita; 2/3 implementadas mas não wired (código morto, cliente da API é stub); bloqueio:
projeto GCP.**

## OMR (serviço Python `services/omr`)
Proxy de `/v1/scan` para o serviço FastAPI (OpenCV). Pipeline: 4 ArUco → perspectiva → QR → fill-ratio;
QR por aluno (`LUCIDA1|examId|studentId`); preset A4 50×5. PDF gerado pelo servidor; scoring na API.
Envs: `OMR_SERVICE_URL`, `OMR_SERVICE_SECRET`, `OMR_SERVICE_TIMEOUT_MS` (default 60s). Sem URL → 502
via `UnavailableOmrClient`.

## YouTube transcript (serviço Python `services/youtube-transcript`)
Transcrição de vídeo em dois tiers: primeiro tenta a legenda via `yt-dlp`; sem legenda, baixa o áudio
e chama a **API de transcrição da OpenAI** (`WHISPER_MODEL`). Não há Whisper local. Envs: `TRANSCRIPT_SERVICE_URL`,
`TRANSCRIPT_SERVICE_SECRET`, `TRANSCRIPT_SERVICE_TIMEOUT_MS` (default 180s). No serviço,
`YTDLP_PLAYER_CLIENTS` tem default `android,web` (não é obrigatório); escape hatches `YTDLP_PROXY`,
`YTDLP_COOKIES_FILE` e `YTDLP_COOKIES_B64` (cookies.txt em base64, para hosts como Railway que não montam
arquivo). Fallback JS frágil. Deploy Railway.

## PostHog (analytics + error tracking)
Taxonomia de eventos em [tecnico/eventos-posthog.md](eventos-posthog.md). Cloud US. O web usa `posthog-js` atrás de um reverse proxy de **dois** rewrites —
`/ingest/static/*` → `us-assets.i.posthog.com` (assets) e `/ingest/*` → `us.i.posthog.com` (ingestão) —
mais `skipTrailingSlashRedirect: true` e `ui_host: "https://us.posthog.com"`. Envs do web:
`NEXT_PUBLIC_POSTHOG_KEY` e `NEXT_PUBLIC_POSTHOG_HOST` (default `/ingest`). API usa
`AnalyticsCaptureClient` **fire-and-forget** (nunca aguardada); sem `POSTHOG_API_KEY` vira no-op. Envs:
`POSTHOG_API_KEY` (sem ela → no-op), `POSTHOG_HOST` (default `https://us.i.posthog.com`). A aba "Produto"
de `/kintal/metricas` (rota real `GET /api/kintal/metrics/behavior`, via HogQL/Query API) exige `POSTHOG_PERSONAL_API_KEY` + `POSTHOG_PROJECT_ID`, senão
503. Session replay e feature flags adiados. **O SDK do web não inicializa em `/exam/**` nem em `/aluno`**
(prova pública e Área do Aluno); perfis anônimos dependem de `NEXT_PUBLIC_POSTHOG_ANON_PROFILES` — detalhe
em [tecnico/eventos-posthog.md](eventos-posthog.md).

## NFE.io — rotas
Webhook `POST /v1/invoicing/webhook`, montado nos **`rawBodyRouters`** para o HMAC ver os bytes exatos.
Consulta: `GET /v1/invoicing/me` e `GET /v1/invoicing/organization` (org admin).

## Public API + webhooks
API keys **HMAC** (`api-access`) gateiam `/v1/public/*` (`public-api`) — com duas exceções sem
autenticação: a prova pública (`/v1/public/exams/*`) e o lead (`/v1/public/leads`, abaixo). Submissões finalizadas disparam
`submission.completed` — o **único** evento da lista — para os endpoints cadastrados
(`webhook-dispatch`). A API pública também gera prova por IA de forma assíncrona: `POST` devolve 202 +
`jobId` e o parceiro faz polling; jobs órfãos são retomados pelo cron de resgate abaixo.

## Lead público (`POST /v1/public/leads`)
Domínio `lead` (ADR-0016). Endpoint **sem autenticação**, pensado para um único chamador: a Server
Action do `apps/demo`, que chama **servidor a servidor** porque a api só libera CORS para `WEB_ORIGIN`.
Router próprio montado antes do `express.json()` global, com limite de corpo de **16 kb**.

| Campo | Regra |
|---|---|
| `name` | 2–120 caracteres |
| `institution` | 2–200 caracteres |
| `institutionType` | `school \| prepCourse \| university \| network \| other` |
| `email` | e-mail válido, ≤200, normalizado para minúsculas |
| `phone` | **obrigatório**, telefone BR: 10 ou 11 dígitos depois de tirar a máscara (fixo ou celular), gravado só com dígitos |
| `message` | opcional, ≤2.000 |
| `persona` | `k12 \| prepCourse \| university` ou `null` — o dataset que o visitante explorou na demo |
| `source` | opcional, ≤60; default `institutional-demo` |
| `website` | **honeypot**: preenchido → responde 204 e não grava nada (bot nunca sabe que foi pego) |

Sucesso é **204 sem corpo**. Corpo inválido → 400 `INVALID_BODY` sem listar os campos. Estouro de
limite → **429** `LEAD_THROTTLED`.

**Rate limit em janela fixa de 1 hora**, contador atômico na coleção `lead_rate_counters` (expira por
TTL). Três chaves, cobradas nesta ordem: **10 por fingerprint** do visitante, **3 por e-mail**,
**200 no total** (teto global, para um formulário público não esgotar a cota da Resend que entrega
verificação de e-mail e reset de senha). A fingerprint é `sha256` do IP com chave derivada por HKDF do
`AUTH_SECRET`; o IP cru nunca é gravado. Como a chamada vem do container da demo, o IP real chega no
header `x-lucida-client-ip`, aceito só com `x-lucida-forward-auth` igual a **`LEAD_FORWARD_CREDENTIAL`**
(≥16, mesmo valor na api e na demo, diferente de `WEB_FORWARD_CREDENTIAL`). **Sem ela, o limite por
visitante vira teto global**: todos os visitantes compartilham o IP do container e o 11º lead da hora
leva 429.

O lead é gravado na coleção **`leads`**, que **expira por TTL em 90 dias**. A entrega de verdade é o
e-mail: depois de gravar, a api avisa via Resend para **`LEADS_NOTIFY_EMAIL ?? SUPPORT_EMAIL`**; falha no
envio é logada e não perde o lead. **Nenhuma tela lê os leads** — nem Kintal nem web.

## Demo institucional (`apps/demo`)
Workspace próprio (`@lucida/demo`, ADR-0015) com o link de venda para escola, cursinho e universidade:
hero, três capítulos interativos (criar, aplicar/corrigir, analisar) sobre **dados fictícios** por
persona e formulário de contato. Não tem sessão, não lê dado de professor e não chama IA. É
**self-contained** — copia tokens e primitivos do `apps/web` e nunca importa de `@lucida/web`. Deploy
separado na Railway (`docker/demo.Dockerfile`), domínio próprio; porta 3001 só no dev.

| Env | Para quê |
|---|---|
| `DEMO_API_URL` | **Server-only.** Base da api para onde a Server Action manda o lead. Sem ela o formulário não entrega |
| `LEAD_FORWARD_CREDENTIAL` | **Server-only.** Mesmo valor da api; habilita o repasse do IP do visitante |
| `NEXT_PUBLIC_POSTHOG_KEY` / `NEXT_PUBLIC_POSTHOG_HOST` | PostHog da demo — init próprio, reverse proxy `/ingest` próprio, sem `identify`. Sem key, o SDK não sobe |

A demo tem taxonomia própria de eventos `demo_*` — ver [tecnico/eventos-posthog.md](eventos-posthog.md).

## CRON interno
Quatro endpoints `/v1/internal/*`, todos protegidos pelo header `x-cron-secret` contra `CRON_SECRET`
(≥16). Comportamento uniforme nas quatro: **sem a env → 503** (`CRON_NOT_CONFIGURED`); **secret errado
→ 404**, para não vazar a existência da rota. Disparados por scheduler do Railway.

- `POST /v1/internal/expire-credits` — expira wallets vencidas (billing). Devolve
  `{ scanned, expired, creditsExpired }` e grava ledger com `reason: "expiration"`.
- `POST /v1/internal/dispatch-exam-window-notifications` — drena o outbox de notificações de abertura de
  prova (`exam-notification`). **Ainda não registrado no Railway** — até registrar, só o reenvio manual do
  professor envia e-mail. Ver [tecnico/calendario.md](calendario.md).
- `POST /v1/internal/invoicing/process-pending` — emite as NFS-e pendentes (`invoicing`).
- `POST /v1/internal/rescue-exam-generation` — retoma jobs de geração órfãos da API pública. Sem esse
  cron agendado, job interrompido fica travado.
