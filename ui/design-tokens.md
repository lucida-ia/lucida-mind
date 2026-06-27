---
quando_usar: usar tokens CSS, aplicar theme switch (analytics/kintal), escolher primitivo shadcn
última_revisão: 2026-06
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
- **Semânticos (shadcn)**: `--color-background`, `--color-foreground`, `--color-muted`, `--color-border`,
  `--color-input`, `--color-ring`, `--color-primary`, `--color-accent`.
- **Tipografia**: `--font-sans` (Poppins), `--font-serif` (Instrument Serif), `--font-mono` (JetBrains Mono).
- **Radii**: `--radius-sm` 8px, `--radius` 12px, `--radius-lg` 20px, `--radius-xl` 28px,
  `--radius-2xl` 32px, `--radius-pill` 9999px.
- **Shadows**: `--shadow-soft`, `--shadow-pop`, `--shadow-focus`.

## Theme switches
Aplicados num wrapper de layout — os componentes shadcn herdam **sem** precisar de `variant`:
- **`.theme-analytics`** — remapeia os semânticos (`--color-primary`, `--color-ring`, shadows) para o
  **roxo** da instituição. É o que faz `/analytics/*` "virar roxo" automaticamente.
- **`.theme-kintal`** — remapeia para **grayscale** (backoffice interno, sem cor de produto): só neutros.

## Primitivos disponíveis (`components/ui/`)
Reutilize estes em vez de recriar: `button` (variantes primary/accent/outline/ghost/on-dark + sizes via
`cva`), `input`, `textarea`, `label`, `dialog`, `dropdown-menu`, `sheet`, `action-menu`,
`clickable-card`, `container`. Todos usam `cn()` (clsx + tailwind-merge) e `cva()` para variantes, com
os tokens da marca.
