---
quando_usar: nomear arquivo/variável, decidir idioma do código, escrever comentário, import ESM, clean code
última_revisão: 2026-06
status: canônico
---

# Convenções de código (api + web)

Valem em todo TypeScript/TSX, independente de camada ou framework. Fonte: skill
`lucida-code-conventions`.

## Idioma do código: tudo em inglês
Identificadores, funções, classes, tipos, rotas/handlers, schemas Zod **e suas chaves**, nomes de
arquivo — **sempre inglês**. A **única** exceção é a **copy de UI que o usuário lê/toca** (labels,
botões, mensagens, placeholders) e o conteúdo de marketing, em **pt-BR**. Segmento de URL visível
(`/app/turmas`) pode ficar em pt-BR, mas o **código que o serve, não**.

## Comentários
Só o **porquê não-óbvio**, em **inglês** (decisão, armadilha, invariante, segurança). Sem comentário
redundante, sem código comentado, sem comentário em pt-BR no código. Comentário separando "seções" de
uma função é sinal de que faltam funções.

## Naming
- Arquivos: `kebab-case` (`create-exam.use-case.ts`, `exam-detail.tsx`).
- Classes / tipos / componentes: `PascalCase` (`CreateExamUseCase`, `Button`).
- Variáveis / funções / props / hooks: `camelCase` (`handleSubmit`, `useExamStore`).
- Stores Zustand: `useCamelCaseStore`.
- **Sem prefixo `I`** em interface — `ExamRepository` é a interface, `MongooseExamRepository` a impl.

## Imports ESM (api)
ESM puro: imports **com extensão `.js`** mesmo apontando para `.ts` (`import { x } from './bar.js'`).

## Clean code
- **Early return** para guard clauses; sem pirâmide de `if`.
- Funções **pequenas e focadas** — uma responsabilidade.
- Nomes revelam intenção; sem abreviação obscura (`data2`, `tmp`, `x`).
- **Sem abstração prematura** — abstrai na terceira ocorrência, não antes.
- **Sem `any`** — prefira `unknown` + narrowing, ou tipe direito.

> As regras invioláveis e o checklist de revisão (que os reviewers aplicam) estão em regras/codigo.md.
> Arquitetura específica do backend em tecnico/arquitetura.md; do frontend em ui/modelo-de-ui.md.
