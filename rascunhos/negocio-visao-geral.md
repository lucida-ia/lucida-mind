---
destino: negocio/visao-geral.md
acao: substituir
origem: contexto-externo.md §1 · §2 · §9
quando_usar: explicar o que é a Lucida, problema que resolve, proposta de valor, escopo do produto
última_revisão: 2026-06
status: rascunho
---

# Lucida — Visão geral

A Lucida é uma **startup de EdTech em estágio pré-market fit**, construída por **3 founders bootstrap**
em Sorocaba. Nasceu como ferramenta de geração de provas com IA vinculadas ao conteúdo do professor
e evoluiu para um **ecossistema de avaliação e diagnóstico pedagógico**: a IA gera, corrige e devolve
inteligência acionável sobre o que cada aluno aprendeu.

O produto atende **professores individuais, infoprodutores e instituições de ensino** (escolas, redes,
cursinhos, universidades). Acesso via web e mobile.

## O problema que resolve

- Criar prova boa dá trabalho: enunciado, alternativas, gabarito, contextualização, nível de dificuldade.
- Corrigir é pior: objetiva é repetitiva; questão aberta é lenta e subjetiva.
- Acompanhar desempenho por turma/aluno costuma ficar no caderno ou numa planilha.

A Lucida ataca os três: **gera** a prova (objetivas + abertas), **corrige** (objetiva automática;
aberta por IA com rubrica + aprovação do professor) e **diagnostica** (analytics por turma/aluno/prova).

## Visão — de eficiência para eficácia (jun/2026)

A Lucida deixou de se definir por **eficiência** ("devolver tempo ao professor") e passou a se definir
por **eficácia** — apurar a assertividade do processo de aprendizagem: saber exatamente o que estudar
e qual a melhor maneira.

A distinção é estratégica, não cosmética:
- **Eficiência** (remover burocracia) é a **camada de aquisição** — o gancho que faz o professor entrar
  e começar a gerar dado.
- **Eficácia** (assertividade do aprendizado) é o **moat** — o que ninguém copia.

### Missão operacional
> Transformar instrumentos pedagógicos em decisão para construir uma melhor jornada educacional para
> o aluno.

O professor é o principal contribuidor do processo de ensino. A burocracia não deve ser o empecilho
da jornada pedagógica. Mas devolver tempo e saber ensinar bem são coisas distintas — a Lucida resolve
as duas, nessa ordem.

## O que entrega (resumo — detalhe em produto/suite.md)

- **Provas**: geração por IA em pt-BR/inglês/espanhol, com estilos e níveis; também montagem manual.
  Suporte a **LaTeX** para física e matemática (STEM).
- **Correção**: objetiva automática; aberta assistida por IA com rubrica, revisada pelo professor.
- **Planos de aula (backbone BNCC)**: estruturados por competências e habilidades BNCC, alimentam
  a geração de provas e o redesenho de metodologia por aluno.
- **Turmas/alunos/cursos**: organização do dia a dia; importação via Google Classroom.
- **Scanner OMR**: folha de resposta em papel lida por foto (serviço Python).
- **Aplicação ao aluno**: link público por prova, sem login do aluno.
- **Instituições**: dashboard com analytics e gestão (frente roxa).

## Modelo de negócio (resumo — detalhe em negocio/monetizacao-creditos.md)
Assinatura (planos Básico/Pro, mensal/anual) **+ consumo de créditos**. Cada ação de IA debita créditos;
créditos vêm do trial de boas-vindas, da renovação do plano ou de compras avulsas (cartão ou PIX).

## Mercado e tração (jun/2026)

| Métrica | Valor atual |
|---|---|
| Pagantes ativos | 2 (1 instituição + 1 infoprodutor) |
| MRR estimado | ~R$ 250 |
| Total pagantes histórico | 84 |
| MRR histórico (pré-re-baseline) | R$ 749,55 |
| Retenção anual | ~50% |
| Instagram | ~1k seguidores |
| Leads trial frios | >3k |

> ⚠ Re-baseline de jun/2026: base pagante reiniciada. Histórico de 40 pagantes e MRR R$ 749,55 é
> referência, não posição atual. Contexto estratégico em negocio/moat-flywheel.md.
