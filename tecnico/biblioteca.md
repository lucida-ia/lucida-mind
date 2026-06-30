---
quando_usar: mexer na Biblioteca — upload de arquivos, presigned S3, extração de texto, fonte de geração
última_revisão: 2026-06-30
status: canônico
---

# Biblioteca — arquivos do professor como fonte de conteúdo

Domínio `library`. O professor sobe arquivos (PDF/DOCX/TXT) uma vez e os reutiliza como **fonte de
conteúdo** na geração de provas e planos de aula — sem re-upload e sem re-extração a cada uso. Binário
fica em **object storage** (S3 / Railway Buckets), nunca trafega pela API.

## Entidades
- **LibraryFile** — `status` (`UPLOADING` → `PROCESSING` → `READY` | `ERROR`), `fileType`
  (`pdf`/`docx`/`txt`), `ownerId`, `organizationId`, `storageKey`, `displayName`, `extractedText` (ou
  `extractedTextStorageKey` quando grande), `textPreview`, `wordCount`, `pageCount`, disciplina
  (`subjectId`/`subjectName`), `segment`, `tags`, `timesUsedInGeneration`, `lastUsedAt`.
- **LibrarySubject** — disciplina nomeada dentro de um **segmento**. Segmentos: `FUNDAMENTAL`, `MEDIO`,
  `FACULDADE`, `INFOPRODUTOR` (mesmos do lesson-plan).

## Fluxo de upload (browser → S3 direto)
1. `RequestUploadUrlUseCase` gera uma **presigned PUT** (limitada por `LIBRARY_UPLOAD_MAX_BYTES`); o
   browser sobe o binário **direto ao S3**, nunca via API.
2. `ConfirmUploadUseCase` marca `PROCESSING` e dispara a extração.
3. `ExtractFileTextUseCase` **reusa os extractors do ai-ops** (PDF/DOCX/text); salva o texto inline ou,
   se grande, num objeto S3 de overflow; grava `pageCount`/`wordCount`/checksum → `READY`.
4. Falha → `ERROR`; `RetryFileExtractionUseCase` reenfileira.

Outros use cases: `ListLibraryFilesUseCase`, `GetLibraryFileUseCase`, `GetFileDownloadUrlUseCase`
(presigned GET), `DeleteLibraryFileUseCase`, `UpdateLibraryFileMetadataUseCase` (disciplina/segmento/tags),
`ListLibrarySubjectsUseCase`, `GetOrCreateLibrarySubjectUseCase`.

## Consumo pelo ai-ops (extract-once)
Na geração, o professor passa `libraryFileIds`. O `ai-ops` resolve via a porta
`ai-ops/domain/library-source-resolver.ts` (impl. `LibrarySourceResolverAdapter`):
- `ResolveLibrarySourcesUseCase` → `ExtractionResult[]` com o **texto já extraído** — **sem re-extração
  e sem custo de crédito** pela reutilização (a extração ocorreu uma vez, no upload).
- `MarkLibraryFilesUsedUseCase` incrementa `timesUsedInGeneration`/`lastUsedAt` e emite evento de
  analytics **após** a geração concluir.

Entra em `generate-exam-questions`, `generate-open-questions`, `generate-lesson-plan` e
`regenerate-*`, ao lado de PDF/DOCX/texto/YouTube (ver tecnico/ai-ops.md).

## Acesso
A `SubscriberAccessPolicy` **compartilhada** (`shared/access/subscriber-access-policy.ts`) libera para
**staff**, **membro de organização** ou **assinante ativo** — a mesma política do Calendário (ver
tecnico/calendario.md). No backend, o middleware `requireLibraryAccess` gateia os endpoints (acesso negado
→ **402**); no web, `getCanAccessLibrary()` decide entre `<LibraryView />` e `<LibraryUpsell />`.

## Storage (portas + adapters)
- Porta `library/domain/ports/file-storage.ts` (`FileStorage`): `createUploadUrl`/`createDownloadUrl`
  (presigned), `getObject`/`putObject`/`headObject`/`deleteObjects`.
- `S3FileStorage` — adapter S3-compatível (S3 ou **Railway Buckets**): usa `endpoint` +
  `forcePathStyle: true`. Libs: `@aws-sdk/client-s3`, `@aws-sdk/s3-request-presigner`.
- `UnavailableFileStorage` — stub que devolve **503** quando as envs não estão setadas (degradação
  graciosa; o resto da api segue).
- `PdfParsePageCounter` conta páginas (quota/métrica).

## Envs
| Env | Default | Nota |
|---|---|---|
| `LIBRARY_S3_ENDPOINT` | — | Railway Buckets ou S3 custom |
| `LIBRARY_S3_BUCKET` | — | nome do bucket |
| `LIBRARY_S3_REGION` | `us-east-1` | |
| `LIBRARY_S3_ACCESS_KEY_ID` | — | |
| `LIBRARY_S3_SECRET_ACCESS_KEY` | — | |
| `LIBRARY_UPLOAD_MAX_BYTES` | `52_428_800` (50 MB) | teto do presigned PUT |

Sem as `LIBRARY_S3_*` → `UnavailableFileStorage` injetado, endpoints da Biblioteca devolvem **503**,
resto da api segue.

> **Gotcha conhecido**: o bucket precisa de **CORS** liberado para o `WEB_ORIGIN` (upload/download
> presigned vêm do browser). Não há fallback de proxy pela API — sem CORS, o upload falha no browser.

## Pontas soltas
- **Seed** de disciplinas: `pnpm --filter @lucida/api run seed:library-subjects`.
- **UI**: `/app/biblioteca` → `features/app/biblioteca/` (`library-view`, `library-file-card`,
  `library-picker-dialog`, `library-filters`, `library-upsell`).
- **Wiring**: `apps/api/src/main.ts` (storage + `LibrarySourceResolverAdapter` ~659–696; router
  ~1456–1461). Custo de crédito por operação em tecnico/billing-ledger.md.
