---
destino: produto/motor-assertividade.md (arquivo novo)
acao: criar
origem: contexto-externo.md §13 · §14
quando_usar: discutir o motor de inferência de aprendizagem, base científica, BKT/CDM/DKT, Q-matrix, Knowledge Components
última_revisão: 2026-06
status: rascunho
---

# Motor de assertividade — Inferência de aprendizagem

## As três perguntas que o motor responde

1. **Como granularizar o dado para inferir o gap por aluno?**
   Objetivo: sair do nível "errou a questão" e chegar ao nível "não domina o Knowledge Component X,
   que é pré-requisito do KC Y". Requer Q-matrix (mapa KC ↔ questão) ligada ao BNCC.

2. **Qual metodologia adaptativa adotar para direcionar o que estudar a seguir?**
   Objetivo: dado o perfil de domínio estimado do aluno, sugerir a próxima ação com maior
   probabilidade de avanço. Requer modelo preditivo de transição de estado de conhecimento.

3. **Quantos touchpoints avaliativos são necessários para inferência confiável?**
   Objetivo: frequência mínima de avaliações por KC para estimativa estatisticamente estável.
   Impacta o design do calendário avaliativo e a recomendação de espaçamento.

---

## O que já existe hoje no produto

- Item analysis: dificuldade (p) e índice de discriminação (correlação ponto-bisserial).
- Acerto por nível de dificuldade (fácil / médio / difícil).
- Evolução do aluno prova a prova (nota absoluta + percentil na turma).
- Domínio por critério de rubrica (questões discursivas).
- Marcação de confiabilidade: "Confiável" (n ≥ threshold) vs. "Direcional".

## Em pesquisa e desenvolvimento ativo

- **Granularização por Knowledge Component (KC):** ligar cada questão a um ou mais KCs mapeados
  no BNCC via Q-matrix. Permite estimar domínio por habilidade, não por nota.
- **Estimativa de domínio por BKT ou CDM:** a cada resposta, atualizar probabilidade de domínio do
  KC subjacente. Abordagem inicial: BKT (mais simples, interpretável, menos dado necessário) com
  migração futura para DKT conforme o volume histórico crescer.
- **Detecção de gap de pré-requisito:** dado o grafo de dependências de KCs (ex.: fração → divisão
  → multiplicação), identificar em qual nível o aluno quebrou a cadeia.
- **Frequência ótima de avaliação:** usando os parâmetros de espaçamento (Cepeda et al. 2008),
  recomendar ao professor o intervalo ideal entre avaliações de um mesmo KC.

## Roadmap de assertividade (não iniciado)

- **Metodologia adaptativa:** dado o perfil de domínio estimado, sugerir a próxima ação por aluno
  (qual KC revisar, qual nível de dificuldade praticar, qual material do plano de aula acessar).
- **Deep Knowledge Tracing:** substituir BKT por DKT (ou Deep-IRT) quando houver histórico
  suficiente (estimativa: >500 respostas por KC na rede).
- **Relatório adaptativo para pais/aluno:** inferir nível de linguagem, resumir perfil de domínio
  e próximas ações de forma legível para não-especialistas.

---

## Base científica por camada

### Camada 1 — Fundação pedagógica
- Roediger & Karpicke (2006). *Test-Enhanced Learning.* Psychological Science.
  → Recuperação ativa melhora retenção a longo prazo mais que estudo passivo.
- Dunlosky et al. (2013). *Improving Students' Learning.* Psych Science in the Public Interest.
  → Técnicas com evidência forte: prática espaçada e testes. Fracas: releitura, destacar.

### Camada 2 — Knowledge Tracing (BKT e variantes)
- Corbett & Anderson (1995). *Knowledge Tracing.* UMUI.
  → **Artigo fundador do BKT.** 4 parâmetros: p(L₀), p(T), p(S), p(G).
- Yudelson, Koedinger & Gordon (2013). *Individualized BKT models.* AIED.
  → BKT com parâmetros individuais por aluno — melhora significativa de precisão.
- Baker, Corbett & Aleven (2008). *Contextual estimation of slip and guess.* ITS.
- Pavlik, Cen & Koedinger (2009). *Performance Factors Analysis (PFA).* AIED.
  → Alternativa ao BKT, mais simples; modela efeitos de prática e erro acumulado.

### Camada 3 — Cognitive Diagnostic Models (CDM)
- Tatsuoka (1983). *Rule Space.* JEM.
  → Origem do Q-matrix — a base para ligar questão ↔ KC ↔ BNCC.
- de la Torre (2011). *G-DINA Model.* Psychometrika.
  → Estado-da-arte em CDM interpretável para detectar gaps por KC.
- Rupp, Templin & Henson (2010). *Diagnostic Measurement.* Guilford Press.
  → Tratado de referência de CDM aplicado.

### Camada 4 — Deep Knowledge Tracing
- Piech et al. (2015). *Deep Knowledge Tracing (DKT).* NeurIPS.
  → LSTM que prediz probabilidade de acerto em qualquer KC futuro.
- Zhang et al. (2017). *DKVMN.* WWW.
  → Memória explícita por KC — mais interpretável que DKT puro.
- Yeung (2019). *Deep-IRT.* EDM.
  → DKT + interpretabilidade do IRT.

### Camada 5 — Surveys de referência
- Abdelrahman, Wang & Nunes (2023). *Knowledge Tracing: A Survey.* ACM Computing Surveys.
- Liu et al. (2021). *A Survey of Knowledge Tracing.* arXiv:2105.15106.
- Liu, Xu & Ying (2024). *A Survey of Models for Cognitive Diagnosis.* arXiv:2407.05458.

### Camada 6 — Psicometria / IRT
- Embretson & Reise (2000). *Item Response Theory for Psychologists.* Lawrence Erlbaum.
  → Base para parâmetro de dificuldade e discriminação que a Lucida já exibe.
- Lord (1980). *Applications of IRT to Practical Testing Problems.* Lawrence Erlbaum.

### Camada 7 — Espaçamento e dificuldade desejável
- Bjork & Bjork (2011). *Making things hard on yourself.* Psychology and the Real World.
  → Interleaving, variação, espaçamento melhoram retenção.
- Cepeda et al. (2008). *Spacing Effects in Learning.* Psychological Science.
  → Fórmula empírica do intervalo ótimo de revisão. Impacta o calendário avaliativo.

### Camada 8 — Taxonomias (tagging de KCs)
- Krathwohl (2002). *A Revision of Bloom's Taxonomy.* Theory Into Practice.
  → 6 níveis cognitivos (lembrar → criar). Referência para taggar questões além do KC.
- Biggs & Collis (1982). *SOLO Taxonomy.* Academic Press.
  → 5 níveis de qualidade de resposta para questões dissertativas.

### Camada 9 — Carga cognitiva
- Sweller (1988). *Cognitive Load During Problem Solving.* Cognitive Science.
  → Restringe o design de itens — impacta a geração de questões pela IA.
- Craik & Lockhart (1972). *Levels of Processing.* JVLVB.
  → Processamento profundo melhora retenção mais que repetição superficial.

---

## Implicações diretas para o produto

| Decisão de produto | Fundamentação científica |
|---|---|
| Backbone BNCC como grafo de KCs | Q-matrix (Tatsuoka 1983) + G-DINA (de la Torre 2011) |
| Diagnóstico por pré-requisito | BKT com grafo de dependência de KCs (Corbett & Anderson 1995) |
| Calendário avaliativo com frequência recomendada | Spacing effects (Cepeda 2008) + Test-enhanced learning (Roediger 2006) |
| Tagging de questões por dificuldade e nível cognitivo | IRT (Embretson & Reise 2000) + Bloom revisado (Krathwohl 2002) |
| Metodologia adaptativa por aluno | DKT / DKVMN (Piech 2015; Zhang 2017) + PFA (Pavlik 2009) |
| Nº mínimo de touchpoints para estimativa confiável | BKT convergência (Corbett 1995) + Spacing (Cepeda 2008) |
| Dificuldade desejável no design de provas | Bjork & Bjork (2011) + Cognitive Load (Sweller 1988) |
| Rubrica de correção dissertativa em níveis | SOLO Taxonomy (Biggs & Collis 1982) |

---

## Por que o motor é defensável

Não porque usa BKT ou DKT (algoritmos públicos), mas porque:
1. O dado que entra é proprietário: papel + discursivo + trajetória longitudinal que players
   digitais não capturam.
2. O Q-matrix está ligado ao BNCC, permitindo comparabilidade na rede por competência.
3. O loop fecha com outcome: a eficácia do redesenho de metodologia é medida na avaliação seguinte,
   gerando feedback que melhora o próprio modelo — data network effect real.
