---
destino: ESTADO.md (raiz da base) — ou negocio/estado-e-direcao.md, a decidir
acao: criar
origem: síntese de toda a base (22 docs canônicos + contexto-externo.md + rascunhos) em jul/2026
quando_usar: visão consolidada de onde a Lucida está e para onde caminha; checar alinhamento entre estratégia (produto/negócio/marketing) e realidade técnica
última_revisão: 2026-07
status: rascunho
---

# Lucida — Estado e Direção (jul/2026)

> Snapshot consolidado. Cada afirmação abaixo tem fonte na base; quando produto/negócio/marketing
> divergem do técnico, a divergência está marcada — o código do `lucida-monorepo` é a fonte primária.

---

## 1. Onde a Lucida está

EdTech pré-market fit, 3 founders bootstrap, Sorocaba. Nasceu como geradora de provas com IA e está
no meio de um **pivô de identidade (jun/2026)**: de *eficiência* ("devolver tempo ao professor") para
*eficácia* ("assertividade do aprendizado"). A eficiência vira camada de aquisição; a eficácia é o
moat pretendido.

**Tração (pós re-baseline de checkout, jun/2026):** 2 pagantes ativos (1 instituição + 1
infoprodutor), MRR ~R$ 250. Histórico: 84 pagantes totais, pico de 40 ativos e MRR R$ 749,55,
retenção anual ~50%. Ativos de funil: >3k leads trial frios, ~1k seguidores Instagram. Break-even:
dezenas de pagantes no preço de tabela; a defasagem ticket realizado (R$ 18,74) vs. tabela
(R$ 49,90+) é a maior alavanca de curto prazo.

**Leitura honesta do estado:** a Lucida hoje é uma **empresa de eficiência contando uma história de
eficácia**. A camada de eficiência está construída e operacional (seção 4); a camada de eficácia —
o moat declarado — está em Fase 0 no código (nenhuma questão carrega KC). A janela competitiva
estimada (~18 meses antes de big tech fechar o gap em PT-BR) corre contra essa distância.

## 2. Para onde caminha

1. **Motor de assertividade** (produto/motor-assertividade.md): escada Fase 0 → 4. Próximo escopo de
   código: tagging de KC + `family_id` nas questões (schema proposto no §8 daquele doc, aguardando
   avaliação). Depois: BKT por KC (≥4 observações), diagnóstico de pré-requisito (CDM), neural (DKT).
2. **Plano de aula como backbone BNCC**: de documento exportável para hub onde o resultado de cada
   avaliação volta a escrever no nível da habilidade.
3. **Wedge**: pré-vestibular / cursinho de exatas (STEM) — recorrência + LaTeX + presença
   institucional; loops em semanas.
4. **GTM professor-led**: professor → afiliado → pressão na instituição → instituição fornece acesso
   ao aluno (camada de consentimento LGPDgeral).
5. **Ambiente do aluno**: QR/gabarito virtual → calendário → artefatos → relatório para pais.

---

## 3. Inventário de ativos da base

| Pasta | Docs | Estado |
|---|---|---|
| **negocio/** | visao-geral, posicionamento, icp-beachhead, monetizacao-creditos | Canônicos, mas **pré-pivô**: não refletem o shift eficiência→eficácia, wedge, GTM, moat. Atualização pendente nos rascunhos (visao-geral, icp, monetizacao + 5 docs novos). |
| **produto/** | suite, glossario, estilos-de-questao, decisoes-de-produto, **motor-assertividade** | Canônicos. motor-assertividade (jul/2026) já é pós-pivô; suite pré-pivô (sem backbone/ambiente do aluno — rascunho pronto). |
| **tecnico/** | stack, arquitetura, dominios, billing-ledger, biblioteca, calendario, ai-ops, integracoes, eventos-posthog, convencoes | **A pasta mais completa e atual da base** (revisões até 2026-06-30). Descreve o que existe de fato. |
| **ui/** | modelo-de-ui, design-tokens, identidade-visual | Canônicos e implementados (tokens no globals.css, theme switches, reviewers cobram). |
| **regras/** | codigo, produto, comunicacao | Canônicos e enforçados (agents backend/frontend-reviewer). |
| **marketing/** | **não existe** | O CLAUDE.md promete "marketing" no escopo da base, mas não há pasta. Canais, pitch e narrativa vivem só em contexto-externo.md e rascunhos (canais-aquisicao, pitch). **Lacuna estrutural.** |
| rascunhos/ | 11 arquivos | Aguardando avaliação: 4 substituições + 6 docs novos + este. |

---

## 4. Produto ↔ Técnico

### Convergente — a camada de eficiência está construída

| Promessa de produto | Realidade técnica | Fonte |
|---|---|---|
| Geração de provas (objetiva + aberta, 4 estilos, 3 idiomas) | Operacional; SSE para gerações longas; regeneração unitária | ai-ops |
| **LaTeX/STEM** (pré-requisito do wedge) | **Feito**: pipeline completo (repair → normalize → KaTeX) + backfill retroativo | ai-ops |
| Correção assistida com rubrica (combustível discursivo do moat) | Operacional: `ai_suggested → approved`, IA nunca arbitra nota | ai-ops, submission |
| Dado de papel (claim nº 2 do moat) | OMR rebuilt e validado ponta a ponta; **QR por aluno já existe** (`LUCIDA1\|examId\|studentId`) | decisoes-de-produto, integracoes |
| Biblioteca extract-once (substrato do Modo B) | Operacional; professor já pode subir provas antigas hoje | biblioteca |
| Calendário/janela de resposta (substrato dos touchpoints avaliativos) | Operacional, com outbox de notificação — mas **cron não registrado no Railway** (só reenvio manual) | calendario |
| Item analysis com marca de confiabilidade | Operacional (p, discriminação 27%, Confiável/Direcional) — é a **Fase 0** confirmada | decisoes-de-produto, motor-assertividade |

### Divergente — a camada de eficácia é 100% futura no código

1. **Plano de aula: "backbone" é visão, não realidade.** O contexto pós-pivô diz que o plano "deixou
   de ser documento e virou espinha estruturada… hub onde o resultado volta a escrever". No código,
   `lesson-plan` é um gerador de documento (BNCC nas seções, export DOCX, duplicar, gerar prova a
   partir). **Não existe write-back de resultado no plano.** O loop plano → prova → resultado →
   redesenho → plano não existe.
2. **Questões não carregam KC/habilidade.** Explícito em decisoes-de-produto: "as questões ainda não
   carregam tag de habilidade" — ficou no roadmap do cubo. O schema de 12 campos do objeto de
   aprendizagem (motor-assertividade §8) não tem nenhum campo implementado. **Todo o diagnóstico por
   competência que define o moat é roadmap.**
3. **Ambiente do aluno: 0% construído.** Aluno não tem login (só link público `shareId`); a frente
   "aluno" é cor de marca. As 5 capacidades planejadas partem do zero — com substrato parcial: o QR
   por aluno do OMR encurta o gabarito virtual.
4. **Sequências de atividades (N ≥ 4) sem suporte estrutural.** O princípio de design exige
   sequências com KCs sobrepostos; o `activityType` atual (exam/mockExam/quiz/exerciseList) é só
   rótulo — não há entidade de sequência/trilha nem `family_id`.

---

## 5. Negócio ↔ Técnico

### Convergente

- **Modelo de créditos**: tabela determinística, wallets com prioridade de consumo, débito atômico,
  NFS-e — tudo operacional e batendo com os preços comerciais (Básico/Pro, top-ups, welcome 2000).
- **Camada institucional**: org plugin, `/analytics` (frente roxa), billing org-scope, group
  analytics no PostHog — o ICP 2b tem produto real para aterrissar.
- **Canal parceiro**: public-api com HMAC + webhooks `submission.completed` — o modelo de R$ 149,90
  via parceiro tem substrato técnico de verdade.
- **Infoprodutor (ICP 2a)**: segmento `INFOPRODUTOR` existe em lesson-plan e library.

### Divergente

1. **PIX — doc de negócio contradiz o técnico.** negocio/monetizacao-creditos.md (canônico)
   apresenta PIX/AbacatePay como via ativa de top-up; tecnico/integracoes.md documenta que está
   **desativado por kill-switch intencional** (`PIX_TOPUP_ENABLED = false`, botão escondido no web).
   O doc de negócio (e o rascunho derivado) precisa registrar a pausa.
2. **Programa de afiliados (20% → 8%) não existe no código.** Declarado como canal ativo, mas
   nenhum dos ~25 domínios da api trata afiliação: sem tracking de indicação, sem atribuição, sem
   cálculo de comissão. Ou o programa roda manualmente (não documentado), ou é aspiracional.
3. **Faixas institucionais por volume (10–50 profs, 25–50% off) sem mecânica.** O billing tem
   planos fixos user/org via Stripe; não há per-seat com desconto por faixa. A tabela comercial do
   modelo institucional é planilha, não produto.
4. **Wedge cursinho sem feature específica.** LaTeX (pré-requisito) está pronto; "simulado" é só o
   rótulo `mockExam`. A recorrência estruturada que faz o wedge girar depende do motor (seção 4).

---

## 6. Marketing ↔ Técnico

### Convergente

- **Mensuração de funil-dinheiro é server-side e confiável**: signup, assinatura, top-up, geração,
  submissão, biblioteca — capturados na API, imunes a ad-blocker (com reverse proxy `/ingest`).
- **Onboarding instrumentado** (tour started/step/completed/skipped) — dá para medir ativação.

### Divergente

1. **A narrativa pós-pivô vende o que o produto ainda não faz.** O hero recomendado ("Notas dizem
   quanto. A Lucida diz o quê… diagnóstico por competência") e o pitch de investidor ("primeira rede
   de dado de assertividade pedagógica") descrevem a **Fase 2+** do motor. Hoje o produto entrega
   analytics por questão/dificuldade/percentil — não por competência. Usar a narrativa de eficácia
   na landing **antes do tagging de KC existir** é overpromise mensurável pelo próprio usuário.
   A régua honesta hoje é o "diferencial real" do cenário competitivo: fluxo integrado em PT-BR +
   nicho papel.
2. **Funil client-side majoritariamente não instrumentado.** 13 eventos da taxonomia planejada não
   disparam (`signed_in`, `exam_link_shared`, `public_exam_started`, `grading_approved`,
   `scanner_used`…). As decisões de canal (quais collabs/afiliados convertem) ficam sem dado de
   comportamento in-app.
3. **A alavanca nº 1 (reativar >3k leads frios) tem substrato ocioso.** O domínio `notifications`
   tem campanhas (inbox + sender staff/org-admin) e o transporte Resend está operacional — mas nada
   na base descreve uma motion de reativação usando isso. A lição dos ads (telefone não coletado →
   lead frio) também não virou mudança de cadastro.
4. **Marketing não tem casa na base** (ver seção 3) — canais, pitch e régua de afiliados precisam de
   pasta canônica ou seção própria para sair do limbo de rascunho.

---

## 7. Regras e UI — guard-rails consistentes

Sem divergências relevantes. As regras de código são enforçadas por reviewers dedicados; as regras
de produto (degradação graciosa, rubrica obrigatória, replica set, aluno sem login) batem com o
técnico. A UI implementa o posicionamento "Lucida única" via tokens e theme switches (professor
azul / instituição roxo / kintal grayscale); a frente aluno existe só como cor reservada — coerente
com o fato de o ambiente do aluno não existir. Único débito: copy pré-pivô nas peças públicas
(regras/comunicacao.md não menciona a narrativa de assertividade — rascunho regras-pitch.md cobre).

---

## 8. Divergências críticas, ranqueadas

| # | Divergência | Tipo | Custo de ignorar |
|---|---|---|---|
| 1 | Moat declarado (KC/competência) é Fase 0 no código | Visão ↔ código | A janela de ~18 meses corre; sem tagging de KC, todo dado novo continua sendo "vanity data" não-longitudinal |
| 2 | Narrativa de marketing vende diagnóstico por competência inexistente | Marketing ↔ código | Churn por expectativa quebrada no público mais qualificado |
| 3 | Backbone (write-back no plano) não existe | Produto ↔ código | O loop que define a tese não fecha nem para 1 usuário |
| 4 | Afiliados sem mecânica no produto | Negócio ↔ código | GTM professor-led declarado não é operável/escalável |
| 5 | PIX documentado como ativo em doc canônico de negócio | Base ↔ base | Decisões de pricing/copy erradas; quebra a confiança na base |
| 6 | Faixas institucionais sem produto de per-seat | Negócio ↔ código | Venda direta institucional exige operação manual invisível |
| 7 | Funil client-side não instrumentado + cron de notificações não registrado | Ops | Decisões de canal às cegas; feature de calendário meia-boca em prod |

---

## 9. Substratos técnicos subaproveitados (encurtam o caminho declarado)

1. **QR por aluno no OMR** → o gabarito virtual do ambiente do aluno é evolução, não construção nova.
2. **Biblioteca extract-once** → o Modo B (inferência sobre provas antigas) tem a porta de entrada
   pronta; falta só a inferência.
3. **Calendário + outbox de notificações** → os "touchpoints avaliativos otimizados" do roadmap têm
   a infraestrutura de agendamento e disparo prontas; falta o cérebro (spacing por KC).
4. **Notifications/campanhas + Resend** → a reativação dos >3k leads pode rodar sobre o que existe.
5. **Group analytics por organização no PostHog** → métricas institucionais para o ciclo de venda
   B2B (prova social) já são capturáveis.
6. **`activityType`** → o rótulo que hoje é cosmético é o gancho natural para sequências (N ≥ 4).

---

## 10. Lacunas da própria base de conhecimento

- **negocio/ está pré-pivô** — rascunhos prontos aguardando aprovação desde jun/2026.
- **marketing/ não existe** — conteúdo canônico de canais/pitch sem casa.
- **PIX inconsistente** entre negocio/monetizacao-creditos.md e tecnico/integracoes.md.
- **Pendências `a definir` do motor**: `family_id`, skill Objeto de Aprendizagem, Modo B,
  `N_min_calibracao_professor`, skill irmã de espelho — aguardando avaliação (intencional).
- **icp-beachhead.md canônico ainda diz "a definir"** para ICP/GTM que o contexto externo já definiu.
