---
quando_usar: consultar a taxonomia de eventos PostHog (nome, propriedades, onde dispara), montar funil/insight, instrumentar evento novo
última_revisão: 2026-06-29
status: canônico
---

# Eventos PostHog

Taxonomia de produto da Lucida. Setup, envs e degradação ficam em
tecnico/integracoes.md (seção PostHog) — aqui é **o que** medimos.

**Duas fontes, uma taxonomia.** Nome dos eventos em `snake_case` inglês, espelhado nos dois lados:
- **API (server-side)** — `apps/api/src/shared/observability/event-names.ts`. Eventos de **funil
  e dinheiro** (signup, assinatura, top-up, geração, submissão, biblioteca) capturados no servidor
  por **confiabilidade** (não dependem do browser nem de ad-blocker). Cliente `AnalyticsCaptureClient`
  é **fire-and-forget**: nunca é aguardado e nunca lança erro no fluxo de negócio. Sem `POSTHOG_API_KEY`
  vira no-op (`UnavailableAnalyticsClient`).
- **Web (client-side)** — `apps/web/src/features/analytics/events.ts`. Ações de **UI in-app**.
  Wrapper `capture()` é no-op seguro quando o PostHog não inicializou (sem key). Hoje **só um
  subconjunto está instrumentado**; o resto da taxonomia é o conjunto planejado.

Toda captura server-side usa `distinctId = ownerId` (id BetterAuth do dono) e, quando há org,
manda `groups: { organization: orgId }` para habilitar **group analytics** por instituição.

---

## Eventos da API (server-side) — sempre disparam

| Evento | Dispara quando | Propriedades |
|---|---|---|
| `user_signed_up` | Novo usuário criado (hook `onUserCreated` da auth). | — (só `distinctId`) |
| `subscription_started` | Webhook Stripe confirma assinatura ativa. | `planId`, `status` |
| `subscription_canceled` | Webhook Stripe de assinatura deletada. | `planId` |
| `topup_purchased` | Compra de créditos avulsos liquidada (webhook Stripe **ou** AbacatePay). | `topupId`, `credits`, `amountCents`, `provider` (`"stripe"` \| `"abacatepay"`) |
| `ai_generation_completed` | Geração de IA conclui — **prova ou plano de aula**. | `kind` (`"exam"` \| `"lesson_plan"`), `inputTokens`, `outputTokens`, `creditsCharged`, `durationMs`. **Exam** ainda: `language`, `style`, `questionCount`. **Lesson plan** ainda: `segment`. |
| `submission_completed` | Submissão de prova finalizada. | `examId`, `gradingStatus`, `score`, `source` |
| `library_file_uploaded` | Upload na Biblioteca confirmado (presigned S3). | `fileType`, `sizeBytes`, `mimeType` |
| `library_file_extraction_succeeded` | Extração de texto do arquivo concluída. | `fileType`, `sizeBytes`, `pageCount`, `wordCount`, `durationMs` |
| `library_file_extraction_failed` | Extração de texto falhou. | `fileType`, `reason` |
| `library_file_used_in_generation` | Arquivo da Biblioteca usado como fonte de uma geração. | `generationKind`, `fileType`, `sizeBytes`, `pageCount`, `subject` |

Os eventos de `library_*` mandam `groups: { organization }` quando o arquivo tem org.

---

## Eventos do Web (client-side)

### Instrumentados hoje

| Evento | Dispara quando | Propriedades |
|---|---|---|
| `class_created` | Professor cria uma turma dentro de um curso. | — |
| `exam_created` | Prova criada no fim do wizard (step review). | `examId`, `questionCount`, `style`, `source` (`"ai"` \| `"manual"`) |
| `onboarding_tour_started` | Tour de onboarding inicia. | `source` |
| `onboarding_tour_step_viewed` | Passo do tour visto (coachmark desktop). | `step_id`, `step_index` |
| `onboarding_tour_completed` | Tour concluído até o fim. | `source` |
| `onboarding_tour_skipped` | Tour pulado. | `step_id`, `step_index`, `source` |

### Definidos na taxonomia, **ainda não instrumentados** (planejados)

`signed_in`, `student_added`, `exam_generation_started`, `exam_published`, `exam_link_shared`,
`public_exam_started`, `grading_started`, `grading_approved`, `scanner_used`, `lesson_plan_created`,
`lesson_plan_exported`, `classroom_connected`, `support_request_sent`.

> Esses nomes existem em `events.ts` mas nenhum `capture()` os dispara ainda — são o conjunto-alvo.
> Não assuma que aparecem no PostHog.

---

## Identidade, grupos e eventos automáticos

- **Identify (web).** `usePosthogIdentity` sincroniza pessoa/grupo com a sessão BetterAuth:
  `identify(user.id, { email, role })` no login, `group("organization", orgId, { name })` na org
  ativa, `reset()` no logout.
- **`person_profiles: "identified_only"`** — tráfego anônimo (prova pública, marketing) **não** gera
  perfil de pessoa.
- **Pageviews/pageleave + autocapture** ligados via `defaults: "2025-05-24"` (App Router-aware).
- **Error tracking.** Web envia exceções JS não tratadas (`capture_exceptions: true`). API captura
  `captureException` nos handlers de processo (`uncaughtException`, `unhandledRejection`).
- **Session replay: desligado** (`disable_session_recording: true`); feature flags adiados.

## Onde os eventos são lidos

A aba **"Produto"** de `/kintal/metricas` consome esses eventos via HogQL/Query API
(`POSTHOG_PERSONAL_API_KEY` + `POSTHOG_PROJECT_ID`; sem elas → 503).
