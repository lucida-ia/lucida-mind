---
quando_usar: consultar o schema proposto do objeto de aprendizagem (Q-matrix), as regras de feedback, o que do objeto já existe no código e o que o épico #141 (conhecimento-chave por questão) está construindo
última_revisão: 2026-10-22
status: canônico
tags: [moat]
---

# Objeto de aprendizagem — comportamento proposto

O schema que amarra questão a Knowledge Component, as regras de feedback e as verificações de
qualidade que o pipeline deveria embutir. As duas últimas seções **não** são proposta: uma diz o que
existe no código, a outra o que está em construção.

> **Este doc é uma de três partes.** O fundamento científico está em
> [produto/motor-assertividade.md](motor-assertividade.md); os parâmetros e a escada de
> maturidade, em [produto/maturidade-do-motor.md](maturidade-do-motor.md); o objeto proposto,
> em [produto/objeto-de-aprendizagem.md](objeto-de-aprendizagem.md). **KC por questão não existe no
> código**: está em construção no épico #141 (ver o fim deste doc).

---

> **Enquadramento:** derivado da skill operacional "Objeto de Aprendizagem" (a skill em si vive fora
> desta base, no repo de skills do agente — aqui só o conhecimento de produto). Descreve como o
> produto **possivelmente** deve se comportar segundo a instrução construída na skill. **Não é
> decisão canônica.** O contrato do #141 já diverge deste schema em vários pontos — a tabela no fim
> diz quais.

## Princípio central

"Cada questão é um objeto de aprendizagem" só é verdade se ela carregar identidade suficiente para
ser rastreável **entre provas diferentes**, não apenas dentro de uma prova. Sem essa estrutura, a
questão é evento isolado; com ela, cada resposta do aluno vira evidência dentro da trajetória de um
KC.

### O que "identidade" significa aqui — três conceitos, não um

O gerador **cria questões novas a cada prova**; ele não reusa o mesmo objeto-questão entre provas.
Confundir os três conceitos abaixo leva a modelagem errada:

- **`questionId`** — identidade da *instância*: uma ocorrência de questão numa prova. É o que permite
  atribuir a resposta a ela. Não existe: a questão é subdocumento sem id e a `Submission` responde por
  índice posicional (issue #135, aberta).
- **`family_id`** — chave de *agrupamento* das instâncias que testam o(s) mesmo(s) KC(s) entre provas.
  Não existe e não está no contrato do #141, onde o âncora entre provas é o id estável do conceito no
  catálogo da organização.
- **`kc[]`** — os códigos (BNCC ou provisórios) que a instância exercita. No #141, um conceito
  principal e até dois secundários por questão.

## Schema proposto do objeto

| Campo | Tipo | Descrição |
|---|---|---|
| `questao_id` | string | Identificador da questão |
| `kc` | lista | Código(s) BNCC ou KC provisório |
| `kc_status` | validado \| não validado | Se o professor confirmou o mapeamento |
| `nivel_cognitivo` | Bloom (6) ou SOLO (5) | Bloom para objetivas; SOLO para discursivas |
| `dificuldade_prior` | baixa \| média \| alta | Estimativa qualitativa pré-dado; o motor recalibra com respostas reais |
| `discriminacao_esperada` | baixa \| alta | Sinaliza revisão se baixa — questões de baixa discriminação poluem a estimativa de domínio |
| `feedback_tarefa` | texto | Sempre presente |
| `feedback_processo` | texto \| null | Obrigatório se nível "aplicar"+ ou discursiva |
| `feedback_autorregulacao` | texto \| null | Só a partir da 2ª exposição ao KC |
| `distrator_diagnostico` | mapa alternativa→concepção | Só objetivas |
| `family_id` | string | Agrupa questões do mesmo KC entre provas |
| `intervalo_sugerido_revisao` | curto \| médio \| longo | Baseado em spacing (Cepeda 2008) |

## Conceitos do schema

- **`family_id`** — agrupa questões que testam o(s) mesmo(s) KC(s), mesmo em provas diferentes. É o
  que permitiria ao BKT tratar respostas de provas distintas como a mesma série temporal. Também é o
  gancho de deduplicação: duas questões com mesmo `family_id` e mesmos números são redundância.
- **`kc_status` (validado / não validado)** — o mapeamento nasce "não validado"; após validação
  única pelo professor, reutiliza sem repedir; só re-sinaliza se o padrão de resposta divergir de
  outras questões do mesmo KC. Espelha o padrão `ai_suggested → approved` que a correção de abertas
  já usa (professor-in-the-loop com fricção mínima).
- **KC provisório** — sem plano BNCC vinculado, cria-se KC com nome curto descritivo (ex.:
  `razao_trabalho_conjunto`); nunca deixar vazio. É o mecanismo dos KCs abertos para os segmentos
  FACULDADE/INFOPRODUTOR, onde a taxonomia BNCC não se aplica.
- **`distrator_diagnostico`** — para cada alternativa incorreta de objetiva, a concepção errada
  específica que levaria a escolhê-la. Cada distrator vira uma sonda de sub-erro distinto: transforma
  "1 questão" em "1 questão + N sondas de erro" e multiplica a resolução do diagnóstico sem custo
  extra para o professor (conecta com o princípio de amplitude, em [produto/maturidade-do-motor.md](maturidade-do-motor.md)). Se dois distratores mapeiam a
  mesma concepção, ou um não corresponde a erro plausível → sinal de baixa discriminação. Para
  discursivas, o equivalente é a rubrica/espelho por níveis SOLO.

## Regras propostas de feedback (Hattie & Timperley 2007)

Roteiro em até 3 níveis por exposição:
- **Tarefa** — o que estava certo/errado no resultado (sempre presente).
- **Processo** — qual passo do raciocínio falhou (obrigatório para discursivas e nível "aplicar"+).
- **Autorregulação** — pergunta que o aluno deveria ter se feito (só a partir da 2ª exposição ao
  mesmo KC).
- **Nunca** feedback de nível "self" (elogio/crítica pessoal) — o menos eficaz na literatura.

## Verificações de qualidade que o pipeline deve embutir

Aprendidas em testes reais com provas da Lucida:

1. **Recalcular e conferir o gabarito** ao estruturar — recomputar a resposta e comparar com o
   gabarito gerado. Bloqueia na origem questões defeituosas (sem alternativa correta) — já observado
   em prova real.
2. **Deduplicar por `family_id`** — detectar itens equivalentes na mesma prova. Hoje o gerador
   deduplica por texto normalizado do enunciado, não por KC.
3. **Sinalizar mismatch de tagging** — se o título/plano diz um conteúdo (ex.: "Logaritmos") mas os
   KCs das questões são de pré-requisito (ex.: potências/radicais), avisar: o gap diagnosticado
   cairia na camada errada.
4. **Cobertura cognitiva** — reportar se a prova concentra tudo em "aplicar" e não toca
   "analisar/avaliar".

## Modo B — estilo do professor (entregue, com escopo menor que o proposto)

A proposta original: quando o professor sobe **provas antigas** na Biblioteca, inferir o formato das
provas dele e os KCs das questões já montadas, que alimentariam a Q-matrix como terceira fonte de dado.

O que foi entregue é o **perfil de estilo do professor** (domínio `teacher-style`, ADR-0018 aceito):

- **Evidência:** só as provas do próprio dono que estão na coleção de provas da Lucida, dos últimos
  12 meses, até 20 provas e 200 questões. Questão gerada por IA sem edição fica fora. **Não lê a
  Biblioteca nem prova externa que não virou prova na Lucida.**
- **Peso de cada questão:** autoria × confiabilidade × recência. Autoria: `manual` e `imported` 1,
  `ai_edited` 0,6, `ai` e desconhecida 0. Confiabilidade: 1 com 15+ respostas, 0,5 abaixo (o mesmo
  corte do selo do analytics). Recência: meia-vida de 6 meses, piso 0,25.
- **O que extrai:** distribuições em eixos fechados — tamanho do enunciado, presença de contexto,
  passos de raciocínio, nível de Bloom (`lembrar`/`aplicar`/`analisar`/`avaliar`) e integração —
  mais 3 a 5 questões de exemplo. Precisa de pelo menos 5 questões com peso.
- **Acionamento:** opt-in por geração (`useTeacherStyle`), não automático. Destilar não cobra crédito.
- **Não alimenta Q-matrix nem KC.** O Bloom anotado vive no perfil de estilo, apontado por
  `examId` + índice da questão; não é gravado na questão.

O mínimo de 5 questões do perfil é o que existe no lugar do `N_min_calibracao_professor` (ver
[produto/maturidade-do-motor.md](maturidade-do-motor.md)).

---

## O que já existe no código

Nenhuma questão carrega KC, `family_id`, nível cognitivo ou distrator diagnóstico. O que existe:

| Peça | Estado |
|---|---|
| Análise de item por prova | Dificuldade (p-valor), discriminação pelo índice dos 27% (mediana abaixo de 10 respondentes), tabela de distratores **empírica** (quantos escolheram cada alternativa, flag `bad_distractor`). Só objetivas |
| Selo Confiável/Direcional | Por número de respondentes no recorte: Confiável a partir de 15 (`RELIABLE_MIN_N`) |
| Domínio por critério de rubrica | Discursivas. Modo por prova ou por nome do critério entre provas; por nome é sempre Direcional |
| Linha do tempo | Uma nota média por prova aplicada, em sequência |
| Corte por habilidade no cubo | Modelado, sempre vazio, com a nota "BNCC ainda não mapeado nas questões" |
| Bloom e distrator na geração | Só como instrução de prompt (régua interna de dificuldade e disciplina de distrator). Nada é gravado. As regras do prompt proíbem código BNCC no conteúdo gerado |
| Acerto por questão | Não é gravado nas objetivas: a `Submission` guarda a alternativa marcada por posição e a nota final. Discursiva grava a nota por questão |

## O ADR da questão rastreável — parado

O ADR de ago/2026 (registrado na base como ADR-0012; no monorepo é o **0009**, só na branch
`adr/0010-multi-tenant-institution`, status `proposto`, nunca mesclado) propunha `questionId` no
snapshot, um domínio `learning-object` com coleção `learning_objects` (`kc[]`, `kc_status`,
`family_id`, `nivel_cognitivo`, `distrator_diagnostico`) e a `Submission` respondendo por `questionId`.
**Não avançou.** Para KC, foi substituído pelo contrato do épico #141. Resumo em
[produto/decisoes/adr-0012-questao-rastreavel.md](decisoes/adr-0012-questao-rastreavel.md).

A razão de a metadata pedagógica viver **fora** do `Exam` segue válida e o #141 a mantém: o `Exam` é
registro de avaliação, e corrigir o KC de uma questão não pode mudar nota já dada.

## Em construção — épico #141, conhecimento-chave por questão

Contrato das Fases 0 e 1 em rascunho (PR #221, aberto, out/2026). Nada dele está na `staging`.

| Fase | Entrega |
|---|---|
| 0 | Conjunto rotulado (≥ 200 questões sintéticas, rotuladas por professor da equipe) e a baseline de custo por questão da geração |
| 1 | Catálogo de conceitos **por organização**: domínio `knowledge`, coleção `knowledge_concepts`, entidade `Concept`. Semeado dos objetivos da turma e das habilidades dos planos de aula. Nenhuma questão ganha rótulo |
| 2 | Rótulo na questão: um conceito principal + até 2 secundários, com procedência. A IA rotula na geração, o professor confirma ou troca. Depende da #135 (id estável da questão) |
| 3 | Plano da prova: o professor escolhe conceitos e pesos antes de gerar |
| 4 | Fato imutável por resposta: acerto por resposta e conceito. Preenche o corte por habilidade do cubo |
| 5 | Domínio por conceito na turma, no professor e na org, com os cortes do selo atual; lacuna e remediação |

Regras do catálogo: `status` `confirmed` ou `pending`; `origin` `seed_class_objective`,
`seed_lesson_plan`, `teacher` ou `ai`; `source` `bncc` ou `custom`, com `code` livre e não validado
(não há lista BNCC oficial no repositório). Qualquer membro cria; **curadoria** (confirmar, rejeitar,
fundir, arquivar, renomear) só `owner` e `admin`. O catálogo é livre (não consome crédito) e fica com
a org quando o professor sai.

O que o contrato **não** traz em relação ao schema proposto acima:

| Proposto | No #141 |
|---|---|
| `family_id` | Não existe. O âncora entre provas é o id do conceito |
| `kc_status` por questão | O status é do conceito no catálogo (`confirmed`/`pending`); a procedência do rótulo na questão é Fase 2 |
| `nivel_cognitivo` (Bloom/SOLO) gravado | Não |
| `distrator_diagnostico` | Não |
| BKT, `p(domínio)`, CDM | Não. A agregação da Fase 5 usa os cortes de respondentes do selo atual |
| Dificuldade | Fase 2 deriva uma dificuldade da contagem de conceitos, ao lado da declarada e da empírica |
