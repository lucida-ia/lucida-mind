---
quando_usar: explicar o que é a Lucida, problema que resolve, proposta de valor, escopo do produto
última_revisão: 2026-08-25
status: canônico
---

# Lucida — Visão geral

A Lucida é um **SaaS de educação para professores**: ajuda quem dá aula a **criar e corrigir provas
com IA**, montar **planos de aula**, organizar **turmas/alunos/cursos** e ler **folhas de resposta em
papel** (scanner OMR). Por cima do professor individual existe uma camada de **instituição**
(organizações) com **analytics** pedagógico e gestão de membros.

## O problema que resolve
- Criar prova boa dá trabalho: enunciado, alternativas, gabarito, contextualização, nível de dificuldade.
- Corrigir é pior ainda: objetiva é repetitivo; **questão aberta** é lenta e subjetiva.
- Acompanhar desempenho por turma/aluno costuma ficar no caderno ou numa planilha.

A Lucida ataca os três: **gera** a prova (objetivas + abertas), **corrige** (objetiva automática;
aberta por IA com rubrica + aprovação do professor) e **diagnostica** (analytics por turma/aluno/prova).

## O que entrega (resumo — detalhe em [produto/suite.md](../produto/suite.md))
- **Provas**: geração por IA em pt-BR/inglês/espanhol, com estilos, níveis e tipo de atividade (prova,
  simulado, quiz, lista de exercícios); também montagem manual.
- **Correção**: objetiva automática; aberta assistida por IA com rubrica, revisada pelo professor.
- **Planos de aula**: geração estruturada (objetivos, habilidades BNCC, desenvolvimento, avaliação).
- **Biblioteca**: acervo de materiais (PDF/DOCX/TXT) do professor, reusável como fonte das gerações.
- **Turmas/alunos/cursos**: organização do dia a dia; importação via Google Classroom.
- **Scanner OMR**: folha de resposta em papel lida por foto (serviço Python).
- **Aplicação ao aluno**: link público por prova (`/exam/[shareId]`), sem login do aluno — ou link
  com token por aluno, com a identidade pré-preenchida; opcional
  **agendamento** da janela de resposta com **aviso por e-mail** quando abrir (calendário).
- **Instituições**: dashboard de organização com analytics e gestão (frente roxa), com créditos
  compartilhados quando a instituição adota um modo de billing próprio.
- **Auxiliares**: o professor delega o operacional a um auxiliar que atua em nome dele, sem herdar
  a autoridade administrativa.

## Modelo de negócio (resumo — detalhe em [negocio/monetizacao-creditos.md](../negocio/monetizacao-creditos.md))
Assinatura (planos Básico/Pro, mensal/anual) **+ consumo de créditos**. Cada ação de IA debita créditos;
créditos vêm de boas-vindas, da renovação do plano ou de top-ups avulsos por cartão (o PIX está
temporariamente indisponível).

## Mercado e tração
> a definir — não há base no código. Tamanho de mercado, número de usuários, metas de receita e
> narrativa de GTM precisam de contexto de negócio externo. Ver [negocio/icp-beachhead.md](../negocio/icp-beachhead.md).
