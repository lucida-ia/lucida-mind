---
destino: produto/suite.md
acao: substituir (adiciona backbone BNCC, LaTeX/STEM, ambiente do aluno)
origem: contexto-externo.md §4.1 · §4.2 · §4.3
quando_usar: listar os módulos do produto e o que cada um faz, entender o escopo funcional
última_revisão: 2026-06
status: rascunho
---

# Suíte de produto

Os módulos que o usuário toca. Mapeamento técnico (domínios da api) em tecnico/dominios.md.

## Plano de aula — backbone BNCC (lesson-plan + ai-ops)

O plano de aula deixou de ser documento e virou a **espinha estruturada** do produto. Segmentado por
BNCC (médio/fundamental), ele:
- Extrai e guarda informações do material enviado pelo professor.
- Alimenta a geração de **provas** e o **redesenho de metodologia** por aluno/competência.
- É o hub onde o resultado de cada avaliação **volta a escrever**, no nível da habilidade.

Posicionamento: *jornada de construção do conhecimento*, não *exploração do material didático*.

O professor pode sempre subir material avulso para gerar provas além do backbone.

Geração estruturada: objetivos, **habilidades BNCC**, introdução, desenvolvimento, conclusão,
avaliação. Quatro segmentos: Fundamental, Médio, Faculdade, Infoprodutor. Exporta DOCX, duplica,
arquiva e pode **gerar prova** a partir do plano.

## Provas (exam + ai-ops)

- **Geração por IA**: a partir de um tema/material, gera questões **objetivas** (múltipla escolha / V-F)
  e **abertas** (com rubrica). Parâmetros: estilo, dificuldade, idioma (pt-BR/inglês/espanhol),
  quantidade. Detalhe em produto/estilos-de-questao.md.
- **LaTeX**: suporte nativo para provas de física e matemática (STEM) — destrava o wedge de maior
  densidade (pré-vestibular / cursinho).
- **Montagem manual** e edição questão a questão; **regeneração** de uma questão específica.
- **Fontes de conteúdo**: PDF, DOCX, texto colado e **transcrição de vídeo do YouTube**.
- **Aplicação**: cada prova tem um **link público** (`/exam/[shareId]`) — o aluno responde online,
  sem login. Há também versão **imprimível** e nível de segurança configurável.

## Correção (submission + ai-ops)

- **Objetiva**: corrigida automaticamente (gabarito).
- **Aberta**: corrigida com **rubrica** — a IA sugere o nível por critério e justifica; o **professor
  revisa e aprova**. Só nota aprovada conta para o score. Existe fila de correção (`/app/corrigir-provas`).
- **Nota final**: 0–10, uma casa decimal.

## Analytics — diagnóstico pedagógico (analytics)

Dashboard de **organização** (frente roxa, `/analytics`):
- Por questão: dificuldade (p) e índice de discriminação — flagra questão confusa ou gabarito suspeito.
- Por dificuldade: acerto fácil/médio/difícil.
- Aluno vs. turma: nota individual, percentil e evolução ao longo das provas.
- Domínio por critério (questões abertas).
- Confiabilidade marcada: "Confiável" ou "Direcional" — nada inflado com amostras pequenas.
- *Roadmap:* diagnóstico por competência/habilidade BNCC e por pré-requisito.

Motor de analytics parametrizável ("cubo"). Detalhe em produto/decisoes-de-produto.md.

## Scanner OMR (scan)

Folha de resposta **em papel**: o servidor gera um PDF (1 página por aluno, com QR), o professor
imprime, aplica, fotografa e a Lucida lê as marcações via serviço Python (OpenCV). Vira `submission`
com `source = scanner`.

## Organização do dia a dia

- **Turmas** (class), **alunos** (student) e **cursos** (course) que agrupam turmas/provas.
- **Google Classroom**: importa turmas e alunos com reconciliação por e-mail (Fase 1).

## Ambiente do aluno (em construção)

Custo de manutenção ínfimo — habilitável pelo próprio professor. Acesso vinculado ao professor;
nos casos institucionais, fornecido pela instituição.

| Capacidade | Descrição | Status |
|---|---|---|
| **Gabarito virtual via QR Code** | Professor gera QR Code da prova; aluno preenche o gabarito pelo celular durante a prova offline — integra offline ao digital sem fricção | Planejado |
| **Calendário avaliativo** | Aluno visualiza avaliações passadas e futuras, acompanha evolução por prova e compara métricas ao longo do tempo | Planejado |
| **Artefatos pedagógicos** (vinculado à instituição) | Gera atividades, resumos, mapas mentais, flashcards a partir do conteúdo do plano de aula do professor | Planejado |
| **Avaliação da disciplina** | Ao fim do período, aluno avalia a disciplina — gera dado de feedback para professor e instituição | Planejado |
| **Relatório de desempenho** | Inferido pelo sistema; para alunos de formação de base, pode ser direcionado aos pais com linguagem adaptada | Planejado |

**Versão institucional (roadmap):** jornada curricular dirigida pelo plano de aula → lock-in de dado
— a instituição passa a depender da rede, não só de uma ferramenta.

⚠ Dado de aluno menor: LGPD com responsabilidade do professor/instituição como controlador de dados.

## Plataforma para parceiros (public-api + api-access + webhook-dispatch)

REST externo com API keys HMAC: turmas, alunos, links de prova, resultados. Webhooks de
`submission.completed` para endpoints cadastrados. Documentação em `/docs`.

## Backoffice (kintal)

Área interna staff-only: dashboard, gestão de staff/usuários/créditos, métricas (Mongo + PostHog),
kanban, notificações, roadmap, tickets de suporte. Não é exposto ao cliente.
