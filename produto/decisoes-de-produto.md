---
quando_usar: entender o porquê de uma decisão de produto (rebrand, analytics, OMR, Classroom, transcrição)
última_revisão: 2026-06
status: canônico
---

# Decisões de produto

Decisões com lente de produto (o *porquê*). Origem: memórias de projeto do `lucida-monorepo`.

## Rebrand "Lucida única"
Sem sub-marcas (Exam/Learning/Analytics descontinuadas). Uma marca, três frentes por **cor +
qualificador**; nomes técnicos seguem em inglês. Login unificado por frente **adiado**.
Detalhe em negocio/posicionamento.md.

## Analytics como "cubo" parametrizável
Motor de analytics **calculado on-read** (sem materialização — volume baixo justifica), parametrizado
por escopo + corte (breakdown) + filtros + período. **Discriminação de item** usa o **índice dos 27%**
(grupos superior/inferior; split na mediana quando N<10). **Habilidades BNCC por questão** ficaram no
**roadmap** (as questões ainda não carregam tag de habilidade). Endpoints legados continuam vivos; a
contração para o cubo é faseada. Front novo em `features/analytics-cube`.

## Rebuild do scanner OMR
Geometria única em `@lucida/omr-template` (`geometry.json`), **vendorizada** no serviço Python para
deploy isolado. **Preset fixo A4 50×5** (2 colunas). **Identidade por QR por aluno** (payload
`LUCIDA1|examId|studentId`). Pipeline próprio: 4 marcadores **ArUco** → correção de perspectiva → QR →
fill-ratio. O **PDF é gerado pelo servidor** (1 página por aluno); o **scoring vive na API**, não no
Python. Validado ponta a ponta.

## Serviço de transcrição do YouTube
Serviço Python (yt-dlp + Whisper) para extrair transcrição de vídeo e usar como fonte em provas/aulas.
yt-dlp **exige** `player_client=android` (caso contrário bloqueia). Preferência de idioma pt → es → en →
qualquer; legendas manuais antes de auto antes de áudio. Há fallback JS (frágil). Deploy no Railway.

## Integração Google Classroom
**Fase 1 feita**: OAuth próprio (separado do BetterAuth, `access_type=offline` + `prompt=consent`),
tokens cifrados em repouso (AES-256-GCM), importação de turmas/alunos com **reconciliação por e-mail**.
Fases 2 (enviar prova → `courseWorkId`) e 3 (passback de nota) estão **engatilhadas, não implementadas**.
**Bloqueio**: projeto GCP ainda não criado (verificação OAuth leva semanas). Sem as envs, o card fica
indisponível (degradação graciosa).

## PostHog (produto/observabilidade)
Cloud US, **product analytics + error tracking**. **Session replay e feature flags adiados** de propósito.
Reverse proxy `/ingest` para escapar de ad-blockers. Captura na API é **fire-and-forget** (nunca
aguardada). Tela `/kintal/metricas` combina Mongo (pedagógico) e HogQL (produto).
