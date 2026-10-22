---
quando_usar: explicar o que é a Lucida, problema que resolve, proposta de valor, escopo do produto
última_revisão: 2026-10-22
status: canônico
---

# Lucida — Visão geral

A Lucida é um **SaaS de educação para professores**: ajuda quem dá aula a **criar e corrigir provas
com IA**, montar **planos de aula**, organizar **turmas/alunos/cursos** e ler **folhas de resposta em
papel** (scanner OMR). Por cima do professor individual existe uma camada de **instituição**
(organizações) com **analytics** pedagógico e gestão de membros, e do outro lado uma **Área do Aluno**,
onde o aluno tem login próprio.

**Reposicionamento decidido pelos sócios em out/2026:** a Lucida se divide em duas frentes — **Lucida
School**, para educação formal, e **Lucida Creators**, para educação informal — e o foco passa a ser a
**experiência de aprendizagem, avaliativa e relacional**, não o ferramental. O código ainda não tem traço
das duas frentes; o que segue descreve o produto como ele existe hoje. Decisão em
[produto/decisoes/school-e-creators.md](../produto/decisoes/school-e-creators.md).

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
- **Área do Aluno** (`/aluno`): o aluno cria conta própria e entra na turma por um convite que o
  professor gera. No portal vê suas turmas, o calendário de provas, responde e consulta os próprios
  resultados, separado por instituição e por "Meus professores". Detalhe técnico em
  [tecnico/dominios.md](../tecnico/dominios.md).
- **Meu Estilo**: a Lucida aprende o estilo de prova do professor a partir das questões que ele
  escreveu ou editou e usa esse perfil nas próximas gerações. O professor pode tirar questões da
  amostra.
- **Instituições**: dashboard de organização com analytics e gestão (frente roxa), com créditos
  compartilhados quando a instituição adota um modo de billing próprio.
- **Auxiliares**: o professor delega o operacional a um auxiliar que atua em nome dele, sem herdar
  a autoridade administrativa.

**Para vender a instituições** existe uma **demo institucional**: um site à parte, com dados fictícios,
que mostra criar, aplicar/corrigir e analisar sem precisar de conta, em três versões (escola, cursinho,
universidade). Termina num formulário de contato; o **lead** chega por e-mail ao time. Detalhe em
[tecnico/integracoes.md](../tecnico/integracoes.md).

## Modelo de negócio (resumo — detalhe em [negocio/monetizacao-creditos.md](monetizacao-creditos.md))
Assinatura (planos Básico/Pro, mensal/anual) **+ consumo de créditos**. Cada ação de IA debita créditos;
créditos vêm de boas-vindas, da renovação do plano ou de top-ups avulsos por cartão (o PIX está
temporariamente indisponível).

## Mercado e tração
> a definir — não há base no código. Tamanho de mercado, número de usuários, metas de receita e
> narrativa de GTM precisam de contexto de negócio externo. Ver [negocio/icp-beachhead.md](icp-beachhead.md).
