---
quando_usar: discutir público-alvo, ICP, beachhead, estratégia de expansão e GTM
última_revisão: 2026-06
status: parcial
---

# ICP e beachhead

> **Aviso de escopo.** O código revela *para quem o produto foi construído*, não a *estratégia de
> mercado*. Abaixo, só o que está fundamentado no produto. ICP detalhado, beachhead específico (nicho,
> região, série) e plano de GTM estão marcados `a definir`.

## O que o produto evidencia
- **Usuário primário = professor individual.** Indícios no código: créditos de boas-vindas concedidos
  no cadastro, billing por usuário, app do professor (`/app`) como produto principal, geração/correção
  pensadas para um docente operando sozinho.
- **Expansão = instituição.** Existe uma camada de **organização** (plugin de organização no BetterAuth)
  com `/analytics` (dashboard de instituição, frente roxa), gestão de membros, billing com escopo de
  organização e analytics pedagógico agregando turmas/alunos/provas.
- **Caminho natural:** professor entra sozinho → vira referência dentro da escola → escola adota a
  camada de instituição. O produto suporta os dois lados; o pulo entre eles é organizacional, não técnico.

## A definir (precisa de contexto de negócio)
> a definir — perfil específico do professor (segmento de ensino, disciplina, rede pública vs privada),
> beachhead inicial (por onde começar a vender), canais de aquisição, ciclo de venda institucional,
> objeções e critérios de qualificação. Preencher com input do time, não inferir do código.

Fontes do que está afirmado: domínio `iam` (organization plugin), `billing` (escopo user/org),
área `/analytics` no web. Posicionamento de marca em negocio/posicionamento.md.
