---
quando_usar: mapear os domínios da api e suas entidades centrais, achar onde fica uma feature
última_revisão: 2026-06
status: canônico
---

# Mapa de domínios (`apps/api/src/domains/`)

~25 bounded contexts, cada um com as 4 camadas (ver tecnico/arquitetura.md).

| Domínio | Função |
|---|---|
| `iam` | Auth via BetterAuth (Google OAuth + e-mail/senha + plugin de organização); delegação a assistentes de professor. |
| `class` | Turmas. |
| `student` | Alunos. |
| `exam` | Provas (questões objetivas + abertas, shareId, estilo, segurança). |
| `submission` | Respostas de aluno + correção de abertas (fila, rubricas, notas por critério, aprovação). |
| `course` | Cursos do professor — agrupam turmas/provas. |
| `lesson-plan` | Planos de aula (snapshots de turma/curso/disciplina, BNCC, export DOCX, duplicação). |
| `ai-ops` | Geração/correção via OpenAI; extractors PDF/DOCX/text/YouTube; pt-BR/inglês/espanhol. |
| `scan` | OMR — proxy para o serviço Python `services/omr`. |
| `classroom` | Integração Google Classroom (Fase 1: importar turmas/alunos). |
| `billing` | Créditos, ledger, débito atômico, assinaturas Stripe, top-ups, PIX, webhook. |
| `invoicing` | NFS-e via NFE.io, disparada por transações de billing. |
| `finance` | Dashboard financeiro staff-only (receita, despesas, categorização). |
| `analytics` | Visões de organização — "cubo" parametrizável (overview/professor/turma/aluno/prova/membros). |
| `api-access` | API keys HMAC + endpoints de webhook configuráveis. |
| `public-api` | REST externo (parceiros) — turmas, alunos, exam links, results. |
| `webhook-dispatch` | Envia `submission.completed` para endpoints registrados. |
| `kintal` | Backoffice interno staff-only. |
| `kanban` | Board interno usado pelo Kintal. |
| `notifications` | Inbox + campanhas (sender split staff/org-admin). |
| `organization-preferences` | Preferências por organização. |
| `roadmap` | Suggest + voting público; CRUD staff. |
| `support` | Form de contato (`/app/ajuda`) → e-mail via Resend. |
| `tickets` | Suporte por e-mail — inbound via Resend Inbound, threading, fila staff no Kintal. |

## Entidades centrais (domínios core)
- **Exam** — id, classId, courseId (snapshot), ownerId, title, style, duration, securityLevel,
  questions[], shareId, courseWorkId.
- **Question** (VO) — tipo `multipleChoice|trueFalse|open`; objetiva tem opções/gabarito; aberta tem
  **Rubric** + referenceAnswer.
- **Rubric** — criteria[] → cada critério tem levels[] (com points). Max = maior nível por critério.
- **Submission** — examId, studentId, source (`online|scanner`), status (`in_progress|submitted`),
  answers[], textAnswers[], score (0–10), openGrades[], gradingStatus.
- **OpenGrade** — correção de 1 questão aberta: nível por critério, earned/max, source (`ai|manual`),
  status (`ai_suggested|approved`).
- **Class / Student / Course** — turma / aluno (com `code`, `matricula`, campos Classroom) / curso.
- **LessonPlan** — segment, status (`DRAFT|READY|ARCHIVED`), identification + content (BNCC, seções).
- **CreditWallet** — scope (`user|organization`), source (`welcome|subscription|topup|pix`), balance, expiresAt.

Detalhe de créditos em tecnico/billing-ledger.md; de geração/correção em tecnico/ai-ops.md.
