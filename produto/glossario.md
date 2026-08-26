---
quando_usar: precisar do significado preciso de um termo de domínio da Lucida
última_revisão: 2026-08-25
status: canônico
---

# Glossário de produto

Termos definidos a partir do domínio (`apps/api/src/domains/*`). Nomes técnicos em inglês; a coluna
explica em pt-BR.

| Termo | O que é |
|---|---|
| **Exam** (prova) | Agregado raiz. Tem `questions[]`, `style`, `activityType`, duração, `securityLevel`, `shareId` e dono (`ownerId`). Pode ter `courseWorkId` (Classroom) e `schedule` (**ExamSchedule**). |
| **ExamSchedule** | Janela de resposta da prova: `availableFrom`, `availableUntil`, `notifyOnOpen`. Sem schedule → prova sempre respondível. `notifyOnOpen` liga o e-mail "atividade disponível". |
| **ActivityType** | Classificação da prova: `exam` (prova), `mockExam` (simulado), `quiz`, `exerciseList` (lista de exercícios). Padrão `exam`. Só organiza/filtra — não afeta geração, preço ou correção. |
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
| **Class** (turma) | Agregado com nome, disciplina, **nível** (EducationLevel) e **objetivos** (LearningObjective[]); pode pertencer a um `course`, a uma `organization` e a um curso do Classroom (`classroomCourseId`). |
| **EducationLevel** | Nível de ensino da turma: `stage` (`FUNDAMENTAL`/`MEDIO`/`SUPERIOR`/`CUSTOM` ou nulo) + `grade` (série, texto livre). **Não confundir** com **Segment** do plano de aula/Biblioteca (enum diferente: `FACULDADE`/`INFOPRODUTOR` no lugar de `SUPERIOR`/`CUSTOM`). |
| **LearningObjective** | Objetivo de aprendizagem da turma: `source` (`bncc`/`custom`), `code` (ref. da taxonomia, opcional), `label`. |
| **Course** (curso) | Agrupa turmas/provas sob um tema/disciplina do professor. |
| **Student** (aluno) | Aluno de uma turma. Identificado por `code` (gerado), `matricula`, `email`. `classroomRemovedAt` marca remoção suave. |
| **Organization** (organização/instituição) | Instituição que agrupa professores e dados. `organizationId = null` significa professor individual. |
| **passingGrade** (média de aprovação) | Nota de corte do professor (0–10, default **6**), campo do usuário no BetterAuth. Resolve `org → professor → 6` (org adiado). Classifica aprovado/reprovado nas análises (sai como `meta.passingGrade` no cubo). **Não** é a aprovação da correção. |
| **ExamStyle** | Estilo de geração: `simple`, `contextual`, `analytical`, `reflective`. Afeta texto e preço. |
| **CreditWallet** (carteira) | Saldo de créditos com escopo (`user`/`org`), origem (`subscription`/`topup`/`welcome`/`promo`/`admin_grant`) e validade (`expiresAt`). Não há mais origem `pix` (top-up PIX desativado). Consumo por prioridade da origem. |
| **LibraryFile** | Arquivo da Biblioteca (`pdf`/`docx`/`txt`) com status (`UPLOADING`/`PROCESSING`/`READY`/`ERROR`), texto extraído, disciplina/segmento e métricas de uso. Fonte de conteúdo para geração. |
| **LibrarySubject** | Disciplina nomeada da Biblioteca, dentro de um segmento (`FUNDAMENTAL`/`MEDIO`/`FACULDADE`/`INFOPRODUTOR`). |
| **Ledger** | Registro de movimentos de crédito (créditos/débitos) com rastreio de tokens usados, `relatedAction` e um `reason` de conjunto fechado. Coleções `credit_wallets` e `credit_ledger`. |
| **BetterAuth** | Framework de autenticação (Google OAuth + e-mail/senha + plugin de organização). Sessão no cookie `lucida.session_token`. |
| **Kintal** | Backoffice interno staff-only (não exposto ao cliente). |
| **TeacherAssistant** (auxiliar) | Vínculo N:N entre um professor e um auxiliar, dentro de uma organização. Revogação por soft-delete (`revokedAt`). O auxiliar opera **em nome** do professor, com os dados dele — nunca com a autoridade administrativa dele. |
| **SubscriberAccessPolicy** | A política única que decide "é assinante?": staff **ou** membro de organização **ou** assinatura ativa. Governa Biblioteca e Calendário; sem direito → 402 + upsell. |
| **SecurityLevel** (modo de aplicação) | `off` (livre) ou `strict` (estrito). No estrito, a submissão auto-finaliza no **3º strike** de troca de aba/blur e fica flagrada. Editável depois da criação; prova copiada herda o modo. |
| **IntegrityFlags** | Contadores de comportamento durante a prova online: `tabSwitches`, `focusLosses`, `copyAttempts`, `rightClickAttempts`, `violationCount`. |
| **SubmissionEndReason** | Como a submissão terminou: `submitted`, `time_expired`, `violation` (3º strike no modo estrito) ou `abandoned` (placeholder, não emitido hoje). |
| **ExamLinkToken** | Token que identifica um aluno específico num link de prova (`/exam/[shareId]/start/[token]`), pré-preenchendo a identidade. Emitido pelo escopo `exams:share` da API pública. |
| **ApiKeyScope** | Permissão de uma chave da API pública: `classes:read/write`, `students:read/write`, `exams:read/write/share`. |
| **MatriculaScope** | Escopo de unicidade da matrícula numa organização: `teacher` (default) ou `organization`. Configurável em `organization-preferences`. |
| **CubeScope / CubeBreakdown** | Parâmetros do "cubo" de analytics. Escopo: `instituicao\|professor\|turma\|aluno\|prova`. Corte: `none\|questao\|dificuldade\|habilidade\|criterio_rubrica\|estilo\|tempo\|peer\|turmas\|alunos\|provas`. |
| **Notification / Severity** | Mensagem in-app na inbox do usuário, com severidade `info\|success\|warning\|alert`. Enviada individualmente ou por campanha (staff ou admin de org). |
| **RoadmapItem** | Item do roadmap público, com estágio (`suggested\|under_review\|planned\|in_progress\|shipped\|declined`), produto (`exam\|analytics`) e votos da comunidade. |
| **KC (Knowledge Component)** | Unidade de habilidade que uma questão exercita — código BNCC quando aplicável, slug provisório quando não. Base do motor de assertividade; **ainda não existe no código**. Ver [produto/motor-assertividade.md](../produto/motor-assertividade.md). |
| **Q-matrix** | O mapa questão → KC(s). No ADR-0012, vira a coleção `learning_objects`, um documento por `questionId`. **Proposto, não implementado**. |
