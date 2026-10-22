---
quando_usar: entender o porquê de uma decisão de produto — índice das decisões registradas
última_revisão: 2026-08-25
status: canônico
---

# Decisões de produto

Decisões com lente de produto (o *porquê*). Origem: memórias de projeto do `lucida-monorepo`.
Uma nota por decisão em `produto/decisoes/`; esta página é o índice.

| Decisão | Em uma linha |
|---|---|
| [rebrand "Lucida única"](decisoes/rebrand-lucida-unica.md) | uma marca, três frentes por cor + qualificador; sub-marcas descontinuadas; frentes de mercado substituídas por School/Creators |
| [Lucida School e Lucida Creators](decisoes/school-e-creators.md) | formal e informal; foco em experiência de aprendizagem, não em ferramental; ainda sem código |
| [analytics como "cubo"](decisoes/analytics-cubo.md) | motor parametrizável calculado on-read, por escopo + corte; corte por habilidade ainda vazio |
| [rebuild do scanner OMR](decisoes/scanner-omr.md) | geometria única vendorizada, ArUco + QR por aluno, scoring na API |
| [transcrição do YouTube](decisoes/transcricao-youtube.md) | serviço Python, legenda antes de áudio, yt-dlp exige `player_client=android` |
| [Google Classroom](decisoes/google-classroom.md) | Fase 1 feita; Fases 2 e 3 são código morto, não feature engatilhada |
| [Biblioteca como fonte](decisoes/biblioteca-como-fonte.md) | sobe uma vez, extrai uma vez, reutilizar não cobra crédito |
| [PostHog](decisoes/posthog.md) | analytics + error tracking; session replay e feature flags adiados de propósito |
| [agendamento + notificação](decisoes/agendamento-e-notificacao.md) | outbox em Mongo em vez de fila; cron ainda não registrado no Railway |
| [média de aprovação](decisoes/media-de-aprovacao.md) | nota de corte do professor, default 6, campo no BetterAuth |
| [nível e objetivos da turma](decisoes/nivel-e-objetivos-da-turma.md) | stage + série livre + objetivos; enum diferente do `Segment` |
| [matemática (LaTeX + KaTeX)](decisoes/matematica-latex.md) | LaTeX inline no texto, com pipeline de reparo e backfill |
| [onboarding com tour](decisoes/onboarding-tour.md) | tour da Lulu, auto-inicia uma vez, refazível |
| [tuning por família de modelo](decisoes/tuning-por-familia-de-modelo.md) | geração agnóstica ao modelo; default segue `gpt-4.1-mini` |
| [limite da descrição da prova](decisoes/limite-da-descricao-da-prova.md) | 500 → 10.000 caracteres |
| [modo de aplicação editável](decisoes/modo-de-aplicacao-editavel.md) | editável após a criação; prova copiada herda o modo |
| [delegação a auxiliares](decisoes/delegacao-a-auxiliares.md) | vínculo N:N na organização; dá dado, nunca autoridade |
| [roadmap público](decisoes/roadmap-publico.md) | kanban aberto com voto, como canal de priorização |
| [hub de instituições](decisoes/hub-de-instituicoes.md) | visão agregada de várias instituições, somente leitura; diverge do ADR-0013 do código |
| [engajamento antes e depois da janela](decisoes/engajamento-fora-da-janela.md) | atividades do aluno não dependem só das janelas do professor; forma ainda não decidida |

## Decisões de 2026-08-15 — fundação do motor de assertividade

As três primeiras foram tomadas juntas e são **pré-condição** uma da outra. **Nenhuma está
implementada.** O KC por questão de que dependem está em construção no épico #141, que substituiu o
ADR-0012 para KC. Fundamento em [produto/motor-assertividade.md](motor-assertividade.md).

| Decisão | Em uma linha |
|---|---|
| [indicadores por KC](decisoes/indicadores-por-kc.md) | reportar por Knowledge Component, com BNCC como chave, mirando o IDEB; em construção no #141 |
| [aluno como usuário](decisoes/aluno-como-usuario.md) | sem identidade persistente não há série histórica por aluno |
| [flashcards como coletor de KC](decisoes/flashcards-coletor-de-kc.md) | prova é evento raro; N≥4 por KC precisa de atividade fora das janelas de prova |
| [ADR-0012 — questão rastreável](decisoes/adr-0012-questao-rastreavel.md) | `questionId` + `learning-object` para a Q-matrix; parado (0009 em branch), substituído pelo #141 para KC |
| [ADR-0013 — instituição como nível 0](decisoes/adr-0013-multi-tenant.md) | org solo para todo professor, org dona dos dados, pool único; mesclado como proposto, fases não executadas |

O ADR-0012 da base é o 0009 do `lucida-monorepo`, só na branch `adr/0010-multi-tenant-institution`,
status `proposto`. Numeração e onde registrar cada tipo de decisão em
[regras/processo.md](../regras/processo.md).
