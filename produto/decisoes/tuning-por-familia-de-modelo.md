---
quando_usar: entender por que a geração é agnóstica à família do modelo e como trocar de modelo
última_revisão: 2026-08-25
status: canônico
tags: [ia]
---

# gpt-5 / tuning por família de modelo

A geração ficou **agnóstica à família do modelo**: um utilitário detecta modelos de raciocínio (`gpt-5`,
série `o`) e ajusta os parâmetros (sem `temperature`, com `reasoning_effort`, `max_completion_tokens`).
Trocar para um gpt-5 é só mudar `OPENAI_MODEL` — **o default segue `gpt-4.1-mini`** por ora. Em
[tecnico/ai-ops.md](../../tecnico/ai-ops.md).
