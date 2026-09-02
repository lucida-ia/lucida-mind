---
quando_usar: definir escopo de mudança de código por fase de maturidade do motor, consultar parâmetros e os dois princípios de design de avaliação
última_revisão: 2026-08-25
status: canônico
tags: [moat]
---

# Maturidade e parâmetros do motor de assertividade

Do estado atual da base de dados até o estágio capaz de inferir domínio por KC: os parâmetros que
definem escopo de mudança, a escada de fases e os dois princípios que restringem o design da avaliação.

> **Este doc é uma de três partes.** O fundamento científico está em
> [produto/motor-assertividade.md](motor-assertividade.md); os parâmetros e a escada de
> maturidade, em [produto/maturidade-do-motor.md](maturidade-do-motor.md); o objeto proposto,
> em [produto/objeto-de-aprendizagem.md](objeto-de-aprendizagem.md). **Nada disto existe em código.**

---

## Da ciência ao parâmetro

Cada capacidade científica vira parâmetro configurável. Estes são os controles que o agente de
produto lê para definir escopo de código.

| Parâmetro | Significado | Valor inicial sugerido | Fonte |
|---|---|---|---|
| `N_min_observacoes_kc` | Respostas por KC antes de emitir estimativa | **≥ 4** (ver *Princípio 1*) | BKT / convergência |
| `threshold_confiavel` | `p(domínio)` acima do qual o KC conta como "aprendido" | 0.85 (calibrar) | BKT |
| `n_min_confiavel` | Observações para marcar estimativa como "Confiável" vs "Direcional" | = `N_min_observacoes_kc` | Item analysis atual |
| `q_matrix` | Mapa questão → KC(s) → BNCC | schema no arquivo da skill (`a definir` na base) | Tatsuoka 1983 |
| `bkt_params` | `p(L0)`, `p(T)`, `p(S)`, `p(G)` por KC | priors globais, refinar por KC | Corbett & Anderson 1995 |
| `intervalo_revisao` | Janela até reexposição ao KC | curto/médio/longo | Cepeda 2008 |
| `nivel_feedback_max` | Até qual nível de Hattie exibir por exposição | tarefa→processo→autorregulação | Hattie & Timperley 2007 |
| `N_min_calibracao_professor` | Provas antigas para ativar Modo B (estilo) | a definir | — |
| `amplitude_kc_min` | Nº mínimo de KCs distintos por atividade | maximizar (ver *Princípio 2*) | design |

---

## Escada de maturidade: do estado atual ao estágio inferencial

Roteiro de fases; cada uma tem requisito de dado e o que destrava. O agente de produto usa isto
para definir o escopo da próxima mudança de código.

**Fase 0 — Atual (item analysis isolado).**
Cada prova é evento isolado: dificuldade e discriminação por questão, sem persistência entre provas.
Dado: respostas por prova, sem KC.
→ *Escopo de código:* adicionar tagging de KC e `family_id` às questões.

**Fase 1 — Objeto longitudinal.**
Toda questão carrega KC(s) via Q-matrix + `family_id` (skill Objeto de Aprendizagem). Respostas do
mesmo KC passam a ser comparáveis entre provas.
Requisito: Q-matrix validada (ainda que provisória). → destrava séries temporais por KC.

> **A arquitetura desta fase já foi decidida** — ADR-0012 (2026-08-17, status `proposto`, em branch).
> Ver [produto/objeto-de-aprendizagem.md](objeto-de-aprendizagem.md). A auditoria que fundamenta o ADR confirma o diagnóstico da Fase 0: a questão é um
> Value Object sem identidade, e a resposta agrega por **índice posicional**, não por KC.

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
menos 4 atividades com KCs sobrepostos — não provas avulsas. O `family_id` é o mecanismo que amarra
essas exposições ao mesmo KC. Abaixo de 4 observações por KC, a estimativa é marcada
**"Direcional"**, nunca "Confiável".

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
excessiva de itens no mesmo `family_id` como sinal de baixa amplitude.

**Tensão a gerir com o Princípio 1:** amplitude (muitos KCs) vs. profundidade (≥4 observações por KC).
Resolução: a amplitude se dá **dentro de uma atividade** (cobrir muitos KCs); a profundidade se dá
**ao longo da sequência** (o mesmo KC reaparece em ≥4 atividades via `family_id`). As duas regras
operam em eixos diferentes e não competem.
