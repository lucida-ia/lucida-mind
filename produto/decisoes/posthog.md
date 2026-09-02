---
quando_usar: entender o que foi decidido e o que foi adiado de propósito no PostHog
última_revisão: 2026-08-25
status: canônico
tags: [analytics]
---

# PostHog (produto/observabilidade)

Cloud US, **product analytics + error tracking**. **Session replay e feature flags adiados** de propósito.
Reverse proxy `/ingest` para escapar de ad-blockers. Captura na API é **fire-and-forget** (nunca
aguardada). Tela `/kintal/metricas` combina Mongo (pedagógico) e HogQL (produto).

Taxonomia de eventos em [tecnico/eventos-posthog.md](../../tecnico/eventos-posthog.md).
