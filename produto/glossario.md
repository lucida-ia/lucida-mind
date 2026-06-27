---
quando_usar: precisar do significado preciso de um termo de domínio da Lucida
última_revisão: 2026-06
status: canônico
---

# Glossário de produto

Termos definidos a partir do domínio (`apps/api/src/domains/*`). Nomes técnicos em inglês; a coluna
explica em pt-BR.

| Termo | O que é |
|---|---|
| **Exam** (prova) | Agregado raiz. Tem `questions[]`, `style`, duração, `securityLevel`, `shareId` e dono (`ownerId`). Pode ter `courseWorkId` (Classroom). |
| **Question** | Value object da questão. Tipo `multipleChoice`, `trueFalse` ou `open`. Objetiva tem opções/gabarito; aberta tem **rubric** + resposta de referência. |
| **shareId** | Identificador público da prova. Vira o link `/exam/[shareId]` pelo qual o aluno responde sem login. |
| **Submission** (resposta) | Tentativa de um aluno numa prova. Ciclo: `in_progress` → `submitted`. `source` = `online` ou `scanner`. Guarda respostas objetivas e abertas, score (0–10), flags de integridade. |
| **Rubric** (rubrica) | Instrumento de avaliação de questão aberta: lista de **critérios**, cada um com **níveis**. Obrigatória em questão aberta. |
| **Criterion** (critério) | Dimensão avaliada dentro da rubrica (ex.: "clareza"). Tem vários **levels** com pontuação. |
| **Level** (nível) | Faixa de um critério (ex.: insuficiente/satisfatório/proficiente), com `points` e descritor. |
| **OpenGrade** | Correção de **uma** questão aberta numa submission: nível escolhido por critério, `earned/max`, `source` (`ai`/`manual`), `status` (`ai_suggested`/`approved`). Só aprovada conta no score. |
| **gradingStatus** | Progresso da correção de abertas numa submission: `not_required`, `pending`, `partially_graded`, `graded`. |
| **OMR** | *Optical Mark Recognition* — leitura de folha de resposta em papel por foto (serviço Python). Gera submission com `source = scanner`. |
| **Lesson plan** (plano de aula) | Agregado com identificação (título/disciplina/nível/duração) + conteúdo (objetivos, BNCC, seções) + `status` (`DRAFT`/`READY`/`ARCHIVED`). |
| **Segment** (segmento) | Nível do plano de aula: `FUNDAMENTAL`, `MEDIO`, `FACULDADE`, `INFOPRODUTOR`. Define o preço da geração. |
| **Class** (turma) | Agregado com nome, disciplina, série; pode pertencer a um `course`, a uma `organization` e a um curso do Classroom (`classroomCourseId`). |
| **Course** (curso) | Agrupa turmas/provas sob um tema/disciplina do professor. |
| **Student** (aluno) | Aluno de uma turma. Identificado por `code` (gerado), `matricula`, `email`. `classroomRemovedAt` marca remoção suave. |
| **Organization** (organização/instituição) | Instituição que agrupa professores e dados. `organizationId = null` significa professor individual. |
| **ExamStyle** | Estilo de geração: `simple`, `contextual`, `analytical`, `reflective`. Afeta texto e preço. |
| **CreditWallet** (carteira) | Saldo de créditos com escopo (`user`/`organization`), origem (`welcome`/`subscription`/`topup`/`pix`) e validade (`expiresAt`). |
| **Ledger** | Registro de movimentos de crédito (créditos/débitos) com rastreio de tokens usados. |
| **BetterAuth** | Framework de autenticação (Google OAuth + e-mail/senha + plugin de organização). Sessão no cookie `lucida.session_token`. |
| **Kintal** | Backoffice interno staff-only (não exposto ao cliente). |
