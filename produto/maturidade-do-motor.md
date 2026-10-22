---
quando_usar: definir escopo de mudança de código por fase de maturidade do motor, consultar parâmetros e os dois princípios de design de avaliação
última_revisão: 2026-10-22
status: canônico
tags: [moat]
---

# Maturidade e parâmetros do motor de assertividade

Do estado atual da base de dados até o estágio capaz de inferir domínio por KC: os parâmetros que
definem escopo de mudança, a escada de fases e os dois princípios que restringem o design da avaliação.

> **Este doc é uma de três partes.** O fundamento científico está em
> [produto/motor-assertividade.md](motor-assertividade.md); os parâmetros e a escada de
> maturidade, em [produto/maturidade-do-motor.md](maturidade-do-motor.md); o objeto proposto,
> em [produto/objeto-de-aprendizagem.md](objeto-de-aprendizagem.md). **O código está na Fase 0.** KC
> por questão está em construção no épico #141; BKT, `p(domínio)` e CDM não estão em nenhum contrato.

---

## Da ciência ao parâmetro

Cada capacidade científica vira parâmetro configurável. Estes são os controles que o agente de
produto lê para definir escopo de código.

| Parâmetro | Significado | Valor inicial sugerido | Fonte |
|---|---|---|---|
| `N_min_observacoes_kc` | Respostas por KC antes de emitir estimativa | **≥ 4** (ver *Princípio 1*) | BKT / convergência |
| `threshold_confiavel` | `p(domínio)` acima do qual o KC conta como "aprendido" | 0.85 (calibrar) | BKT |
| `n_min_confiavel` | Observações para marcar estimativa como "Confiável" vs "Direcional" | = `N_min_observacoes_kc` | Proposto. O selo que existe hoje usa outro critério: **15 respondentes por recorte** (`RELIABLE_MIN_N`) |
| `q_matrix` | Mapa questão → KC(s) → BNCC | schema no arquivo da skill (`a definir` na base) | Tatsuoka 1983 |
| `bkt_params` | `p(L0)`, `p(T)`, `p(S)`, `p(G)` por KC | priors globais, refinar por KC | Corbett & Anderson 1995 |
| `intervalo_revisao` | Janela até reexposição ao KC | curto/médio/longo | Cepeda 2008 |
| `nivel_feedback_max` | Até qual nível de Hattie exibir por exposição | tarefa→processo→autorregulação | Hattie & Timperley 2007 |
| `N_min_calibracao_professor` | Volume mínimo para o Modo B (estilo) | no código: **5 questões com peso** no perfil de estilo | ADR-0018 |
| `amplitude_kc_min` | Nº mínimo de KCs distintos por atividade | maximizar (ver *Princípio 2*) | design |

---

## Escada de maturidade: do estado atual ao estágio inferencial

Roteiro de fases; cada uma tem requisito de dado e o que destrava. O agente de produto usa isto
para definir o escopo da próxima mudança de código.

**Fase 0 — Atual (item analysis isolado).**
Cada prova é evento isolado. Existe: dificuldade, discriminação (índice dos 27%) e distratores
empíricos por questão de cada prova; domínio por critério de rubrica nas discursivas; linha do tempo
com uma nota média por prova; selo Confiável/Direcional por respondentes. O corte por habilidade do
cubo está modelado e volta sempre vazio. O acerto por questão objetiva não é gravado: a resposta fica
por índice posicional.
Dado: respostas por prova, sem KC.
→ *Escopo de código:* rotular as questões com KC. É o épico #141.

**Fase 1 — Objeto longitudinal.**
Toda questão carrega KC(s) via Q-matrix. Respostas do mesmo KC passam a ser comparáveis entre provas.
Requisito: Q-matrix validada (ainda que provisória). → destrava séries temporais por KC.

> **Em construção: épico #141** (contrato das Fases 0 e 1 em rascunho, PR #221 aberto). As fases do
> épico não são as desta escada: as Fases 1 a 4 do #141 (catálogo de conceitos por organização,
> rótulo principal + até 2 secundários na questão, plano da prova, fato imutável por resposta) cobrem
> a Fase 1 daqui; a Fase 5 do #141 (domínio por conceito com os cortes de respondentes do selo atual)
> é agregação, não BKT. O épico não usa `family_id`: o âncora entre provas é o id do conceito no
> catálogo. O ADR anterior para esta fase (ADR-0012 na base, 0009 em branch no monorepo) está parado.
> Detalhe em [produto/objeto-de-aprendizagem.md](objeto-de-aprendizagem.md).

**Fase 2 — BKT por KC.**
Com `N_min_observacoes_kc` atingido por KC (≥4), estimar `p(domínio)` e marcar Confiável/Direcional.
Requisito: ≥4 atividades com tópicos sobrepostos por KC (*Princípio 1*). → destrava "aferir o nível" e
"aprendido vs não".

**Fase 3 — Diagnóstico de pré-requisito (CDM/G-DINA).**
Com o grafo de KCs ligado ao backbone BNCC, localizar **onde na cadeia** o aluno travou ("o erro
mora uma camada abaixo de onde aparece").
Requisito: grafo de dependência de KCs + volume de padrões de resposta. → destrava o loop fechado
de redesenho de material.

**Fase 4 — Mensuração neural (DKT).**
Quando o volume longitudinal justificar, prever acerto futuro por KC.
Requisito: dado longitudinal denso. → refinamento, não pré-requisito do MVP.

> **Análise do estado atual → estágio final** é literalmente percorrer Fase 0 → Fase 4. O gargalo
> real não é algoritmo (público) — é a **granularização do dado** (Q-matrix correta) e o **volume
> por KC** (*Princípio 1*). É aí que mora a defensabilidade.

---

## Princípio 1 — N ≥ 4 atividades com tópicos sobrepostos

**Regra:** feedback confiável sobre um conhecimento só começa após **pelo menos 4 oportunidades de
aprendizagem (atividades) que compartilhem tópicos entre si** para aquele KC. Uma única prova não
infere domínio — infere desempenho pontual.

**Por quê:**
- O BKT precisa de múltiplas observações do mesmo KC para separar domínio real de acerto por sorte
  (`p(G)`) ou erro por deslize (`p(S)`). Com 1–2 pontos, a estimativa é ruído.
- O spacing effect (Cepeda 2008) e o test-enhanced learning (Roediger & Karpicke 2006) exigem
  exposições **distribuídas no tempo**, não concentradas — daí "atividades" no plural, aplicadas
  ao longo de um período.
- Cada matéria engaja o conhecimento de forma diferente; por isso a sobreposição de tópicos entre
  as 4+ atividades é o que permite triangular o mesmo KC por ângulos diferentes.

**Implicação de produto:** a Lucida deve orientar o professor a construir **sequências** de pelo
menos 4 atividades com KCs sobrepostos — não provas avulsas. O que amarra essas exposições ao mesmo
KC é o identificador do KC (no #141, o id do conceito no catálogo). Abaixo de 4 observações por KC, a
estimativa é marcada **"Direcional"**, nunca "Confiável".

**O volume não pode depender só das janelas de prova do professor** (decisão dos sócios, out/2026).
O aluno é engajado com atividades antes e depois das janelas, pela área do aluno. Prova é evento raro;
as 4+ oportunidades por KC vêm também dessas atividades.

> **O selo que existe hoje não é este critério.** O Confiável/Direcional do analytics conta
> **respondentes no recorte** (Confiável a partir de 15, `RELIABLE_MIN_N`), não oportunidades por KC
> por aluno. São eixos diferentes: o selo diz se a amostra de alunos basta; o Princípio 1 diz se a
> série de um aluno num KC basta.

---

## Princípio 2 — Amplitude máxima de KCs

**Regra:** as questões devem cobrir o **máximo de KCs distintos** possível. Quando não houver
material suficiente para questões distintas por KC distinto, usar o **máximo de formatos distintos
de trabalhar o mesmo KC** (representações, contextos, tipos de questão).

**Por quê:**
- Resolução diagnóstica cresce com o nº de KCs instrumentados: cada KC medido é uma coordenada a
  mais no mapa de domínio do aluno. Concentrar muitas questões no mesmo KC (observado em prova real:
  ~33% dos itens num único sub-KC) **superestima a amplitude** do domínio e desperdiça oportunidade
  de medir outros KCs.
- Quando o material é escasso, variar o **formato** do mesmo KC (múltipla escolha, V-F, discursiva;
  contextos diferentes) mede **transferência** — se o aluno domina o KC ou só o formato. Isso
  aumenta a validade da estimativa sem exigir mais conteúdo distinto.

**Implicação de produto:** o gerador deve **maximizar KCs distintos por atividade** e, sob restrição
de material, **maximizar formatos por KC**. A skill Objeto de Aprendizagem deve reportar concentração
excessiva de itens no mesmo KC como sinal de baixa amplitude.

**Tensão a gerir com o Princípio 1:** amplitude (muitos KCs) vs. profundidade (≥4 observações por KC).
Resolução: a amplitude se dá **dentro de uma atividade** (cobrir muitos KCs); a profundidade se dá
**ao longo da sequência** (o mesmo KC reaparece em ≥4 atividades). As duas regras
operam em eixos diferentes e não competem.
