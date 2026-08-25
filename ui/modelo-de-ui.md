---
quando_usar: criar tela/componente/form, decidir Server vs Client, Server Action, estado, shadcn-first
última_revisão: 2026-08-25
status: canônico
---

# Modelo de UI (Next.js 15 + React 19)

Fonte: skill `lucida-frontend`. Identidade visual em ui/identidade-visual.md; tokens em ui/design-tokens.md.

## Server Components por padrão
`"use client"` **só quando** precisa de estado, eventos, refs, Context ou API de browser — nunca "por
via das dúvidas". Fetch inicial em server component com `await` (sem TanStack Query).

## Dados
- **Server Component + `await`** para o fetch inicial sem interação.
- **TanStack Query** só quando precisa de cache/revalidation/polling no client.
- Nunca fazer fetch em `useEffect` quando dá para ser server component.

## Mutations
**Server Actions** para mutation de dados disparada do client (submit de form, botão). O schema **Zod
revalida no servidor** (fonte da verdade). Exceção aceitável: **fluxos de auth client-side** do BetterAuth
(`authClient.signIn`/`signUp`/etc.) chamam o client direto, não via Server Action.

## Forms
**react-hook-form + Zod + Server Action**. Schema Zod num `schemas.ts` (tipado, fonte da verdade);
react-hook-form gerencia estado/validação no client; mensagens exibidas em **pt-BR**, schema/tipos em
inglês. Não usar `useState` por campo.

## Estado (hierarquia de decisão)
1. Derivável de outro estado? → derive no render (não é estado).
2. De um único componente? → `useState` local.
3. Passa a 1–2 filhos? → `useState` no pai + props.
4. Dado do servidor? → server component ou TanStack Query.
5. Deve sobreviver a reload / ser compartilhável? → **URL** (`useSearchParams`, path).
6. UI compartilhada entre componentes distantes? → **Zustand**.
7. Config imutável de sessão (tema, locale, usuário)? → **Context**.

## Componentização
- Alvo **≤ ~200 linhas** por arquivo de componente — é **heurística**, não regra dura. O problema é
  **UI/lógica inline monolítica**, não o total de linhas: um **orquestrador** (page/feature) que delega a
  sub-componentes pode passar de 200 sem ser red flag.
- `page.tsx` e features grandes são **orquestradores finos**.
- **shadcn-first**: sempre reutilizar primitivos de `components/ui/` (Button, Input, Dialog, Sheet…) em
  vez de recriar. Recriar do zero é violação. Ver ui/design-tokens.md.

## Estrutura
```
src/
  app/         ← rotas, layouts, page.tsx, actions
  features/<feature>/   ← componentes, actions, schemas, hooks da feature
  components/ui/         ← shadcn customizado com tokens da marca
  components/layout/     ← Header, Footer, Sidebar
  lib/         ← cn(), utilitários puros
  hooks/  stores/  server/  styles/
```

## Anti-patterns (red flags de review)
`useState` em server component · `"use client"` em componente que só renderiza JSX estático · **cor de
marca** (azul/roxo) hardcoded fora de `globals.css` (exceto cor de **terceiro** — Google `#4285F4`,
WhatsApp — e cores de **data-viz/Recharts** determinadas por algoritmo) · fetch em `useEffect` que podia
ser server component · `page.tsx` com **lógica de UI inline** e 200+ linhas (orquestrador que delega é ok)
· recriar botão/input/dialog que já existe em `ui/` · `variant` virando `if` gigante (use `cva()`) ·
fonte web sem `next/font` · imagem sem `next/image` · form com `useState` por campo · `z-[9999]` mágico.

## Idioma na UI — a exceção que confunde
Schema, tipos, props e nomes de arquivo em **inglês**; copy em **pt-BR**. A exceção oficial: o
**segmento de URL do App Router** visível ao usuário pode ser pt-BR — e na prática **todas** as rotas
do app são (`/app/turmas`, `/app/provas`, `/app/biblioteca`). O que serve a rota, não. Detalhe em
tecnico/convencoes-de-codigo.md.

## Hex fora de `globals.css` — os casos legítimos
Além de cor de terceiro e de data-viz determinada por algoritmo:
- O padrão real nos gráficos é `var(--color-x, #hex)` — token **com fallback**, não hex puro.
- `errorColor` do KaTeX em `rich-text.tsx` é hex puro e é legítimo: é config de biblioteca.

## PWA
O app é instalável: `manifest.ts`, ícones (192/512/maskable/apple), `viewportFit: "cover"` no layout
e um `service-worker-registrar` em `components/pwa/`. Há utilitários `.safe-top`/`.safe-bottom` para
a safe-area — ver ui/design-tokens.md. `providers.tsx` fica na raiz de `app/`.
