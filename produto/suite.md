---
quando_usar: listar os módulos do produto e o que cada um faz, entender o escopo funcional
última_revisão: 2026-06-30
status: canônico
---

# Suíte de produto

Os módulos que o usuário toca. Mapeamento técnico (domínios da api) em tecnico/dominios.md.

## Provas (exam + ai-ops)
- **Geração por IA**: a partir de um tema/material, gera questões **objetivas** (múltipla escolha / V-F)
  e **abertas** (com rubrica). Parâmetros: estilo, dificuldade, idioma (pt-BR/inglês/espanhol),
  quantidade. Detalhe em produto/estilos-de-questao.md.
- **Montagem manual** e edição questão a questão; **regeneração** de uma questão específica.
- **Tipo de atividade**: cada prova tem um tipo (`activityType`) — **Prova**, **Simulado**, **Quiz** ou
  **Lista de Exercícios** — usado para classificar/filtrar; não muda geração, preço nem correção.
- **Fontes de conteúdo**: PDF, DOCX, texto colado, **transcrição de vídeo do YouTube** e arquivos da
  **Biblioteca** (ver abaixo).
- **Matemática**: enunciados, alternativas e explicações suportam **fórmulas (LaTeX)**, renderizadas com
  KaTeX na prova online e na versão imprimível.
- **Aplicação**: cada prova tem um **link público** (`/exam/[shareId]`) — o aluno responde online,
  sem login. Há também versão **imprimível** e nível de segurança configurável.
- **Agendamento**: a prova pode ter uma **janela de resposta** (abre/fecha em data-hora) e, opcionalmente,
  **avisar os alunos por e-mail quando abrir**. Sem janela, fica sempre respondível. Ver Calendário abaixo.

## Correção (submission + ai-ops)
- **Objetiva**: corrigida automaticamente (gabarito).
- **Aberta**: corrigida com **rubrica** — a IA sugere o nível por critério e justifica; o **professor
  revisa e aprova**. Só nota aprovada conta para o score. Existe fila de correção (`/app/corrigir-provas`).
- **Nota final**: 0–10, uma casa decimal.

## Planos de aula (lesson-plan + ai-ops)
Geração estruturada: objetivos, **habilidades BNCC**, introdução, desenvolvimento, conclusão, avaliação.
Quatro segmentos: Fundamental, Médio, Faculdade, Infoprodutor. Exporta **DOCX**, duplica, arquiva e
pode **gerar prova** a partir do plano.

## Biblioteca (library)
Acervo de materiais do professor (`/app/biblioteca`): sobe **PDF/DOCX/TXT** uma vez (upload direto ao
storage, presigned), a Lucida **extrai o texto** e organiza por **disciplina e segmento**
(Fundamental/Médio/Faculdade/Infoprodutor). Esses arquivos viram **fonte reutilizável** na geração de
provas e planos de aula — sem re-upload nem custo extra de crédito na reutilização. Acesso liberado para
staff, membros de organização ou assinantes ativos (senão, tela de upsell). Detalhe em tecnico/biblioteca.md.

## Calendário (calendar + exam-notification)
Visão de **agenda das provas com janela** (`/app/calendario`): mostra num grid de mês quando cada
atividade abre/fecha. Quando uma prova marcada com "avisar ao abrir" entra na janela, a Lucida **dispara
e-mail aos alunos** com o link, automaticamente (ou por reenvio manual do professor). Feature **de
assinante** (staff, instituição ou assinatura ativa; senão, upsell). Detalhe em tecnico/calendario.md.

## Organização do dia a dia
- **Turmas** (class), **alunos** (student) e **cursos** (course) que agrupam turmas/provas. A turma guarda
  **nível de ensino** (Fundamental/Médio/Superior/Personalizado + série livre) e **objetivos de
  aprendizagem** (BNCC ou personalizados).
- **Google Classroom**: importa turmas e alunos com reconciliação por e-mail (Fase 1).
- **Média de aprovação**: o professor configura sua **nota de corte** (default 6) — usada para classificar
  aprovado/reprovado nas análises e nos indicadores. Ver produto/decisoes-de-produto.md.
- **Onboarding**: tour guiado (mascote Lulu) na primeira vez no `/app`, refazível pelo menu de perfil.

## Scanner OMR (scan)
Folha de resposta **em papel**: o servidor gera um PDF (1 página por aluno, com QR), o professor imprime,
aplica, fotografa e a Lucida lê as marcações via serviço Python (OpenCV). Vira `submission` com
`source = scanner`.

## Instituições e analytics (analytics)
Dashboard de **organização** (frente roxa, `/analytics`): visões de overview, professor, turma, aluno,
prova e membros. Motor de analytics parametrizável ("cubo"). Detalhe em produto/decisoes-de-produto.md.

## Plataforma para parceiros (public-api + api-access + webhook-dispatch)
REST externo com API keys HMAC: turmas, alunos, links de prova, resultados. Webhooks de
`submission.completed` para endpoints cadastrados. Documentação em `/docs`.

## Backoffice (kintal)
Área interna staff-only: dashboard, gestão de staff/usuários/créditos, métricas (Mongo + PostHog),
kanban, notificações, roadmap, tickets de suporte. Não é exposto ao cliente.
