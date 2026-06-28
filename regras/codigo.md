---
quando_usar: revisar ou escrever código — regras invioláveis e checklist que os reviewers aplicam
última_revisão: 2026-06-27
status: canônico
---

# Regras de código (invioláveis)

Sintetiza o que os agents `backend-reviewer` e `frontend-reviewer` cobram. Detalhe arquitetural em
tecnico/arquitetura.md e ui/modelo-de-ui.md; convenções gerais em tecnico/convencoes-de-codigo.md.

## Transversais (api + web)
- **Idioma**: todo identificador/arquivo/schema em **inglês**. Só copy de UI/marketing em pt-BR.
- **Comentários**: só o porquê não-óbvio, em inglês. Sem redundância, sem código comentado, sem pt-BR.
- **Naming**: arquivos `kebab-case`, classes `PascalCase`, vars `camelCase`, sem prefixo `I`.
- **Sem `any`**; funções pequenas; early return; sem abstração prematura.

## Backend (checklist do backend-reviewer)
- **Direção de dependência**: `presentation → application → domain ← infrastructure`. Import atravessando
  no sentido errado = erro.
- **Domínio puro**: nada de lib externa em `domain/` (sem Mongoose/Zod/Express; só `node:crypto`).
- **Zod para validar input só em `presentation/`** (em application/domain = mover). Zod para **parsing de
  resposta de API externa** (OpenAI, AbacatePay, NFE.io, Resend) é aceitável em `infrastructure/`.
- **Erros via `DomainError`** com `statusCode`. Nunca `new Error(...)` para regra de negócio.
- **Use case = uma operação** (`execute`). Mais de um método público → provavelmente 2 use cases.
- **Repositório nunca retorna `Document` cru** — falta mapper.
- **Wiring no composition root** (`main.ts` ou `<feature>.module.ts`) — feature não wired não existe.
- **Sem `req`/`res` fora de `presentation/`**.
- Imports ESM com `.js`.

## Frontend (checklist do frontend-reviewer)
- **`"use client"` só quando necessário**; nada de `useState` em server component.
- **shadcn-first**: reutilizar primitivos de `components/ui/`; não recriar botão/input/dialog.
- **Hex nunca hardcoded** — usar tokens (`bg-brand-primary`). Paleta certa por frente (professor azul,
  instituição roxo).
- **Arquivo de componente ≤ ~200 linhas**, uma responsabilidade; `page.tsx` é orquestrador fino.
- **Mutations via Server Action**; **forms** com react-hook-form + Zod (sem `useState` por campo).
- Fetch via server component ou TanStack Query, nunca `useEffect`.
- `next/font` e `next/image`; sem `z-index` mágico.
- **A11y**: HTML semântico, labels, foco visível, contraste WCAG AA.

## Como os reviewers respondem
Read-only. Devolvem veredito (`✅ aprovado / ⚠️ com ressalvas / ❌ reprovado`) com bloqueantes e
ressalvas em `file:line`. **Não corrigem** — apontam. Acione o reviewer da área ao concluir a tarefa.
