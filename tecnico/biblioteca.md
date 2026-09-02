---
quando_usar: mexer na Biblioteca — upload de arquivos, presigned S3, extração de texto, fonte de geração
última_revisão: 2026-08-25
status: canônico
tags: [biblioteca]
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
`regenerate-*`, ao lado de PDF/DOCX/texto/YouTube (ver [tecnico/ai-ops.md](ai-ops.md)).

## Acesso
A `SubscriberAccessPolicy` **compartilhada** (`shared/access/subscriber-access-policy.ts`) libera para
**staff**, **membro de organização** ou **assinante ativo** — a mesma política do Calendário (ver
[tecnico/calendario.md](calendario.md)). No backend, o middleware `requireLibraryAccess` gateia os endpoints (acesso negado
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

> **Gotcha conhecido**: o bucket precisa de **CORS** liberado para o `WEB_ORIGIN`, porque o **PUT
> presigned** (e o download presigned) sai do browser direto para o bucket. Sem CORS, o upload falha.
>
> Isso **não** vale para a pré-visualização: existe um proxy same-origin,
> `GET /v1/library/files/:id/preview` (`StreamFilePreviewUseCase` + porta `getObjectStream`),
> justamente para o browser renderizar o PDF sem depender do CORS do bucket.

TTL dos presigned: **900s** para upload, **300s** para download.

No `confirmUpload` o `headObject` é **autoritativo** — tamanho e mime declarados pelo cliente não são
confiados; acima do teto, o objeto é deletado e o registro apagado.

Texto extraído vai **inline** até **256 KB** (`INLINE_TEXT_MAX_BYTES`); acima disso vai para um objeto
companion (`storageKey.companionTextKey`).

Códigos de erro do domínio: `LIBRARY_FILE_NOT_READY` 409, `LIBRARY_UPLOAD_INCOMPLETE` 409,
`LIBRARY_FILE_TOO_LARGE` 400, `LIBRARY_STORAGE_NOT_CONFIGURED` 503, `LIBRARY_ACCESS_DENIED` 402.

## Faixa de páginas
O `LibraryFile` guarda **`pageTextSegments`** (`{ pageNumber, start, end }[]`) — os offsets de cada
página dentro do texto extraído. É o que permite ao professor escolher **um intervalo de páginas** do
arquivo na hora de gerar: `ResolveLibrarySourcesUseCase` devolve as `pages` reconstruídas dos offsets
e o `ai-ops` fatia antes do prompt. Ver [tecnico/ai-ops.md](ai-ops.md).

Outros campos do `LibraryFile` além dos citados acima: `originalFilename`, `mimeType`, `sizeBytes`,
`checksum`, `extractionError`, `extractionDurationMs`.

## Pontas soltas
- **Scripts**: `seed:library-subjects` (disciplinas) e `backfill:page-segments` (offsets de página
  em arquivos antigos).
- **UI**: `/app/biblioteca` → `features/app/biblioteca/` (`library-view`, `library-file-card`,
  `library-picker-dialog`, `library-filters`, `library-upsell`, `upload-dialog`, `upload-client`,
  `edit-file-dialog`, `delete-file-dialog`, `subject-combobox`, `status-badge`).
- **Wiring**: `apps/api/src/main.ts` — storage e `LibrarySourceResolverAdapter` no bloco da
  biblioteca, router via `makeLibraryRouter`. Custo de crédito por operação em
  [tecnico/billing-ledger.md](billing-ledger.md).
