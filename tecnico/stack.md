---
quando_usar: saber versões, libs, gerenciador, comandos, layout do monorepo, subir local
última_revisão: 2026-08-25
status: canônico
---

# Stack e layout

## Monorepo
Gerenciador **pnpm** (9.12.0). **Node** ≥ 20.11.

```
lucida-monorepo/
├── apps/                     ← workspace pnpm
│   ├── api/   ← @lucida/api — backend Express 5 (Clean Arch + DDD por feature)
│   └── web/   ← @lucida/web — frontend Next.js 15
├── packages/                 ← workspace pnpm
│   └── omr-template/  ← @lucida/omr-template — geometry.json/markers.json (api ↔ serviço OMR)
├── services/                 ← NÃO é workspace pnpm
│   ├── omr/                  ← leitura de folha de resposta (OpenCV)
│   └── youtube-transcript/   ← transcrição de vídeo
├── e2e/                      ← specs Playwright
└── docker/                   ← api.Dockerfile, web.Dockerfile
```

`pnpm-workspace.yaml` declara apenas `apps/*` e `packages/*`. Os **serviços Python não são
workspace** — têm venv próprio (`services/omr/.venv`, reusado pelo youtube-transcript) e os scripts
da raiz entram neles com `cd`.

`packages/` hoje contém só `omr-template` (geometria/marcadores ArUco compartilhados entre a api e o
serviço Python de OMR), consumido via `workspace:*`.

Path alias `@/*` → `src/*` nos dois apps. Só a api usa `module/moduleResolution: NodeNext` — é por
isso que os imports dela levam extensão `.js`; a base e a web usam `Bundler`.

## Backend (`apps/api`)
Express 5 + TypeScript **ESM puro**. Principais libs:
`express` 5, `mongoose` 8, `mongodb` 7, `better-auth` 1.6, `zod` 3, `openai` 6, `stripe` 22,
`resend` 4, `posthog-node` 5, `multer` 2, `pdf-parse` 2, `mammoth`, `docx`, `pdf-lib`, `qrcode`,
`youtube-transcript`, `cors`, `dotenv`, e `@aws-sdk/client-s3` + `@aws-sdk/s3-request-presigner`
(storage S3/Railway Buckets da Biblioteca — ver tecnico/biblioteca.md).

Dev/teste: `tsx` (watch, porta 3333), `tsc-alias`, `vitest` 2.1 com **duas configs** (unit e
integração), `supertest`, `mongodb-memory-server`, `@vitest/coverage-v8`. A suíte é grande e
madura — ver tecnico/testes.md.

## Frontend (`apps/web`)
Next.js 15 (App Router) + React 19 + TypeScript + **Tailwind v4** + shadcn/ui. Principais libs:
`next` 15, `react` 19, `zod`, `react-hook-form` + `@hookform/resolvers`, `@tanstack/react-query` 5,
`zustand` 5, `recharts` 3, `motion` (Framer) 12, `posthog-js`, `date-fns` 4, `lucide-react`,
`radix-ui` + primitivos `@radix-ui/react-*`, `class-variance-authority`, `clsx`, `tailwind-merge`,
`@dnd-kit/*` (kanban), `react-day-picker`, `qrcode.react`, `mammoth`, mais Shiki/KaTeX/pdfjs-dist
nos docs e nas provas.

Tipografia via `next/font` (Poppins + Instrument Serif + JetBrains Mono).
Teste: `vitest` + `@testing-library/react`, `happy-dom`.

Não existe `tailwind.config.*` — Tailwind v4 configura por CSS. Lint: `next lint` só na web; na api
`lint` é `tsc --noEmit` (não há ESLint lá).

## Serviços Python
FastAPI, chamados por HTTP com shared-secret, deploy isolado (Railway). Ver tecnico/integracoes.md.

- **omr** — OpenCV, leitura de folha de resposta.
- **youtube-transcript** — dois tiers: primeiro tenta legenda via `yt-dlp`; se não houver, baixa o
  áudio e chama a **API de transcrição da OpenAI**. Não há Whisper local (nada de `torch` no
  `requirements.txt`).

## Comandos (da raiz do monorepo)
| Comando | O que faz |
|---|---|
| `pnpm install` | Instala em todos os workspaces |
| `pnpm dev` | Sobe api + web em paralelo |
| `pnpm dev:api` / `pnpm dev:web` | Só backend (3333) / só frontend (3000) |
| `pnpm build` / `pnpm start` | Build / start recursivo |
| `pnpm lint` | api: `tsc --noEmit`; web: `next lint` |
| `pnpm typecheck` | `tsc --noEmit` em todos |
| `pnpm test` | Testes dos workspaces JS/TS |
| `pnpm test:services` | pytest dos dois serviços Python |
| `pnpm docker:up` / `docker:down` / `docker:reset` / `docker:logs` | Ambiente integrado via compose |
| `pnpm e2e` / `pnpm e2e:ui` | Playwright |
| `pnpm --filter @lucida/api <script>` | Roda script só na api |

## Subir local
Duas formas:

**1. Direto** — Mongo **com replica set** (transações de billing) e `.env` copiado dos
`.env.example`, depois `pnpm dev`. Detalhe das envs em tecnico/integracoes.md e em
`apps/api/src/env.ts`.

**2. Via Docker Compose** — `docker-compose.yml` sobe `mongo` (já com replica set), `api` e `web`.
É o caminho canônico para E2E, e o `playwright.config.ts` documenta o fluxo:

```
docker compose up -d --build
docker compose exec api pnpm run seed:e2e-teacher
pnpm e2e
```

`pnpm dev` **não** serve para o E2E. A api tem um `.env.test` versionado além do `.env.example`.
Não há workflow de CI em `.github/` — só templates de issue e de PR.

## Scripts de migração / seed / backfill (api)
Vivem em `apps/api/scripts/`, rodados via `pnpm --filter @lucida/api <script>`. São ~24. Por grupo:

- **migrate**: `legacy`, `legacy-rename`, `billing-scope`, `normalize-user-ids`,
  `disable-test-webhook-endpoints`, `remove-api-environment`
- **seed**: `test-org`, `roadmap`, `library-subjects`, `e2e-teacher`
- **backfill**: `student-org`, `class-org`, `courses`, `classroom-fields`, `exam-activity-type`,
  `submission-scores`, `math-latex`, `page-segments`
- **outros**: `diagnose:legacy-ids`, `billing:add-org-credits`, `eval:generation`

Há ainda utilitários `.mjs` soltos na mesma pasta (`promote-staff`, `reset-password`,
`inspect-accounts`, `export-user-exam-links`), rodados direto com `node`.
