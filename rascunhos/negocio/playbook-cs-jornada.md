---
quando_usar: montar com uma instituição a primeira jornada avaliativa usando o que o produto já tem, e operar o CS junto da instituição (cadência, convenção, placar de saúde)
última_revisão: 2026-10-22
status: rascunho
tags: [instituicao]
---

# Playbook de CS — jornada avaliativa com o que já existe

> **Rascunho — nunca validado.** Desenho de out/2026 para testar com a primeira instituição. Usa só o
> que está na `staging`; o KC por questão (épico #141) ainda não existe e é substituído por uma
> convenção.

A jornada é desenhada para cada instituição, a partir do material e das competências dela (ver
[produto/decisoes/engajamento-fora-da-janela.md](../../produto/decisoes/engajamento-fora-da-janela.md)).
O CS opera junto da coordenação e dos professores até a instituição andar sozinha.

## A convenção que substitui o KC por questão

**Uma atividade mede uma competência, e cada critério de rubrica leva o nome da competência.** Com
isso, a linha do tempo por atividade do cubo vira uma série por competência, e o domínio por critério
de rubrica entre provas (modo por nome, sempre "Direcional") vira leitura por competência.

- Título da atividade começa pelo código ou nome curto da competência.
- Prova mista (várias competências) não dá leitura por competência: evitar no começo.
- O mapa competência → atividades fica numa planilha do CS até o #141.

## Ferramentas por etapa

| Etapa | O que usar |
|---|---|
| Instituição | Kintal cria a org; convite de professores; turma com nível e **objetivos de aprendizagem** (BNCC ou próprios) |
| Competências | Os objetivos da turma. Pelo contrato do #141, eles viram conceitos `confirmed` do catálogo: o trabalho feito agora é aproveitado |
| Acervo | Biblioteca (reutilizar não cobra crédito) e transcrição de vídeo |
| Estilo | "Meu estilo", a partir de 5 questões com peso (feitas ou editadas pelo professor) |
| Atividades | Quiz e lista de exercícios **sem janela** (sempre respondíveis: antes e depois dos marcos) e prova ou simulado **com janela** (marco somativo) |
| Ritmo | Calendário com janela e aviso por e-mail ao aluno |
| Aluno | Área do Aluno com convite por turma |
| Leitura | Cubo de analytics: linha do tempo por atividade, domínio por critério de rubrica, selo Confiável (15 ou mais respondentes) |

Detalhe do produto em [produto/suite.md](../../produto/suite.md).

## Como o CS atua dentro da instituição

- **Auxiliar** do professor para operar em nome dele: acesso aos dados, sem autoridade
  administrativa, vínculo registrado. Ver [produto/decisoes/delegacao-a-auxiliares.md](../../produto/decisoes/delegacao-a-auxiliares.md).
- **"Atuar como" do Kintal** só para suporte pontual (impersonação com registro).
- **Kintal** para a visão de todas as instituições: métricas, board, tickets.
- **Campanhas in-app** pelo admin da org para lembrar professores.

## Cadência

| Quando | O que acontece |
|---|---|
| Semana 0 | CS e coordenação definem as competências do período e cadastram como objetivos das turmas |
| Semanas 1–2 | Com cada professor: acervo na Biblioteca; 4 a 6 atividades por competência (quiz diagnóstico, listas sem janela, uma prova com janela); agenda no calendário; convite dos alunos |
| Quinzenal | CS lê o cubo e devolve à coordenação: onde a turma trava, quais competências têm selo Confiável, quais alunos não respondem |
| Bimestral | Ajuste da jornada: novas listas para as competências fracas, revisão do mapa |

## Placar de saúde por instituição

| Indicador | Meta inicial | De onde vem |
|---|---|---|
| Turmas com objetivos cadastrados | 100% | Turmas |
| Atividades por competência | 4 ou mais | Planilha do CS |
| Alunos com conta na Área do Aluno | a calibrar | Área do Aluno |
| Respostas em atividades sem janela | a calibrar | Submissões |
| Recortes com selo Confiável | a calibrar | Cubo |
| Professores ativados (`user_activated`) | todos | PostHog |

Sinais de atividade do professor em [tecnico/eventos-posthog.md](../../tecnico/eventos-posthog.md) e
no log de atividade (ver [tecnico/dominios.md](../../tecnico/dominios.md)).

## Limites de hoje

- **Uma tentativa por atividade.** Praticar de novo exige gerar outra atividade da mesma competência.
- **Sem KC por questão.** A leitura por competência depende da convenção.
- **Sem visão de jornada para o CS.** Hoje está espalhada entre o cubo e o Kintal.

## O que destrava a escala

1. O épico #141 (KC por questão), que aposenta a planilha.
2. Uma visão "jornada da instituição" para o CS.
3. Repetir atividade na Área do Aluno sem gerar outra.

Os dois últimos não estão em nenhum contrato. Contexto estratégico em
[rascunhos/negocio/estrategia-jornada-e-canal-unifast.md](estrategia-jornada-e-canal-unifast.md).
