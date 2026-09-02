---
quando_usar: entender as decisões do tour guiado (quando auto-inicia, onde a flag mora, mobile vs desktop)
última_revisão: 2026-08-25
status: canônico
---

# Onboarding com tour guiado

Primeira sessão no `/app` abre um **tour** (mascote **Lulu**) destacando os 5 caminhos principais
(dashboard, criar prova, criar plano, corrigir, análises). Decisões: **auto-inicia uma vez** (flag
`onboardingTourCompletedAt` no BetterAuth + cache local anti-flicker), **refazível** pelo menu de perfil,
**coachmarks no desktop / modal-resumo no mobile**, e **staff em modo preview não persiste** a flag.
Instrumentado no PostHog (ver [tecnico/eventos-posthog.md](../../tecnico/eventos-posthog.md)).
