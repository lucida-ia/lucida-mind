---
quando_usar: listar os módulos do produto e o que cada um faz, entender o escopo funcional
última_revisão: 2026-08-25
status: canônico
---

# Suíte de produto

Os módulos que o usuário toca. Mapeamento técnico (domínios da api) em [tecnico/dominios.md](../tecnico/dominios.md).

## Provas (exam + ai-ops)
- **Geração por IA**: a partir de um tema/material, gera questões **objetivas** (múltipla escolha / V-F)
  e **abertas** (com rubrica). Parâmetros: estilo, dificuldade, idioma (pt-BR/inglês/espanhol),
  quantidade. Detalhe em [produto/estilos-de-questao.md](estilos-de-questao.md).
- **Montagem manual** e edição questão a questão; **regeneração** de uma questão específica.
- **Tipo de atividade**: cada prova tem um tipo (`activityType`) — **Prova**, **Simulado**, **Quiz** ou
  **Lista de Exercícios** — usado para classificar/filtrar; não muda geração, preço nem correção.
- **Fontes de conteúdo**: PDF, DOCX, texto colado, **transcrição de vídeo do YouTube** e arquivos da
  **Biblioteca** (ver abaixo).
- **Matemática**: enunciados, alternativas e explicações suportam **fórmulas (LaTeX)**, renderizadas com
  KaTeX na prova online e na versão imprimível.
- **Aplicação**: cada prova tem um **link público** (`/exam/[shareId]`) — o aluno responde online,
  sem login; se não estiver na turma, entra por **auto-cadastro** (a Lucida gera `code`/`matricula`).
  Há também um **link por aluno** (`/exam/[shareId]/start/[token]`), com a identidade pré-preenchida,
  emitido pelo escopo `exams:share` da API pública. Versão **imprimível** e **modo de aplicação**
  (livre / estrito) configurável — no estrito, a prova auto-finaliza no 3º strike de troca de aba.
  O modo é editável **depois** da criação, e uma prova copiada **herda** o modo da origem.
- **Faixa de páginas**: ao usar um PDF (anexo ou da Biblioteca), o professor escolhe de qual página
  a qual página gerar, em vez de mandar o arquivo inteiro.
- **Agendamento**: a prova pode ter uma **janela de resposta** (abre/fecha em data-hora) e, opcionalmente,
  **avisar os alunos por e-mail quando abrir**. Sem janela, fica sempre respondível. Ver Calendário abaixo.

## Correção (submission + ai-ops)
- **Objetiva**: corrigida automaticamente (gabarito).
- **Aberta**: corrigida com **rubrica** — a IA sugere o nível por critério e justifica; o **professor
  revisa e aprova**. Só nota aprovada conta para o score. Existe fila de correção (`/app/corrigir-provas`).
- **Nota final**: 0–10, uma casa decimal.

## Planos de aula (lesson-plan + ai-ops)
> **Em beta.** A própria UI avisa que "o módulo de Aulas ainda está em testes", e o botão
> "Gerar material" está desabilitado com selo "Em breve".

Geração estruturada: objetivos, **habilidades BNCC**, introdução, desenvolvimento, conclusão, avaliação.
Quatro segmentos: Fundamental, Médio, Faculdade, Infoprodutor. Exporta **DOCX**, duplica, arquiva e
pode **gerar prova** a partir do plano.

## Biblioteca (library)
Acervo de materiais do professor (`/app/biblioteca`): sobe **PDF/DOCX/TXT** uma vez (upload direto ao
storage, presigned), a Lucida **extrai o texto** e organiza por **disciplina e segmento**
(Fundamental/Médio/Faculdade/Infoprodutor). Esses arquivos viram **fonte reutilizável** na geração de
provas e planos de aula — sem re-upload nem custo extra de crédito na reutilização. Acesso liberado para
staff, membros de organização ou assinantes ativos (senão, tela de upsell). Detalhe em [tecnico/biblioteca.md](../tecnico/biblioteca.md).

## Calendário (calendar + exam-notification)
Visão de **agenda das provas com janela** (`/app/calendario`): mostra num grid de mês quando cada
atividade abre/fecha. Quando uma prova marcada com "avisar ao abrir" entra na janela, a Lucida **dispara
e-mail aos alunos** com o link, automaticamente (ou por reenvio manual do professor). Feature **de
assinante** (staff, instituição ou assinatura ativa; senão, upsell). Detalhe em [tecnico/calendario.md](../tecnico/calendario.md).

## Organização do dia a dia
- **Turmas** (class), **alunos** (student) e **cursos** (course) que agrupam turmas/provas. A turma guarda
  **nível de ensino** (Fundamental/Médio/Superior/Personalizado + série livre) e **objetivos de
  aprendizagem** (BNCC ou personalizados).
- **Google Classroom**: importa turmas e alunos com reconciliação por e-mail (Fase 1).
- **Média de aprovação**: o professor configura sua **nota de corte** (default 6) — usada para classificar
  aprovado/reprovado nas análises e nos indicadores. Ver [produto/decisoes-de-produto.md](decisoes-de-produto.md).
- **Onboarding**: tour guiado (mascote Lulu) na primeira vez no `/app`, refazível pelo menu de perfil.
- **"Lulu sugere"**: card no dashboard que aponta o que fazer agora — correções pendentes, alunos em
  risco. A Lulu não é só mascote do tour; é a superfície de sugestão do dashboard.
- **Matrícula**: a unicidade pode ser por professor (default) ou **por organização**, configurável nas
  preferências da instituição.

## Scanner OMR (scan)
Folha de resposta **em papel**: o servidor gera um PDF (1 página por aluno, com QR), o professor imprime,
aplica, fotografa e a Lucida lê as marcações via serviço Python (OpenCV). Vira `submission` com
`source = scanner`.

## Instituições e analytics (analytics)
Dashboard de **organização** (frente roxa, `/analytics`). Motor de analytics parametrizável ("cubo"),
com **escopo** ∈ `instituicao | professor | turma | aluno | prova` e **corte** (breakdown) ∈ `none |
questao | dificuldade | habilidade | criterio_rubrica | estilo | tempo | peer | turmas | alunos |
provas`. Gestão de membros é tela própria, não escopo do cubo. Detalhe em
[produto/decisoes-de-produto.md](decisoes-de-produto.md).

## Plataforma para parceiros (public-api + api-access + webhook-dispatch)
REST externo com API keys HMAC: turmas, alunos, links de prova, resultados — e **geração de prova por
IA de forma assíncrona** (`POST` devolve 202 + `jobId`, o parceiro faz polling; aceita até 10 arquivos
de 25 MB). Escopos de chave: `classes:read/write`, `students:read/write`, `exams:read/write/share`.
Webhooks de `submission.completed` — o único evento — para endpoints cadastrados. Documentação em
`/docs`.

## Backoffice (kintal)
Área interna staff-only (`/kintal`): dashboard, acessos, usuários, **instituições**, financeiro,
métricas (Mongo + PostHog), board (kanban), notificações e a fila de tickets de suporte. Inclui
**"atuar como"** (impersonação de usuário ou de instituição, com audit log). Não é exposto ao cliente.

O **roadmap não vive aqui** — é rota pública (ver abaixo).

## Auxiliares (assistente de professor)
Um professor pode delegar o dia a dia a um **auxiliar**: o vínculo é N:N dentro de uma organização, e
o auxiliar passa a operar **em nome** do professor supervisionado, com um seletor de professor-alvo
(`/auxiliar/escolher`) e um banner "atuando como" enquanto o modo está ativo. A revogação é soft-delete
(`revokedAt`), e a gestão dos vínculos existe tanto no painel da instituição quanto no Kintal.

Delegação concede os **dados** do professor, nunca a **autoridade administrativa** dele — ver
[regras/produto.md](../regras/produto.md).

## Notificações in-app
Inbox do usuário (`/app/notificacoes` e `/analytics/notificacoes`) com sino e contador, além de
**campanhas** disparadas por staff ou por admin de organização. Severidades: `info`, `success`,
`warning`, `alert`. Convive com o e-mail; não o substitui.

## Roadmap público
`/roadmap` — kanban aberto onde o usuário **sugere** feature e **vota**. Estágios: `suggested`,
`under_review`, `planned`, `in_progress`, `shipped`, `declined`; produtos `exam` e `analytics`. Staff
modera e edita pelas ações inline da própria página. É canal de priorização com usuário, em uso.

## Convite e aceite
A instituição convida professor ou aluno por e-mail; o destinatário cai em `/accept-invite`, que cobre
quatro estados: já tem conta, precisa se cadastrar e aceitar, e-mail divergente, e erro. Há reenvio e
cópia de link para quando o e-mail não chega.

## Suporte
`/app/ajuda` e `/analytics/ajuda` — formulário que abre **ticket**, com threading por e-mail via Resend
Inbound e fila staff no Kintal.
