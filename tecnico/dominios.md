---
quando_usar: mapear os domínios da api e suas entidades centrais, achar onde fica uma feature
última_revisão: 2026-08-25
status: canônico
---

# Mapa de domínios (`apps/api/src/domains/`)

27 bounded contexts implementados, cada um com as camadas de que precisa (ver
[tecnico/arquitetura.md](../tecnico/arquitetura.md)). **Nem todo domínio tem as 4** — `calendar` não tem `infrastructure/`
(lê pelo repositório de `exam`), `support` só tem `presentation/`, `webhook-dispatch` só tem
`application/` + `infrastructure/`.

| Domínio | Função |
|---|---|
| `iam` | Auth via BetterAuth (Google OAuth + e-mail/senha + plugin de organização); **delegação a auxiliares** (`TeacherAssistant`); impersonação staff; preferências do usuário — **`passingGrade`** (média de aprovação, default 6) e `onboardingTourCompletedAt`. |
| `class` | Turmas. |
| `student` | Alunos. |
| `exam` | Provas (questões objetivas + abertas, shareId, estilo, segurança, **janela de resposta `ExamSchedule`**). |
| `submission` | Respostas de aluno + correção de abertas (fila, rubricas, notas por critério, aprovação). |
| `calendar` | Visão de leitura das provas com janela agendada (`/app/calendario`); gate de assinante. Ver [tecnico/calendario.md](../tecnico/calendario.md). |
| `exam-notification` | Outbox Mongo (sem Redis) dos e-mails de "atividade disponível" quando a janela abre; cron + reenvio manual. Ver [tecnico/calendario.md](../tecnico/calendario.md). |
| `course` | Cursos do professor — agrupam turmas/provas. |
| `lesson-plan` | Planos de aula (snapshots de turma/curso/disciplina, BNCC, export DOCX, duplicação). |
| `ai-ops` | Geração/correção via OpenAI; extractors PDF/DOCX/text/YouTube; recorte por faixa de páginas; pt-BR/inglês/espanhol. |
| `library` | **Biblioteca** — upload de arquivos (presigned S3/Railway Buckets), extração de texto, acesso por dono/org/assinante, taxonomia por disciplina+segmento; fonte de conteúdo do `ai-ops`. Ver [tecnico/biblioteca.md](../tecnico/biblioteca.md). |
| `scan` | **OMR** — agregado próprio (`ScanResult`), **geração das folhas de resposta em PDF** (QR + marcadores ArUco), aprovação e listagem por prova. A leitura em si é proxy para o serviço Python `services/omr`. |
| `classroom` | Integração Google Classroom (Fase 1: importar turmas/alunos). Ver [produto/decisoes-de-produto.md](../produto/decisoes-de-produto.md) para o estado das Fases 2/3. |
| `billing` | Créditos, ledger, débito atômico, assinaturas Stripe, top-ups por cartão, webhook, modos de billing de organização. PIX (AbacatePay) **desativado** por kill-switch — ver [tecnico/billing-ledger.md](../tecnico/billing-ledger.md) e [tecnico/integracoes.md](../tecnico/integracoes.md). |
| `invoicing` | NFS-e via NFE.io, disparada por transações de billing. |
| `finance` | Dashboard financeiro staff-only (receita, despesas, categorização). |
| `analytics` | Visões de organização — "cubo" parametrizável. Escopos: `instituicao \| professor \| turma \| aluno \| prova`. |
| `api-access` | API keys HMAC (escopos `classes`/`students`/`exams` × read/write/share) + endpoints de webhook configuráveis. |
| `public-api` | REST externo (parceiros) — turmas, alunos, exam links, results **e geração assíncrona de prova por IA** (202 + `jobId`, com cron de resgate). |
| `webhook-dispatch` | Envia `submission.completed` para endpoints registrados. É o único evento da lista. |
| `kintal` | Backoffice interno staff-only: dashboard, staff, usuários, **instituições**, **impersonação** (com audit log), auxiliares. |
| `kanban` | Board interno usado pelo Kintal. |
| `notifications` | Inbox in-app + campanhas (sender split staff/org-admin), severidades `info\|success\|warning\|alert`. |
| `organization-preferences` | Preferências por organização — hoje, o **escopo de unicidade da matrícula** (`teacher` default vs `organization`). |
| `roadmap` | Roadmap **público** com sugestão e voto da comunidade (`/roadmap`); CRUD staff. Não é tela do Kintal. |
| `support` | Form de contato (`/app/ajuda`) → e-mail via Resend. |
| `tickets` | Suporte por e-mail — inbound via Resend Inbound, threading, fila staff no Kintal. |

Existe também a pasta `student-portal/`, com as 4 pastas de camada **vazias** — zero arquivos, sem
wiring em `main.ts`. É **esqueleto**, não domínio: scaffolding para a área do aluno (issue #4), que
depende do ADR-0013. A contraparte no front (`apps/web/src/app/aluno/`,
`apps/web/src/features/student/`) também está vazia. Nada disso está versionado.

**Proposto, não implementado:** `learning-object` — a coleção-registro da Q-matrix (um doc por
`questionId`, com `kc[]`, `family_id`, `nivel_cognitivo`). Decidido no ADR-0012, ainda em branch.
Ver [produto/motor-assertividade.md](../produto/motor-assertividade.md).

## Entidades centrais (domínios core)
- **Exam** — id, classId, courseId (snapshot), ownerId, title, description (≤ **10.000** chars),
  **activityType** (`exam|mockExam|quiz|exerciseList`, default `exam`, puramente classificatório —
  nunca afeta geração, preço ou correção), **style** (`simple|contextual|analytical|reflective`),
  duration (0–600 min, **0 = sem limite**), **securityLevel** (`off|strict`; `strict` auto-finaliza
  no **3º strike** de troca de aba/blur e flagra a submission), questions[], shareId, courseWorkId,
  usage (telemetria de tokens), **`schedule`** (VO `ExamSchedule`: availableFrom/availableUntil/
  notifyOnOpen) + `notificationsMaterializedAt`. LaTeX em questões é texto inline (sem campo
  dedicado) — ver [tecnico/ai-ops.md](../tecnico/ai-ops.md) e [tecnico/calendario.md](../tecnico/calendario.md).
- **Question** (VO) — tipo `multipleChoice|trueFalse|open`; objetiva tem opções/gabarito; aberta tem
  **Rubric** + referenceAnswer. Dificuldade em pt-BR (`fácil|médio|difícil`).
- **Rubric** — criteria[] → cada critério tem levels[] (com points). Max = maior nível por critério.
- **Submission** — 21 campos. Além de examId/studentId/source/status/answers/textAnswers/score/
  openGrades/gradingStatus, carrega: `classId`, `courseId`, `ownerId`, `studentCode`, `studentName`,
  `correctCount`, `questionCount`, `startedAt`, `submittedAt`, **`endReason`**
  (`submitted|time_expired|violation|abandoned` — `abandoned` é placeholder, não emitido),
  **`integrityFlags`** (tabSwitches, focusLosses, copyAttempts, rightClickAttempts, violationCount)
  e `openQuestionIndices`. `gradingStatus` ∈ `not_required|pending|partially_graded|graded`.
  Score 0–10, 1 decimal, parcial até as abertas serem corrigidas.
- **OpenGrade** — correção de 1 questão aberta: `criteria[]` (cada um com levelId, points,
  **justification** e **feedback**), earned/max, **`overriddenFraction`** (override do professor em
  [0,1]; `null` = usa earned/max), source (`ai|manual`), status (`ai_suggested|approved`),
  `gradedByUserId`, `aiModel`, `gradedAt`. Só nota **aprovada** conta para o score.
- **Class / Student / Course** — turma / aluno / curso. O **Student** tem `code`, `matricula`,
  `email`, `organizationId` (que dirige a unicidade org-wide da matrícula) e campos Classroom.
  A **Class** guarda `stage` e `grade` como **props planas**; `EducationLevel`
  (`stage` ∈ `FUNDAMENTAL|MEDIO|SUPERIOR|CUSTOM` ou `null`, `grade` texto livre ≤30) é um VO de
  composição usado no payload aninhado da API, não um campo da entidade. Tem também
  **`objectives[]`** (`LearningObjective`: `source` `bncc|custom`, `code` nullable ≤40,
  `label` ≤280), no máximo **30** por turma.
  **Gotcha**: `levelPayload()` no front sempre envia `educationLevel` + `objectives` no save
  ("*Always returns level + objectives so a save can also clear them*") — um form de edição que não
  popular ambos **apaga** os dois. O use case do servidor respeita `!== undefined`; quem força é o web.
- **TeacherAssistant** — vínculo N:N professor↔auxiliar dentro de uma organização, revogação por
  soft-delete (`revokedAt`). Ver [regras/produto.md](../regras/produto.md).
- **CreditWallet** — scope (`user|org`), source (`subscription|topup|welcome|promo|admin_grant`),
  balance, expiresAt, externalRef. A ordem de consumo é por **prioridade da fonte**:
  subscription (0) → topup/admin_grant (1) → promo (2) → welcome (3).

Detalhe de créditos em [tecnico/billing-ledger.md](../tecnico/billing-ledger.md); de geração/correção em [tecnico/ai-ops.md](../tecnico/ai-ops.md).
