---
quando_usar: usar tokens CSS, aplicar theme switch (analytics/kintal), escolher primitivo shadcn
última_revisão: 2026-08-25
status: canônico
---

# Design tokens e primitivos

Tokens vivem em `apps/web/src/styles/globals.css`, dentro de `@theme` do Tailwind v4. **Hex nunca é
hardcoded em componente** — use as classes utilitárias geradas dos tokens (`bg-brand-primary`,
`text-ink`, etc.). Valores de cor/marca em ui/identidade-visual.md.

## Tokens em `@theme`
- **Cores professor (azul)**: `--color-brand-primary #007aff`, `--color-brand-dark-01 #1d14ff`,
  `--color-brand-dark-02 #150bbc`, `--color-brand-light #7fbdf4`, `--color-brand-super-dark #051e2c`,
  `--color-brand-off-white #f9f5ea`.
- **Cores instituição (roxo)**: `--color-analytics-primary #6c3cfb`, `--color-analytics-dark-01 #4d30ce`,
  `--color-analytics-dark-02 #1e0a96`, `--color-analytics-light #927afc`.
- **Neutros**: `--color-gray-50` … `--color-gray-800`, `--color-ink #0a0a0a`.
- **Semânticos (shadcn)**: `--color-background`, `--color-foreground`, `--color-muted`,
  `--color-muted-foreground`, `--color-border`, `--color-input`, `--color-ring`, `--color-primary`,
  `--color-primary-foreground`, `--color-accent`, `--color-accent-foreground`.
- **Terceiros**: `--color-whatsapp #128c7e` (CTAs/integrações de WhatsApp).
- **Tipografia**: `--font-sans` (Poppins), `--font-serif` (Instrument Serif), `--font-mono` (JetBrains Mono).
- **Radii**: `--radius-sm` 8px, `--radius` 12px, `--radius-lg` 20px, `--radius-xl` 28px,
  `--radius-2xl` 32px, `--radius-pill` 9999px.
- **Shadows**: `--shadow-soft`, `--shadow-pop`, `--shadow-focus`.

## Theme switches
Aplicados num wrapper de layout — os componentes shadcn herdam **sem** precisar de `variant`:
Os dois trocam **exatamente quatro** vars semânticas — `--color-ring`, `--color-accent`,
`--color-accent-foreground` e `--shadow-focus` — mais `::selection` e `.pulse-dot`.

**`--color-primary` NÃO é remapeado** por nenhum dos dois: segue `#0a0a0a` em toda parte. E os tokens
de marca (`--color-brand-*`, `--color-analytics-*`) ficam intactos de propósito, para componentes
compartilhados que precisem da cor de produto continuarem funcionando.

- **`.theme-analytics`** — aponta as quatro para o **roxo** da instituição
  (`--color-analytics-primary`). É o que faz o que é "neutro" em `/analytics/*` herdar roxo.
- **`.theme-kintal`** — aponta as quatro para **grayscale** (`--color-gray-800`, `--color-ink`):
  backoffice interno, sem cor de produto.

Ou seja: um componente que usa `bg-primary` **não** muda de cor entre as frentes. Quem herda o tema é
o que usa ring, accent e foco.

## Classes utilitárias e print
Além dos tokens em `@theme`, `globals.css` define utilitários reusáveis (não recriar):
- **`.surface-dark`** — fundo super-dark com texto off-white (superfícies de alto contraste).
- **`.safe-top` / `.safe-bottom`** — padding de safe-area (notch/barra) para PWA/mobile.
- **`.pulse-dot`** — dot pulsante de status (tem variantes por tema: analytics, kintal).
- **`.scrollbar-thin`** — scrollbar fina custom para áreas roláveis.
- **Print**: `@page` (A4, margem 20mm) + `@media print` e classes `.print-toolbar`/`.print-page`/
  `.page-break` — base das rotas `/print/exams/[id]` e `/print/lesson-plans/[id]` (fluxo oficial de
  export é Ctrl+P → salvar PDF).

## Primitivos disponíveis (`components/ui/`)
São **15**. Reutilize em vez de recriar — recriar um destes é violação da regra shadcn-first
(regras/codigo.md). Confira esta lista **antes** de criar qualquer primitivo:

| | | |
|---|---|---|
| `action-menu` | `dialog` | `popover` |
| `button` | `dropdown-menu` | `select` |
| `calendar` | `input` | `sheet` |
| `clickable-card` | `label` | `switch` |
| `container` | `date-time-picker` | `textarea` |

O `button` tem variantes primary (default) / accent / outline / ghost / on-dark e sizes
`sm | md | lg | xl` (default `md`). Todos usam `cn()` (clsx + tailwind-merge) e `cva()` para variantes,
com os tokens da marca.

## Configuração
`components.json`: style `new-york`, baseColor `neutral`, `iconLibrary: lucide`, e
`tailwind.config: ""` — **não existe `tailwind.config.*`** no repositório. Tailwind v4 configura por
CSS, dentro do `@theme` do `globals.css`.

Além dos tokens, `globals.css` importa `tw-animate-css` e `katex/dist/katex.min.css`, e aplica
`letter-spacing: -0.01em` no `body` via `@layer base`.
