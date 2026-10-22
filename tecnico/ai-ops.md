---
quando_usar: mexer em geração/correção de IA, modelo OpenAI, extractors, streaming SSE, pricing de IA, LaTeX/matemática, "Meu estilo", instrução do professor, LuAS
última_revisão: 2026-10-22
status: canônico
tags: [biblioteca, correcao, ia]
---

# ai-ops — geração e correção por IA

Domínio `ai-ops`. Geração de questões e planos de aula, correção de respostas abertas, extração de
conteúdo de fontes e leitura da instrução do professor. Tudo roda **dentro da api**, que chama a
OpenAI direto (`ai-ops/infrastructure/openai/*`).

**O `ai-ops` não é o único ponto que chama a OpenAI.** O domínio `teacher-style` tem o próprio cliente
(`teacher-style/infrastructure/openai-style-annotator.ts`), que anota questões antigas na destilação
do "Meu estilo". O serviço Python de transcrição também chama a OpenAI (ver [tecnico/stack.md](stack.md)).

## Modelo
`OPENAI_API_KEY` obrigatório; `OPENAI_MODEL` com default **`gpt-4.1-mini`** — **um único env para todas as
tarefas** (geração objetiva/aberta, plano de aula, correção); não há modelo por tarefa. Exceção: o
verificador de explicação (telemetria) aceita `R2_VERIFIER_MODEL` como override — e ele só roda com
`R2_VERIFY === "1"`, **desligado por default**. Cobra-se por **tabela
determinística** (ver [tecnico/billing-ledger.md](billing-ledger.md)), não por token consumido. Os preços de **plano de aula**
são marcados como **provisórios** no código ("recalibrate once token usage is measured"); os de
prova/correção são estáveis.

**Tuning por família de modelo** (`ai-ops/infrastructure/openai/model-tuning.ts`): detecta modelos de
raciocínio (`gpt-5` ou série `o`, regex `/^(gpt-5|o[1-9])/i`) em runtime. O único branch é
**`temperature` vs `reasoning_effort`**: modelo de raciocínio omite `temperature` e ganha
`reasoning_effort: "low"` mais um `REASONING_TOKEN_HEADROOM` de 6.000 tokens no budget; modelo padrão
mantém `temperature`. O parâmetro `max_completion_tokens` (não `max_tokens`) é emitido para
**todos** — gpt-4.1/4o também o aceitam. Trocar o default para um gpt-5 é só mudar `OPENAI_MODEL`;
o código já se ajusta. (O default segue gpt-4.1-mini hoje.)

## Geração
- **Questões objetivas** (`multipleChoice`/`trueFalse`): enunciado, contexto, opções, gabarito,
  explicação, dificuldade. Parâmetros: estilo, dificuldade, idioma, quantidade.
- **Questões abertas**: enunciado, contexto, resposta de referência e **rubrica gerada** (critérios com
  níveis).
- **Planos de aula**: estrutura por segmento (objetivos, BNCC, desenvolvimento, avaliação).
- **Idiomas**: pt-BR / inglês / espanhol. **Estilos**: simple / contextual / analytical / reflective.
  (ver [produto/estilos-de-questao.md](../produto/estilos-de-questao.md).)
- **Regeneração**: questão individual ou bloco de plano, com custo marginal.
- **Múltipla escolha sai sempre com 5 alternativas**, em todo estilo (`MULTIPLE_CHOICE_OPTION_COUNT = 5`,
  em `exam/domain/question.ts`). A validação do exam aceita de 2 a 6 na edição manual.

## Ponto de troca do gerador
Os use cases dependem das interfaces `QuestionGenerator` (`domain/generation-types.ts`) e
`OpenQuestionGenerator` (`domain/open-generation-types.ts`). As implementações OpenAI
(`OpenAiQuestionGenerator`, `OpenAiOpenQuestionGenerator`) são instanciadas e injetadas em `main.ts`.
Trocar o motor de geração é trocar essa injeção.

## LuAS — planejado, não existe em código
O time decidiu (2026-08-26/27) tirar a geração de IA da api e levá-la para um microsserviço, o
**LuAS** (no repositório, `luaas`), consumível também por outras plataformas — por isso a ingestão de
fontes (PDF etc.) vai junto. **Nada disso está em código**: não há `services/luaas/`, nem pacotes
`@lucida/generation-contract`/`@lucida/extractors`, nem env, nem cliente na api. Existem só contratos
em rascunho (`docs/contracts/rascunhos/luaas-*.md`), a auditoria
`docs/audits/2026-08-26-engine-de-geracao-luaas.md` e as decisões de 26–27/ago em `docs/decisions/`.

O desenho planejado: `services/luaas/` no próprio monorepo; a primeira onda leva geração de questões
e deixa **plano de aula e correção** na api; API key por cliente, medição de uso e quota ficam num
contrato ainda não escrito. O encaixe na api é o ponto de troca acima.

## Instrução do professor
O professor escreve uma instrução livre ("foque em X, ignore Y"). Ela **nunca entra crua no prompt**:
`POST /v1/ai/parse-instruction` passa o texto (até 2.000 caracteres) pelo `openai-instruction-extractor.ts`,
que devolve um conjunto fechado de intenções (`InstructionIntents`: `focusTopics`, `excludeTopics`,
`emphasis`, `audience`, `excerpt`) mais o que foi descartado. O professor confirma, e as rotas de
geração e regeneração recebem `intents`, renderizadas por template próprio
(`prompts/shared/teacher-intents-block.ts`). Se chegar `instruction` sem `intents`, o gerador extrai
na hora.

`parse-instruction` **não debita crédito**. Tem rate limit por usuário real: 20 por minuto e 200 por
dia; acima disso, **429** (`AI_INSTRUCTION_THROTTLED`).

## Prova-modelo
`modelExamText` (até 200.000 caracteres) é uma prova antiga colada pelo professor, usada como
**referência de forma** — tipo de enunciado, tamanho, organização —, nunca de conteúdo
(`prompts/shared/model-exam-block.ts`). Entra delimitada como conteúdo não confiável e **não é
persistida**.

## Meu estilo (`teacher-style`)
Perfil de estilo destilado das provas que o próprio professor escreveu (ADR-0018). Página
**"Meu estilo"** no app (`/app/meu-estilo`).

| Rota | O que faz |
|---|---|
| `GET /v1/teacher-style` | Lê o perfil |
| `PUT /v1/teacher-style` | Grava `manualOverrides` (incluir/excluir questão da evidência) |
| `POST /v1/teacher-style/distill` | Destila (ou redestila) o perfil |

- **Destilação síncrona, com lease** de 10 min por professor (`teacher_style_distill_leases`): clique
  duplo recebe **409**. Só a anotação usa LLM; o resto é aritmética.
- **Janela de evidência**: o menor entre 12 meses, 20 provas e 200 questões. Cópias da mesma prova
  contam uma vez. Questão `ai` sem edição e questão sem explicação ficam fora.
- **Anotação por eixos fechados** — `surface`, `context`, `reasoningSteps`, `bloom`, `integration`, mais
  um teste de coerência explicação × gabarito (incoerente sai). O perfil guarda proporções por chave,
  nunca texto livre, para que nada de prova antiga vire instrução no prompt.
- **Peso de cada questão** = autoria × confiabilidade × recência. Autoria: `ai` 0, `ai_edited` 0,6,
  `manual`/`imported` 1, ausente 0. Confiabilidade: 1 com respostas suficientes, 0,5 sem.
  Recência: meia-vida de 6 meses, piso 0,25.
- **Mínimo de 5 questões** com peso; abaixo disso, **422**.
- **`manualOverrides` substitui a lista inteira** a cada `PUT` e recalcula sem chamar a IA. Redestilar
  preserva os overrides cujas questões continuam na janela.
- Persistência: coleção `teacher_style_profiles`, com `_id = ownerId` — um perfil por professor.

**Acesso**: as três rotas e o uso na geração passam pela `SubscriberAccessPolicy` — staff, membro de
instituição ou assinante ativo. Negado, devolve **402** próprio (`TEACHER_STYLE_ACCESS_DENIED`,
`TeacherStyleAccessDeniedError`, em `require-teacher-style-access.ts`), distinto do 402 de saldo. A
checagem roda antes do billing. **A destilação não debita crédito.**

**Uso na geração**: a flag `useTeacherStyle` existe nas quatro rotas de geração/regeneração de
questões (objetivas e abertas) — não no plano de aula. Com perfil, os eixos entram pelo bloco
`prompts/teacher-style-block.ts`; sem perfil, vale o estilo pronto.

## Ordem de precedência no prompt
Invariantes do produto → perfil do professor → instrução (intents) → estilo pronto
(`simple`/`contextual`/`analytical`/`reflective`). A prova-modelo entra depois do material e antes
das intents, como referência de forma.

## Correção de respostas abertas
- A IA recebe a rubrica e a resposta do aluno e **escolhe o `levelId` por critério**, com justificativa
  e feedback. **A IA não calcula nota** — o score sai do código (`submission/OpenGrade`) a partir dos
  níveis escolhidos.
- O resultado entra como `OpenGrade` com `source = ai`, `status = ai_suggested`. Vira nota válida só
  após **aprovação do professor** (`status = approved`).
- Respostas em branco recebem o mínimo sem custo de IA.

## Extractors (fontes de conteúdo)
PDF (`pdf-parse` v2, via `PDFParse`, que devolve o **texto por página** — é o que habilita a faixa de
páginas), DOCX (`mammoth`), texto colado e **YouTube** (via serviço Python de transcrição — ver
[tecnico/integracoes.md](integracoes.md)). O material extraído alimenta a geração de provas/planos.

**Guardas de material de fonte** (`collect-sources.ts`): abaixo de `MIN_MEANINGFUL_CHARS = 150` o
material é recusado — é o que pega PDF escaneado sem camada de texto. Erros: `EmptySourceMaterialError`,
`InsufficientSourceMaterialError`, `UnsupportedFileTypeError`.

## Faixa de páginas
O professor pode recortar **um intervalo de páginas** da fonte, tanto de um anexo quanto de um arquivo
da Biblioteca. `collect-sources.ts` recebe `attachmentRanges` (por índice do anexo) e
`librarySourceRanges` (por `fileId`) e fatia o texto **antes** do prompt
(`page-range.ts`, `slice-extraction-by-page-range.ts`). No arquivo da Biblioteca o recorte usa os
`pageTextSegments` persistidos — ver [tecnico/biblioteca.md](biblioteca.md).

## LaTeX / matemática nas questões
Fórmula matemática é **LaTeX inline no texto** (`statement`, `context`, `explanation`, `options`,
`referenceAnswer`, descritores de rubrica) — **não há campo/flag dedicado**; o web renderiza com **KaTeX**.
Na geração, cada campo passa por um pipeline de normalização (em ordem):
1. `repairMathLatex` (`infrastructure/openai/repair-math-latex.ts`) — restaura barras que o `JSON.parse`
   comeu (ex.: `\frac` virou form-feed + "rac"); `hasResidualControlChar` sinaliza corrupção irrecuperável.
2. `normalizeMathLatex` (`domain/normalize-math-latex.ts`) — reescreve comandos pt-BR (`\sen`, `\tg`,
   `\arctg`, `\cossec`, `\cotg`, `\mdc`, `\mmc`) para `\operatorname{...}`.
3. `normalizeMathDelimiters` (`infrastructure/openai/normalize-math.ts`) — `\[ \]` → `$$ $$`, `\( \)` →
   `$ $`, e envolve ambientes `begin/end` soltos em `$$`.

Provas antigas com LaTeX corrompido são reparadas pelo script `backfill:math-latex` (mesmo pipeline,
retroativo; `--dry-run` disponível). Ver [tecnico/stack.md](stack.md).

## Biblioteca como fonte (`libraryFileIds`)
A geração também aceita arquivos da **Biblioteca** (domínio `library`): passados via `libraryFileIds`, o
`ai-ops` resolve pela porta `library-source-resolver` (impl. `LibrarySourceResolverAdapter`) e recebe o
**texto já extraído** — **sem re-extração e sem custo de crédito** pela reutilização. Detalhe em
[tecnico/biblioteca.md](biblioteca.md).

## Streaming
Geração longa transmite via **SSE** (`shared/http/sse.ts`) para evitar timeout de proxy. O front
**não** usa `EventSource` (que é GET-only e não manda corpo) — faz `POST` + leitura manual do stream.
Ver [tecnico/arquitetura.md](arquitetura.md).

## Pós-processamento
`balance-answer-positions.ts` redistribui a posição da alternativa correta entre as questões, para o
gabarito não concentrar numa letra. `context-limit.ts` guarda o teto de contexto do modelo.

## Degradação
Sem `OPENAI_API_KEY` o app não sobe (env obrigatória). Os serviços externos opcionais (transcrição)
degradam para fallback/erro sem derrubar o resto.
