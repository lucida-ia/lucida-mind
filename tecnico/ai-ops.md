---
quando_usar: mexer em geração/correção de IA, modelo OpenAI, extractors, streaming SSE, pricing de IA, LaTeX/matemática
última_revisão: 2026-08-25
status: canônico
---

# ai-ops — geração e correção por IA

Domínio `ai-ops`. Concentra todas as chamadas à OpenAI: geração de questões e planos de aula,
correção de respostas abertas e extração de conteúdo de fontes.

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
