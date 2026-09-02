---
quando_usar: definir tipos de questão, estilos de geração, dificuldade, idiomas suportados
última_revisão: 2026-08-25
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

- **multipleChoice** — 2 a 6 opções, exatamente 1 correta. Sem rubrica.
- **trueFalse** — exatamente 2 opções. Sem rubrica.
- **open** (aberta/discursiva) — sem opções e sem gabarito; **exige `rubric`** e pode ter
  `referenceAnswer`. A pontuação vem da rubrica, não de gabarito.

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
