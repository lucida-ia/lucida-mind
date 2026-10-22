---
quando_usar: consultar a taxonomia de eventos PostHog (nome, propriedades, onde dispara), montar funil/insight, instrumentar evento novo
última_revisão: 2026-10-22
status: canônico
tags: [analytics]
---

# Eventos PostHog

Taxonomia de produto da Lucida. Setup, envs e degradação ficam em
[tecnico/integracoes.md](integracoes.md) (seção PostHog) — aqui é **o que** medimos.

**Duas fontes, uma taxonomia.** Nome dos eventos em `snake_case` inglês, espelhado nos dois lados:
- **API (server-side)** — `apps/api/src/shared/observability/event-names.ts`. Eventos de **funil
  e dinheiro** (cadastro, login, ativação, assinatura, top-up, geração, submissão, Classroom,
  biblioteca) capturados no servidor por **confiabilidade** (não dependem do browser nem de
  ad-blocker). Cliente `AnalyticsCaptureClient` é **fire-and-forget**: nunca é aguardado e nunca lança
  erro no fluxo de negócio. Sem `POSTHOG_API_KEY` vira no-op (`UnavailableAnalyticsClient`).
- **Web (client-side)** — `apps/web/src/features/analytics/events.ts`. Ações de **UI in-app**.
  Wrapper `capture()` é no-op seguro quando o PostHog não inicializou.
  **Todo nome da taxonomia tem call site**, e `events.test.ts` falha se algum ficar sem.

**A regra de lado (ADR-0017): o web enxerga a intenção, o servidor enxerga o fato; quando divergem, o
evento é do servidor.** Por isso `signed_in` e `classroom_connected` são server-side.

O `distinctId` é sempre o id BetterAuth de uma pessoa — nunca do aluno anônimo: o **dono da prova**
em `submission_completed`, `user_activated` e `ai_generation_completed`; o próprio usuário em
`user_signed_up`, `student_signed_up` e `signed_in`; **quem de fato conectou** em
`classroom_connected` (auxiliar ou staff agindo pelo professor conta para si, com `onBehalfOf`).

**`groups: { organization: orgId }` só sai em cinco eventos**: os quatro `library_*` e
`classroom_connected` (quando o state do OAuth carrega a org). Os demais **não** passam `groups`, porque
`Submission` e `Exam` não carregam `organizationId` — funil por instituição ainda não é possível.

---

## Eventos da API (server-side) — 14

| Evento | Dispara quando | Propriedades |
|---|---|---|
| `user_signed_up` | Novo usuário **professor** criado (hook `onUserCreated` da auth, `iam/application/handle-user-created.ts`). | — (só `distinctId`) |
| `student_signed_up` | Novo usuário com `role: "student"` (mesmo hook). Separado para não inflar o funil do professor; aluno também não recebe créditos de boas-vindas. | — |
| `signed_in` | Toda criação de sessão (hook `onSessionCreated` do BetterAuth em `main.ts`) — senha, Google e magic link convergem ali. Dispara também no cadastro, junto com `user_signed_up`. | — |
| `user_activated` | **Marco de ativação:** primeira submissão finalizada de aluno numa prova do dono. Uma vez por dono. | `examId`, `source` (`"online"` \| `"scanner"`) |
| `classroom_connected` | Callback do OAuth do Google Classroom concluído (`classroom/application/complete-oauth.ts`). | `reconnected`, `onBehalfOf` (só quando quem conectou não é o professor) |
| `subscription_started` | Webhook Stripe confirma assinatura ativa. | `planId`, `status` |
| `subscription_canceled` | Webhook Stripe de assinatura deletada. | `planId` |
| `topup_purchased` | Compra de créditos avulsos liquidada (webhook Stripe **ou** AbacatePay). | `topupId`, `credits`, `amountCents`, `provider` (`"stripe"` \| `"abacatepay"`) |
| `ai_generation_completed` | Geração de IA conclui — **prova ou plano de aula**. | `kind` (`"exam"` \| `"lesson_plan"`), `inputTokens`, `outputTokens`, `creditsCharged`, `durationMs`. **Exam** ainda: `language`, `style`, `questionCount`. **Lesson plan** ainda: `segment`. |
| `submission_completed` | Submissão online de prova finalizada (`submit-exam`). | `examId`, `gradingStatus`, `score`, `source` |
| `library_file_uploaded` | Upload na Biblioteca confirmado (presigned S3). | `fileType`, `sizeBytes`, `mimeType` |
| `library_file_extraction_succeeded` | Extração de texto do arquivo concluída. | `fileType`, `sizeBytes`, `pageCount`, `wordCount`, `durationMs` |
| `library_file_extraction_failed` | Extração de texto falhou. | `fileType`, `reason` |
| `library_file_used_in_generation` | Arquivo da Biblioteca usado como fonte de uma geração. | `generationKind`, `fileType`, `sizeBytes`, `pageCount`, `subject` |

Valores possíveis de `library_file_extraction_failed.reason`: `unsupported_type`, `empty_text`,
`extraction_error`.

### `user_activated` — a régua de ativação

**Usuário ativado = a primeira prova dele respondida por um aluno** (ADR-0017). Concluir o tour de
onboarding **não** é ativação. A guarda vive em `submission/application/capture-activation.ts` e é
chamada pelos dois caminhos que gravam submissão — prova online (`submit-exam`) e folha de papel aprovada
no scanner (`scan/application/approve-scan.ts`). O canal vira propriedade, não filtro.

A idempotência vem da **contagem de submissões finalizadas do dono** (capada em 2), não de flag: se a
contagem é 1, esta é a primeira. Consequência aceita: duas primeiras submissões quase simultâneas podem
ambas ver 2 e **nenhuma** emitir — a falha é de ausência, nunca de duplicidade. Para auditar, procure
donos com `submission_completed` e sem `user_activated`.

**Gotcha:** a submissão vinda do scanner emite `user_activated` mas **não** emite
`submission_completed`.

**Buraco conhecido:** `ai_generation_completed` **não** distingue objetivas de discursivas, porque a
geração de prova aberta (`generate-open-questions.ts`) não emite evento nenhum. Prova discursiva é
invisível no PostHog hoje.

---

## Eventos do Web (client-side) — 15

| Evento | Dispara quando | Propriedades |
|---|---|---|
| `class_created` | Professor cria uma turma dentro de um curso. | — |
| `student_added` | Aluno novo cadastrado na turma (drawer de aluno; edição não conta). | `classId` |
| `exam_created` | Prova criada no fim do wizard (step review). | `examId`, `questionCount`, `style`, `source` (`"ai"` \| `"manual"`) |
| `exam_generation_started` | Início da geração de prova (`doGenerate` do wizard), **antes** do resultado. | `usedPageRange` |
| `exam_link_shared` | Professor copia o link da prova. O `shareId` fica fora do payload — é credencial. | `examId` |
| `grading_started` | Professor dispara a correção por IA das abertas. | `examId`, `mode: "ai"` |
| `grading_approved` | Correção aprovada — manual (uma submissão) ou sugestões da IA em lote. | `examId`, `mode` (`"manual"` \| `"ai"`), `submissionCount` |
| `scanner_used` | Folha de resposta processada pelo scanner com sucesso. | `examId` |
| `lesson_plan_created` | Início da geração de plano de aula — apesar do nome, é evento de **início**, simétrico ao `exam_generation_started`. | `usedPageRange` |
| `lesson_plan_exported` | Clique no export DOCX do plano de aula. | `lessonPlanId`, `format: "docx"` |
| `support_request_sent` | Form de contato de `/app/ajuda` enviado. | `category` |
| `onboarding_tour_started` | Tour de onboarding inicia. | `source` |
| `onboarding_tour_step_viewed` | Passo do tour visto (coachmark desktop). | `step_id`, `step_index` |
| `onboarding_tour_completed` | Tour concluído até o fim. | `source` |
| `onboarding_tour_skipped` | Tour pulado. | `step_id`, `step_index`, `source` |

**Removidos da taxonomia:** `exam_published` (prova não tem ação de publicar — a disponibilidade vem do
agendamento) e `public_exam_started` (o SDK não roda na prova pública). `signed_in` e
`classroom_connected` saíram do web e foram para o servidor.

O `capture()` do web é no-op silencioso quando `posthog.__loaded` é falso — não só quando falta a key,
também nas rotas onde o SDK não inicializa.

### Demo institucional (`apps/demo`) — taxonomia própria

A demo tem SDK e taxonomia próprios, em `apps/demo/src/features/demo/analytics/events.ts`, todos com
prefixo `demo_`: `demo_opened`, `demo_persona_selected`, `demo_chapter_viewed`,
`demo_chapter_completed`, `demo_interaction`, `demo_deck_opened`, `demo_lead_form_opened`,
`demo_lead_submitted`, `demo_lead_failed`. Medem o funil de venda: quem chegou, que persona escolheu,
até onde foi e se pediu contato. A demo não tem login, então não faz `identify`. Setup em
[tecnico/integracoes.md](integracoes.md).

---

## Identidade, grupos e eventos automáticos

- **Identify (web).** `usePosthogIdentity` sincroniza pessoa/grupo com a sessão BetterAuth:
  `identify(user.id, { email, role })` no login, `group("organization", orgId, { name })` na org
  ativa, `reset()` no logout.
- **`person_profiles` depende de `NEXT_PUBLIC_POSTHOG_ANON_PROFILES`.** Default (`identified_only`):
  tráfego anônimo não gera perfil de pessoa. Com `"true"` vira `always`, e o `identify` do cadastro
  costura visitante e conta na mesma pessoa — é o que permite o funil começar antes do cadastro. Ligar
  está bloqueado pela política de privacidade (issue #118), por isso é env e não literal.
- **O SDK não inicializa em `/exam/**` nem em `/aluno`.** A URL da prova é credencial (o
  `/exam/<shareId>/start/<token>` não expira), o autocapture leria a alternativa marcada pelo aluno, e
  em máquina compartilhada o perfil do aluno seria fundido no do próximo professor que fizesse login. Um
  `before_send` ainda redige URL de prova que sobre em `$current_url`/`$referrer` no resto do app.
  Feature flags estão desligadas (`advanced_disable_feature_flags`).
- **Pageviews/pageleave + autocapture** ligados via `defaults: "2025-05-24"` (App Router-aware).
- **Error tracking.** Web envia exceções JS não tratadas (`capture_exceptions: true`). API captura
  `captureException` nos handlers de processo (`uncaughtException`, `unhandledRejection`).
- **Session replay: desligado** (`disable_session_recording: true`).

## Onde os eventos são lidos

A aba **"Produto"** de `/kintal/metricas` (rota `GET /api/kintal/metrics/behavior`) consome via
HogQL/Query API (`POSTHOG_PERSONAL_API_KEY` + `POSTHOG_PROJECT_ID`; sem elas → 503).

Ela lê **três** eventos, com `count(DISTINCT person_id)`: `user_signed_up`, `exam_created` e
`submission_completed`. São três contagens independentes na mesma janela, **não um funil** — sem coorte
nem ordem. `user_activated` ainda não tem leitor no produto, nem o resto da taxonomia.
