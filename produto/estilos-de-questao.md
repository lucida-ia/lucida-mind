---
quando_usar: definir tipos de questão, estilos de geração, dificuldade, idiomas suportados
última_revisão: 2026-06-27
status: canônico
---

# Estilos de questão, dificuldade e idiomas

Fontes: `apps/api/src/domains/exam/domain/question.ts`,
`apps/api/src/domains/ai-ops/domain/generation-types.ts`,
`apps/api/src/domains/ai-ops/domain/open-generation-types.ts` (questões abertas).

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
Tabela em tecnico/billing-ledger.md.

## Idiomas de geração (OutputLanguage)
`"pt-BR" | "en" | "es"` — a prova pode ser gerada em português, inglês ou espanhol.

## Fontes de conteúdo na geração
Além de PDF/DOCX/texto/YouTube, a geração aceita `libraryFileIds` — arquivos da **Biblioteca** já
extraídos, passados como fonte sem re-extração nem custo extra (ver tecnico/biblioteca.md).

## Como a IA gera vs. como o exam armazena
- Geração objetiva produz um tipo intermediário (`GeneratedQuestion`: enunciado, contexto, opções,
  resposta correta, explicação, dificuldade) que vira `Question` no exam.
- Geração aberta produz `GeneratedOpenQuestion` com **rubrica gerada** (critérios com níveis) +
  resposta de referência.
- Na **correção de aberta**, a IA **escolhe o `levelId` por critério** e justifica; **o código calcula
  o score** a partir dos níveis (ver tecnico/ai-ops.md). A IA não inventa nota numérica.
