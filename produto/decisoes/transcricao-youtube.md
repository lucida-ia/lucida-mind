---
quando_usar: entender o serviço de transcrição do YouTube e seus gotchas (yt-dlp, ordem de fallback)
última_revisão: 2026-08-25
status: canônico
tags: [ia]
---

# Serviço de transcrição do YouTube

Serviço Python para extrair transcrição de vídeo e usar como fonte em provas/aulas: tenta a legenda
via yt-dlp e, sem legenda, transcreve o áudio pela API da OpenAI (não há Whisper local).
yt-dlp **exige** `player_client=android` (caso contrário bloqueia). Preferência de idioma pt → es → en →
qualquer; legendas manuais antes de auto antes de áudio. Há fallback JS (frágil). Deploy no Railway.

Envs e degradação em [tecnico/integracoes.md](../../tecnico/integracoes.md).
