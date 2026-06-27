---
quando_usar: saber versões, libs, gerenciador, comandos, layout do monorepo
última_revisão: 2026-06
status: canônico
---

# Stack e layout

## Monorepo
Gerenciador **pnpm** (≥ 9.12). **Node** ≥ 20.11. Workspaces:

```
lucida-monorepo/
├── apps/
│   ├── api/   ← @lucida/api — backend Express 5 (Clean Arch + DDD por feature)
│   └── web/   ← @lucida/web — frontend Next.js 15
├── services/  ← microsserviços Python (FastAPI), deploy isolado
│   ├── omr/                  ← leitura de folha de resposta (OpenCV)
│   └── youtube-transcript/   ← transcrição de vídeo (yt-dlp + Whisper)
└── packages/  ← reservado (placeholder p/ código compartilhado; ainda não existe no disco)
```

Path alias `@/*` → `src/*` nos dois apps (no api é resolvido em build por `tsc-alias`).

## Backend (`apps/api`)
Express 5 + TypeScript **ESM puro**. Principais libs:
`express` 5, `mongoose` 8, `better-auth`, `zod` 3, `openai`, `stripe`, `resend`, `mongodb`,
`multer`, `pdf-parse`, `mammoth`, `docx`, `qrcode`, `youtube-transcript`, `posthog-node`, `cors`.
Dev: `tsx` (watch, porta 3333), `tsc-alias`, `vitest` (configurado, sem testes escritos ainda).

## Frontend (`apps/web`)
Next.js 15 (App Router) + React 19 + TypeScript + **Tailwind v4** + shadcn/ui. Principais libs:
`next` 15, `react` 19, `tailwindcss` 4, `zod`, `react-hook-form`, `@tanstack/react-query`,
`zustand`, `recharts`, `motion` (Framer), `posthog-js`, mais Shiki/KaTeX/pdfjs-dist nos docs/provas.
Tipografia via `next/font` (Poppins + Instrument Serif + JetBrains Mono).

## Serviços Python
FastAPI, chamados por HTTP com shared-secret, deploy isolado (Railway). Ver tecnico/integracoes.md.

## Comandos (da raiz do monorepo)
| Comando | O que faz |
|---|---|
| `pnpm install` | Instala em todos os workspaces |
| `pnpm dev` | Sobe api + web em paralelo |
| `pnpm dev:api` / `pnpm dev:web` | Só backend (3333) / só frontend (3000) |
| `pnpm build` | Build recursivo (api: tsc + tsc-alias; web: next build) |
| `pnpm start` | Start recursivo |
| `pnpm lint` | api: `tsc --noEmit`; web: `next lint` |
| `pnpm typecheck` | `tsc --noEmit` em todos |
| `pnpm --filter @lucida/api <script>` | Roda script só na api (ex.: migrações em `apps/api/scripts/`) |

Para subir local: Mongo **com replica set** (transações de billing) e `.env` copiado dos `.env.example`.
Detalhe das envs em tecnico/integracoes.md e em `apps/api/src/env.ts`.
