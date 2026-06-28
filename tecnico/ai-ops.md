---
quando_usar: mexer em geração/correção de IA, modelo OpenAI, extractors, streaming SSE, pricing de IA
última_revisão: 2026-06-27
status: canônico
---

# ai-ops — geração e correção por IA

Domínio `ai-ops`. Concentra todas as chamadas à OpenAI: geração de questões e planos de aula,
correção de respostas abertas e extração de conteúdo de fontes.

## Modelo
`OPENAI_API_KEY` obrigatório; `OPENAI_MODEL` com default **`gpt-4.1-mini`**. Cobra-se por **tabela
determinística** (ver tecnico/billing-ledger.md), não por token consumido. Os preços de **plano de aula**
são marcados como **provisórios** no código ("recalibrate once token usage is measured"); os de
prova/correção são estáveis.

## Geração
- **Questões objetivas** (`multipleChoice`/`trueFalse`): enunciado, contexto, opções, gabarito,
  explicação, dificuldade. Parâmetros: estilo, dificuldade, idioma, quantidade.
- **Questões abertas**: enunciado, contexto, resposta de referência e **rubrica gerada** (critérios com
  níveis).
- **Planos de aula**: estrutura por segmento (objetivos, BNCC, desenvolvimento, avaliação).
- **Idiomas**: pt-BR / inglês / espanhol. **Estilos**: simple / contextual / analytical / reflective.
  (ver produto/estilos-de-questao.md.)
- **Regeneração**: questão individual ou bloco de plano, com custo marginal.

## Correção de respostas abertas
- A IA recebe a rubrica e a resposta do aluno e **escolhe o `levelId` por critério**, com justificativa
  e feedback. **A IA não calcula nota** — o score sai do código (`submission/OpenGrade`) a partir dos
  níveis escolhidos.
- O resultado entra como `OpenGrade` com `source = ai`, `status = ai_suggested`. Vira nota válida só
  após **aprovação do professor** (`status = approved`).
- Respostas em branco recebem o mínimo sem custo de IA.

## Extractors (fontes de conteúdo)
PDF (`pdf-parse`), DOCX (`mammoth`), texto colado e **YouTube** (via serviço Python de transcrição —
ver tecnico/integracoes.md). O material extraído alimenta a geração de provas/planos.

## Biblioteca como fonte (`libraryFileIds`)
A geração também aceita arquivos da **Biblioteca** (domínio `library`): passados via `libraryFileIds`, o
`ai-ops` resolve pela porta `library-source-resolver` (impl. `LibrarySourceResolverAdapter`) e recebe o
**texto já extraído** — **sem re-extração e sem custo de crédito** pela reutilização. Detalhe em
tecnico/biblioteca.md.

## Streaming
Geração longa transmite via **SSE** (`shared/http/sse.ts`) para evitar timeout de proxy; o front escuta
com `EventSource`. Ver tecnico/arquitetura.md.

## Degradação
Sem `OPENAI_API_KEY` o app não sobe (env obrigatória). Os serviços externos opcionais (transcrição)
degradam para fallback/erro sem derrubar o resto.
