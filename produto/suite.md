---
quando_usar: listar os módulos do produto e o que cada um faz, entender o escopo funcional
última_revisão: 2026-06
status: canônico
---

# Suíte de produto

Os módulos que o usuário toca. Mapeamento técnico (domínios da api) em tecnico/dominios.md.

## Provas (exam + ai-ops)
- **Geração por IA**: a partir de um tema/material, gera questões **objetivas** (múltipla escolha / V-F)
  e **abertas** (com rubrica). Parâmetros: estilo, dificuldade, idioma (pt-BR/inglês/espanhol),
  quantidade. Detalhe em produto/estilos-de-questao.md.
- **Montagem manual** e edição questão a questão; **regeneração** de uma questão específica.
- **Fontes de conteúdo**: PDF, DOCX, texto colado e **transcrição de vídeo do YouTube**.
- **Aplicação**: cada prova tem um **link público** (`/exam/[shareId]`) — o aluno responde online,
  sem login. Há também versão **imprimível** e nível de segurança configurável.

## Correção (submission + ai-ops)
- **Objetiva**: corrigida automaticamente (gabarito).
- **Aberta**: corrigida com **rubrica** — a IA sugere o nível por critério e justifica; o **professor
  revisa e aprova**. Só nota aprovada conta para o score. Existe fila de correção (`/app/corrigir-provas`).
- **Nota final**: 0–10, uma casa decimal.

## Planos de aula (lesson-plan + ai-ops)
Geração estruturada: objetivos, **habilidades BNCC**, introdução, desenvolvimento, conclusão, avaliação.
Quatro segmentos: Fundamental, Médio, Faculdade, Infoprodutor. Exporta **DOCX**, duplica, arquiva e
pode **gerar prova** a partir do plano.

## Organização do dia a dia
- **Turmas** (class), **alunos** (student) e **cursos** (course) que agrupam turmas/provas.
- **Google Classroom**: importa turmas e alunos com reconciliação por e-mail (Fase 1).

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
