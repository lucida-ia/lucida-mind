---
quando_usar: definir tipos de questão, estilos de geração, dificuldade, idiomas suportados
última_revisão: 2026-10-22
status: canônico
tags: [billing, correcao, ia]
---

# Estilos de questão, dificuldade e idiomas

Fontes: `apps/api/src/domains/exam/domain/question.ts`,
`apps/api/src/domains/ai-ops/domain/generation-types.ts`,
`apps/api/src/domains/ai-ops/domain/open-generation-types.ts` (questões abertas).
Definição de `Question`, `Rubric` e `ExamStyle` em [produto/glossario.md](glossario.md); o preço de
cada estilo, em [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).

## Tipos de questão (no exam)
`QuestionType = "multipleChoice" | "trueFalse" | "open"`

- **multipleChoice** — a IA gera **sempre 5 alternativas**, em todo estilo
  (`MULTIPLE_CHOICE_OPTION_COUNT = 5`). Na edição, a validação aceita de 2 a 6 opções. Exatamente 1
  correta. Sem rubrica.
- **trueFalse** — exatamente 2 opções. Sem rubrica.
- **open** (aberta/discursiva) — sem opções e sem gabarito; **exige `rubric`** e pode ter
  `referenceAnswer`. A pontuação vem da rubrica, não de gabarito.

## Autoria por questão (`QuestionAuthorship`)
`"ai" | "ai_edited" | "manual" | "imported"` — cada questão guarda quem a escreveu. Quem decide é o
servidor (`resolveAuthorship` em `exam/application/update-exam.ts`), não o cliente: questão `ai`
editada vira `ai_edited`, e um rótulo humano nunca volta a `ai`. Questão antiga sem o campo fica
com autoria desconhecida. É o peso da autoria no "Meu estilo" (abaixo).

## Tipo de atividade (`activityType`)
`"exam" | "mockExam" | "quiz" | "exerciseList"` — prova, simulado, quiz e lista de exercícios. Default
`exam`.

## Dificuldade
No exam: `"fácil" | "médio" | "difícil"`.
Na geração também existe `"misto"` (a IA varia a dificuldade ao longo da prova).

## Estilos de geração (ExamStyle)
`"simple" | "contextual" | "analytical" | "reflective"`

- **simple** — direto ao ponto.
- **contextual** — questão com contexto/estória.
- **analytical** — exige análise crítica.
- **reflective** — exige reflexão.

O estilo **afeta o preço por questão** (objetivas): simple custa menos, reflective/contextual mais.
Tabela em [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).

## Meu estilo, instrução e prova-modelo
Três jeitos de o professor puxar a geração para o jeito dele, além do estilo pronto:

- **Meu estilo** — perfil destilado das provas que ele mesmo escreveu ou editou nos últimos 12 meses
  (no máximo 20 provas / 200 questões, mínimo de 5 questões). Questão gerada pela IA e não editada
  não conta. Ligado na geração pela flag `useTeacherStyle`. Exige acesso de assinante (assinatura
  ativa, membro de instituição ou staff); destilar não cobra crédito.
- **Instrução** — texto livre ("foque em X, ignore Y") que vira um conjunto fechado de intenções
  (tópicos de foco, tópicos a excluir, ênfase, público, trecho). O professor confere antes de gerar.
  Não cobra crédito.
- **Prova-modelo** — prova antiga colada como **referência de forma** (tipo e tamanho de enunciado),
  nunca de conteúdo. Não fica salva.

Quando há conflito, vale nesta ordem: regras do produto → Meu estilo → instrução → estilo pronto.
Mecânica em [tecnico/ai-ops.md](../tecnico/ai-ops.md).

## Idiomas de geração (OutputLanguage)
`"pt-BR" | "en" | "es"` — a prova pode ser gerada em português, inglês ou espanhol.

## Fontes de conteúdo na geração
Além de PDF/DOCX/texto/YouTube, a geração aceita `libraryFileIds` — arquivos da **Biblioteca** já
extraídos, passados como fonte sem re-extração nem custo extra (ver [tecnico/biblioteca.md](../tecnico/biblioteca.md)).

## Como a IA gera vs. como o exam armazena
- Geração objetiva produz um tipo intermediário (`GeneratedQuestion`: enunciado, contexto, opções,
  resposta correta, explicação, dificuldade) que vira `Question` no exam.
- Geração aberta produz `GeneratedOpenQuestion` com **rubrica gerada** (critérios com níveis) +
  resposta de referência.
- Na **correção de aberta**, a IA **escolhe o `levelId` por critério** e justifica; **o código calcula
  o score** a partir dos níveis (ver [tecnico/ai-ops.md](../tecnico/ai-ops.md)). A IA não inventa nota numérica.

## Quantidade por geração
1–50 questões objetivas; 1–30 discursivas.

## Estilo e preço: a assimetria
O estilo afeta o preço **só nas objetivas** (simples 25 · analítica 42 · reflexiva 45 · contextual 45,
sobre uma base de 250). A **discursiva custa 60 por questão, fixo** — a config de geração aceita
`style`, mas ele não muda o preço. Ver [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).

## Recorte da fonte por faixa de páginas
Além de escolher o arquivo, o professor escolhe **de qual página a qual página** gerar — vale tanto
para anexo quanto para arquivo da Biblioteca. O texto é fatiado antes do prompt. Ver [tecnico/ai-ops.md](../tecnico/ai-ops.md).

## Pós-processamento (invisível ao professor)
- **Balanceamento de gabarito** — a posição da alternativa correta é redistribuída entre as questões,
  para o gabarito não concentrar numa letra.
- **Verificador de explicação (R2)** — passo opcional que confere resposta/explicação com um modelo
  próprio (`R2_VERIFIER_MODEL`). Gateado por `R2_VERIFY`, **desligado por default**.
- **Guarda de material** — fonte com menos de 150 caracteres úteis é recusada. É o que pega PDF
  escaneado sem camada de texto.
