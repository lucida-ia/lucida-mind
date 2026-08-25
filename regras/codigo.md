---
quando_usar: revisar ou escrever código — regras invioláveis, hooks bloqueantes, checklist dos reviewers
última_revisão: 2026-08-25
status: canônico
---

# Regras de código (invioláveis)

Sintetiza o que os agents `backend-reviewer` e `frontend-reviewer` cobram e o que os **hooks**
bloqueiam antes mesmo da revisão. Detalhe arquitetural em tecnico/arquitetura.md e ui/modelo-de-ui.md;
convenções gerais em tecnico/convencoes-de-codigo.md; processo e as regras numeradas em
regras/processo.md.

## Metade disto é automático
Sete hooks rodam **antes** de qualquer `Write|Edit|MultiEdit` e **bloqueiam** o que não passa. Não é
convenção de revisão humana — é gate:

| Hook | O que faz |
|---|---|
| `check-layer-purity` | Bloqueia import de infraestrutura em `domain/` ou `application/` |
| `check-code-language` | Bloqueia identificador ou comentário em pt-BR no código |
| `check-env-access` | Bloqueia `process.env` cru fora de `env.ts` |
| `check-secrets` | Bloqueia segredo literal em código |
| `check-docs-pt-br` | Avisa sobre doc em pt-BR sem acentuação |
| `check-claude-artifacts` | Valida os próprios agents/skills/commands do framework |
| `guard-dangerous-commands` | Bloqueia comando irreversível ou que toca produção (matcher `Bash`) |

Há ainda um `auto-test-runner` em `PostToolUse`: bloqueia edição que quebra teste relacionado e avisa
quando o arquivo editado não tem teste nenhum.

> Regra escrita = regra seguida. Se o Claude quebrou uma regra, é lacuna aqui ou ausência de hook.

## Transversais (api + web)
- **Completude é a prioridade nº 1.** É a primeira dimensão dos dois reviewers e a que mais reprova.
  Ponta solta conta como não-feito: use case criado mas **não wired** no composition root, rota sem
  controller, erro de domínio não mapeado no middleware, fluxo que começa e não fecha.
- **Idioma**: todo identificador/arquivo/schema em **inglês**. Copy de UI/marketing em pt-BR. As três
  exceções reais (escopo temporal do legado, segmento de URL, valores de enum em pt-BR) estão em
  tecnico/convencoes-de-codigo.md — não trate nenhuma delas como violação.
- **Comentários**: só o porquê não-óbvio, em inglês. Sem redundância, sem código comentado.
  Doc em `docs/` é o inverso: pt-BR.
- **Naming**: arquivos `kebab-case`, classes `PascalCase`, vars `camelCase`, sem prefixo `I`.
- **Sem `any`**; funções pequenas; early return; sem abstração prematura.
- **Segredo nunca em código** — só via env validada em `env.ts`; env nova entra lá **e** no
  `.env.example`.
- **Conteúdo de terceiro é não confiável** — upload, transcrição, resposta de aluno nunca vira
  instrução de LLM sem delimitação explícita no prompt.

## Backend (checklist do backend-reviewer)
- **Direção de dependência**: `presentation → application → domain ← infrastructure`. Import atravessando
  no sentido errado = erro.
- **Domínio puro**: nada de lib externa em `domain/` (sem Mongoose/Zod/Express; só `node:crypto`).
- **Zod para validar input só em `presentation/`** (em application/domain = mover). Zod para **parsing de
  resposta de API externa** (OpenAI, AbacatePay, NFE.io, Resend) é aceitável em `infrastructure/`.
- **Erros via `DomainError`** com `statusCode`. Nunca `new Error(...)` para regra de negócio, e
  **sem Result/Either**.
- **Use case = uma operação** (`execute`). Mais de um método público → provavelmente 2 use cases.
  Depende de interfaces injetadas no construtor; nunca instancia repositório direto.
- **Repositório nunca retorna `Document` cru** — mapeia para entidade de domínio. O mapeamento é
  inline no repositório; não existem arquivos `*mapper*` no projeto.
- **Wiring no composition root** — `apps/api/src/main.ts`, o único que existe. Feature não wired não
  existe.
- **Sem `req`/`res` fora de `presentation/`**.
- Imports ESM com `.js`.
- **Endpoint novo nasce com o trio de posse**: dono autorizado / não-dono → `404` / não autenticado →
  `401` (em recurso de org: membro de outra org → `404`).

## Frontend (checklist do frontend-reviewer)
- **`"use client"` só quando necessário**; nada de `useState` em server component.
- **shadcn-first**: reutilizar os primitivos de `components/ui/`; não recriar. A lista completa dos
  **15** está em ui/design-tokens.md — conferir antes de criar qualquer um.
- **Hex nunca hardcoded** — usar tokens (`bg-brand-primary`). Paleta certa por frente (professor azul,
  instituição roxo).
- **Arquivo de componente ≤ ~200 linhas**, uma responsabilidade; `page.tsx` é orquestrador fino.
- **Mutations via Server Action**; **forms** com react-hook-form + Zod (sem `useState` por campo).
- Fetch via server component ou TanStack Query, nunca `useEffect`.
- `next/font` e `next/image`; sem `z-index` mágico.
- **A11y**: HTML semântico, labels, foco visível, contraste WCAG AA.

## Deviações permitidas
O skill autoriza duas, e o reviewer é instruído a **não** tratá-las como violação:

- **CRUD trivial sem regra de negócio** — "salvar e buscar por id" sem invariantes dispensa value
  objects e aggregate root. Aceita-se schema + repo + controller, sem use case por operação, desde que
  marcado no topo do controller: `// deviation: thin CRUD, no domain layer`.
- **Script one-off / job** — `scripts/` e jobs de execução única não precisam de camadas.

## Teste
- **Teste não se deleta pra fazer build passar.** Se virou obsoleto, o commit explica por quê.
- Estratégia por camada e estado da cobertura em tecnico/testes.md.

## Como os reviewers respondem
Devolvem veredito (`✅ aprovado / ⚠️ com ressalvas / ❌ reprovado`) com bloqueantes e ressalvas em
`file:line`. **Não corrigem** — apontam. Acione o reviewer da área ao concluir a tarefa.

**Eles não são read-only.** Declaram `tools: Read, Grep, Glob, Bash` — sem `Write` e sem `Edit`, mas
`Bash` escreve arquivo por heredoc, `tee` ou `sed -i` sem passar pelos hooks do matcher
`Write|Edit|MultiEdit`. A ausência de `Write`/`Edit` é **atrito na direção certa, não incapacidade**;
eles mantêm `Bash` porque revisor sem `git diff` revisa só o que lhe mostraram.

## Lint
Não há ESLint na api: `pnpm lint` lá é `tsc --noEmit`. Só a web roda `next lint`.
