---
quando_usar: nomear arquivo/variável, decidir idioma do código, escrever comentário, import ESM, clean code
última_revisão: 2026-08-25
status: canônico
---

# Convenções de código (api + web)

Valem em todo TypeScript/TSX, independente de camada ou framework. Fonte: skill
`lucida-code-conventions` + a seção "Convenções" do `CLAUDE.md` do monorepo.

## Idioma do código: tudo em inglês
Identificadores, funções, classes, tipos, rotas/handlers, schemas Zod **e suas chaves**, nomes de
arquivo — **sempre inglês**. Em pt-BR só a **copy de UI que o usuário lê/toca** (labels, botões,
mensagens, placeholders) e o conteúdo de marketing. O hook `check-code-language` bloqueia
identificador e comentário em pt-BR.

Três exceções reais, e é importante conhecê-las porque sem elas a regra fica falsa contra o código:

1. **Escopo temporal.** A regra vale para **código novo e edições daqui pra frente**. Não sair
   renomeando o legado em pt-BR (`AlunoDTO`, `turma`, `matricula`); ao tocar num arquivo, prefira
   inglês para o que você **adicionar** e não introduza nome novo em pt-BR.
2. **Segmento de URL do App Router** visível ao usuário pode ficar em pt-BR (`/app/turmas`,
   `/app/provas`) — mas o código que o serve, não.
3. **Valores de enum canônicos em pt-BR** existem no domínio e são intencionais:
   `QuestionDifficulty = "fácil" | "médio" | "difícil"` e os escopos/cortes do cubo de analytics
   (`instituicao`, `turma`, `questao`, `criterio_rubrica`…). São valores, não identificadores.

Herança viva do legado, que o hook não pega e não se renomeia sem pedido: `matricula` como campo de
domínio e chave Zod, `turmaId`/`turma`/`aluno` em componentes, e as pastas de feature do front em
pt-BR (`features/app/turmas/`, `provas/`, `cursos/`, `aulas/`, `biblioteca/`, `calendario/`,
`analises/`, `integracoes/`).

## Comentários
Só o **porquê não-óbvio**, em **inglês** (decisão, armadilha, invariante, segurança). Sem comentário
redundante, sem código comentado. Comentário separando "seções" de uma função é sinal de que faltam
funções. Documentação em `docs/` é o inverso: **pt-BR**, com hook próprio (`check-docs-pt-br`).

## Naming
- Arquivos: `kebab-case` (`create-exam.ts`, `exam-detail.tsx`). **Sem** sufixo `.use-case` / `.dto` —
  ver o layout plano em tecnico/arquitetura.md.
- Classes / tipos / componentes: `PascalCase` (`CreateExamUseCase`, `Button`).
- Variáveis / funções / props / hooks: `camelCase` (`handleSubmit`, `useExamStore`).
- Stores Zustand: `useCamelCaseStore` (hoje só três: `useWizardStore`, `useLessonWizardStore`,
  `useTourStore`).
- **Sem prefixo `I`** em interface — `ExamRepository` é a interface, `MongooseExamRepository` a impl.
- Implementação de repositório leva o prefixo da tecnologia: `Mongoose*` na maioria, `Mongo*` em
  alguns (`MongoUserPreferencesRepository`). Os dois prefixos convivem.
- Router é uma factory `make<Feature>Router` (`makeExamRouter`, `makeKintalRouter`).
- Schemas Zod de presentation ficam em `<feature>-schemas.ts`.
- Controller recebe um objeto **`Deps` nomeado** (`new CourseController({ createCourse: … })`) — é o
  que torna `presentation` testável como unit.
- Teste **co-localizado**: `create-exam.test.ts` ao lado de `create-exam.ts`.

## Imports ESM (api)
ESM puro: imports **com extensão `.js`** mesmo apontando para `.ts` (`import { x } from './bar.js'`).
Só a api exige isso — é ela que usa `moduleResolution: NodeNext`; a web usa `Bundler`.

## Frontend
- **Arquivos enxutos.** Componente acima de ~200 linhas ou com mais de uma responsabilidade deve ser
  decomposto.
- Sempre reutilizar os primitivos de `apps/web/src/components/ui/` (shadcn), customizados com os
  tokens da marca, em vez de recriar do zero. A lista completa está em ui/design-tokens.md.

## Clean code
- **Early return** para guard clauses; sem pirâmide de `if`.
- Funções **pequenas e focadas** — uma responsabilidade.
- Nomes revelam intenção; sem abreviação obscura (`data2`, `tmp`, `x`).
- **Sem abstração prematura** — abstrai na terceira ocorrência, não antes.
- **Sem `any`** — prefira `unknown` + narrowing, ou tipe direito. A web está limpa (zero `any`); na
  api sobrevivem ~9 ocorrências fora de teste.

## Commits
Mensagens em **inglês**, imperativo curto.

> As regras invioláveis e o checklist de revisão (que os reviewers aplicam) estão em regras/codigo.md.
> Arquitetura específica do backend em tecnico/arquitetura.md; do frontend em ui/modelo-de-ui.md.
