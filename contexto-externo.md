# Contexto Mestre — Lúcida
> Versão 4 · jun/2026 · fonte única de verdade.
> Substitui: Contexto_Lucida (original), fragmentos do Guia Pré-Seed desatualizados e o Pitch no que toca visão/diferencial/narrativa.
> Seções: 1–12 contexto operacional · 13 base científica · 14 motor de assertividade · 15 breaking changes.
 
---
 
## 1. O que é a Lúcida
 
A Lúcida é uma startup de EdTech em estágio pré-market fit, construída por 3 founders bootstrap em Sorocaba. Nasceu como ferramenta de geração de provas com IA vinculadas ao conteúdo do professor e evoluiu para um ecossistema de avaliação e diagnóstico pedagógico — com a IA gerando, corrigindo e devolvendo inteligência acionável sobre o que cada aluno aprendeu.
 
O produto atende professores individuais, infoprodutores e instituições de ensino (escolas, redes, cursinhos, universidades). Acessa via web e mobile.
 
---
 
## 2. Visão & Tese Estratégica
 
### O shift de visão (jun/2026)
 
A Lúcida deixou de se definir por **eficiência** ("devolver tempo ao professor") e passou a se definir por **eficácia** — apurar a assertividade do processo de aprendizagem: saber exatamente o que estudar e qual a melhor maneira.
 
A distinção é estratégica, não cosmética:
- **Eficiência** (remover burocracia) é a **camada de aquisição** — o gancho que faz o professor entrar e começar a gerar dado.
- **Eficácia** (assertividade do aprendizado) é o **moat** — o que ninguém copia.
A eficiência faz o flywheel começar a girar; a eficácia faz cada volta acumular barreira competitiva.
 
### Missão operacional
 
> Transformar instrumentos pedagógicos em decisão para construir uma melhor jornada educacional para o aluno.
 
O professor é o principal contribuidor do processo de ensino. A burocracia não deve ser o empecilho da jornada pedagógica. Mas devolver tempo e saber ensinar bem são coisas distintas — a Lúcida resolve as duas, nessa ordem.
 
### O loop concreto
 
```
Plano de aula (BNCC)
  → gera prova
  → resultado escrito de volta no nível da competência
  → identifica lacuna de pré-requisito
  → redesenha metodologia / material para aquele aluno
  → atualiza o plano
  ↻ mais dado
```
 
---
 
## 3. Moat & Flywheel
 
**Flywheel = fluxo.** A engrenagem que, girando, acumula vantagem. É a causa.
**Moat = estoque.** A barreira acumulada. É o efeito.
 
Não se constrói moat diretamente: desenha-se o flywheel e gira-se até o moat existir.
 
### O que é combustível (copiável)
- Inferir erro de aluno e sugerir próximo passo — qualquer LLM faz.
- Item analysis (dificuldade, discriminação) — Gradescope já entrega.
### O que é motor (defensável)
1. **Loop fechado ligado a outcome.** Data network effect: mais turmas → calibragem melhor → mais turmas.
2. **Dado de papel + discursivo + trajetória do aluno.** Players digital-first (Google, MagicSchool) não capturam esse dado por construção.
3. **Contexto proprietário do professor**, estruturado pelo **plano de aula segmentado por BNCC** — permite agregar no nível da competência/habilidade ("o que funciona para a habilidade EF07MA10") e diagnosticar no nível do pré-requisito, não do "errou a questão".
### Estado atual do flywheel
- **Projetado, mas parado.** Base re-baselinada para 2 pagantes pós-checkout.
- A densidade necessária para o flywheel girar exige concentração num **wedge** — aposta: pré-vestibular / cursinho de exatas (STEM), onde recorrência + LaTeX + presença institucional se sobrepõem e loops fecham em semanas, não semestres.
- **Pré-condição crítica:** instrumentar o outcome no nível da competência BNCC (ex.: variação de acerto por habilidade entre avaliações consecutivas). Sem isso, o redesenho de metodologia é combustível copiável.
- **Risco a vigiar:** vanity data — volume sem loops fechados gera moat ilusório.
---
 
## 4. Produto
 
### 4.1 Arquitetura Central — Plano de Aula como Backbone (BNCC)
 
O plano de aula deixou de ser documento e virou a **espinha estruturada** do produto. Segmentado por BNCC (médio/fundamental), ele:
- Extrai e guarda informações do material enviado pelo professor.
- Alimenta a geração de **provas** e o **redesenho de metodologia** por aluno/competência.
- É o hub onde o resultado de cada avaliação **volta a escrever**, no nível da habilidade.
Posicionamento: *jornada de construção do conhecimento*, não *exploração do material didático*.
 
O professor pode sempre subir material avulso para gerar provas além do backbone.
 
### 4.2 Funcionalidades Disponíveis
 
**Geração com IA:**
- Provas objetivas e abertas a partir de PDF, texto, DOCX ou vídeo do YouTube.
- Suporte a múltipla escolha, V/F e discursivas.
- Estilos: simple, analytical, reflective, contextual (objetivas); preço fixo por questão (discursivas).
- Três idiomas: PT-BR, inglês, espanhol.
- LaTeX para provas de física e matemática (STEM) — destrава o wedge de maior densidade.
- Planos de aula (backbone) e slides derivados.
**Correção:**
- Online: corrige na hora.
- Offline (OMR): foto do cartão resposta → correção automática.
- Discursivas: IA sugere nota por critério da rubrica (espelho de correção) → professor aprova. Palavra final sempre do professor.
**Analytics (diagnóstico):**
- Por questão: dificuldade (p) e índice de discriminação — flagra questão confusa ou gabarito suspeito.
- Por dificuldade: acerto fácil/médio/difícil.
- Aluno vs. turma: nota individual, percentil e evolução ao longo das provas.
- Domínio por critério (questões abertas).
- Confiabilidade marcada: "Confiável" ou "Direcional" — nada inflado com amostras pequenas.
- *Roadmap:* diagnóstico por competência/habilidade BNCC e por pré-requisito — a camada que fecha o moat.
**Gestão:**
- Turmas, alunos, histórico individual.
- Onboarding para professor e gestor de instituição.
### 4.3 Ambiente do Aluno (em construção)
 
Custo de manutenção ínfimo — habilitável pelo próprio professor. Acesso vinculado ao professor; nos casos institucionais, fornecido pela instituição.
 
**Capacidades planejadas:**
 
1. **Gabarito virtual via QR Code** — o professor gera um QR Code da prova; o aluno acessa pelo celular durante a prova offline e preenche o gabarito virtualmente (sem precisar de cartão resposta físico separado). Integra o offline ao digital sem fricção.
2. **Calendário avaliativo** — aluno visualiza avaliações passadas e futuras, acompanha sua evolução por prova e compara suas próprias métricas ao longo do tempo.
3. **Artefatos pedagógicos de estudo** (vinculado à instituição) — se o aluno tiver vínculo institucional, pode gerar atividades, resumos, mapas mentais, flashcards e outros materiais de estudo a partir do conteúdo do plano de aula do professor.
4. **Avaliação da disciplina** — ao fim do período letivo, o aluno pode atribuir avaliação sobre a disciplina, gerando dado de feedback para o professor e a instituição.
5. **Relatório de desempenho** — inferido pelo sistema; se for aluno de formação de base (fundamental/médio), o relatório pode ser direcionado aos pais ou ao próprio aluno, com linguagem adaptada.
**Versão institucional (roadmap):** jornada curricular dirigida pelo plano de aula do professor → lock-in de dado — a instituição passa a depender da rede, não só de uma ferramenta.
 
⚠ Dado de aluno menor: LGPD de menor com responsabilidade do professor/instituição como controlador de dados.
 
### 4.4 Roadmap de Produto (lente de moat)
 
| Peça | Papel no moat | Prioridade |
|---|---|---|
| **Plano de aula (backbone BNCC)** | Hub que gera o grafo de competências + switching cost | Arquitetura central |
| LaTeX em provas (STEM) | Destrava o wedge de maior densidade | Pré-requisito estratégico |
| Provas discursivas + espelho | Combustível mais rico (raciocínio + rubrica + dado papel) | Alto |
| **Inferência de gap por Knowledge Component** | Granularização do dado por KC — separa motor de combustível | Crítico para o moat |
| **Metodologia adaptativa** | Direciona o que estudar a seguir por aluno | Crítico para a assertividade |
| **Touchpoints avaliativos otimizados** | Frequência ideal de avaliação por retenção e evidência | Motor do loop |
| Ambiente do aluno (QR + calendário + artefatos) | Dado longitudinal + lock-in institucional | Piloto institucional |
| Diagnóstico por competência BNCC + pré-requisito | Fecha o loop de assertividade | Crítico para o moat |
| Relatório para pais / aluno | Expansão de valor para formação de base | Médio prazo |
| Slides + roteiro | Commodity; derivar do plano de aula | Esforço mínimo |
| White-label institucional | Lock-in de dado para redes | Médio prazo |
 
**Sequência recomendada:** backbone + LaTeX + discursivas → inferência de gap por KC (BKT/CDM) → metodologia adaptativa → ambiente do aluno (começa pelo QR Code + calendário) → relatório para pais. Diagnóstico por competência BNCC o quanto antes — é o que fecha o loop e torna o moat mensurável.
 
---
 
## 5. Modelo de Negócio
 
### 5.1 Pay-to-Use por Créditos
 
A assinatura é o **barateamento por fidelização** do consumo de créditos — não uma taxa de acesso. Créditos renovam mensalmente, não acumulam. Para consumir acima da franquia, o usuário evolui de faixa ou compra avulso.
 
### 5.2 Planos
 
| Plano | Preço/mês | Créditos/mês | Anual (−20%) |
|---|---|---|---|
| Básico | R$ 49,90 | 5.000 | ~R$ 39,90/mês |
| Pro | R$ 99,90 | 15.000 | ~R$ 79,90/mês |
 
### 5.3 Créditos Avulsos
 
| Pacote | Preço | R$/crédito |
|---|---|---|
| 2.000 créditos | R$ 29,90 | R$ 0,01495 |
| 5.000 créditos | R$ 59,90 | R$ 0,01198 |
| 15.000 créditos | R$ 149,90 | R$ 0,00999 |
 
### 5.4 Fórmula Real de Consumo
 
```
Créditos = base 250 + (custo/questão × nº de questões)
```
 
| Tipo / Estilo | Custo/questão | 10q | 20q | 50q |
|---|---|---|---|---|
| Objetiva simple | 25 | 500 | 750 | 1.500 |
| Objetiva analytical | 42 | 670 | 1.090 | 2.350 |
| Objetiva reflective / contextual | 45 | 700 | 1.150 | 2.500 |
| Discursiva (1-30q) | 60 | 850 | 1.450 | 2.050 (30q) |
 
**Plano de aula (backbone):** ≤ 30% do custo de uma prova equivalente (~210 créditos pela referência de uma prova reflective de 10q = 700). Deliberadamente barato para maximizar densidade de dado — monetiza-se o output (prova, slides) e os assentos, nunca o backbone.
 
**Trial (cadastro novo):** 1.500 créditos (~2-3 provas objetivas curtas ou 1 objetiva + 1 discursiva com espelho). Custo de servir ≈ R$ 0,17 — calibrar por ativação/conversão, não por custo.
 
### 5.5 Unit Economics
 
**Custo de IA (GPT-4.1 mini — $0,40/M input, $1,60/M output; câmbio ~R$ 5,70):**
- Prova objetiva reflective de 10q: ~R$ 0,06.
- Prova-livro extrema (50q analytical + 324 págs): ~R$ 0,26.
- Custo de IA por professor: R$ 0,18–1,65/mês mesmo em uso 100% pesado (< 2% da receita).
- O teto de créditos do plano é o teto natural de custo.
**Custos fixos (~R$ 3.010/mês):**
- Colaborador: R$ 1.560
- Pró-labore founders: R$ 0 (remuneram-se em outros negócios)
- Marketing: R$ 1.000 (split: 30% institucional / 70% B2C)
- Infra/hosting: R$ 150 (semi-fixo, escala lentamente)
- Outros: R$ 300
**Variáveis:** gateway ~4,5% da receita · Simples Nacional 6%.
 
**Break-even:** dezenas de pagantes no preço de tabela — a maior alavanca de receita é fechar a defasagem entre ticket realizado histórico (R$ 18,74) e preço de tabela atual (R$ 49,90+).
 
---
 
## 6. Modelo Institucional
 
### 6.1 Precificação
 
- **Canal parceiro (hoje):** R$ 149,90/mês líquido para a Lúcida = 30% do que o cliente paga ao parceiro (~R$ 500). Parceiro retém 70%.
- **Preço direto-alvo:** Básico × 10 professores × 0,75 (25% off) = **R$ 374,25**. Vender direto captura ~2,5x mais.
**Faixas por volume (direto):**
 
| Faixa | Desconto | Preço/prof | Receita/mês | Margem |
|---|---|---|---|---|
| 10 profs | 25% | R$ 37,42 | R$ 374,25 | ~81% |
| 20 profs | 32% | R$ 33,93 | R$ 678,64 | ~85% |
| 30 profs | 38% | R$ 30,94 | R$ 928,14 | ~86% |
| 40 profs | 45% | R$ 27,45 | R$ 1.097,80 | ~86% |
| 50 profs | 50% | R$ 24,95 | R$ 1.247,50 | ~86% |
 
O desconto não derruba a margem (custo de IA é centavos). Desconto é arma comercial, não sacrifício — há folga para ser agressivo em redes grandes.
 
### 6.2 GTM Professor-Led (a motion institucional)
 
```
Professor adota (gancho de eficiência)
  → ama o produto
  → vira afiliado
  → pressiona a instituição a adquirir
  → instituição implanta para os demais professores
  → instituição fornece acesso ao aluno
```
 
**Ordem importa:** o movimento institucional é *downstream* do amor do professor pelo produto. Não empurrar a venda institucional antes de o gancho de eficiência do professor estar cravado.
 
A instituição como camada de consentimento LGPD para o dado do aluno.
 
---
 
## 7. ICPs
 
### ICP 1 — Professor Sobrecarregado
Mais de um vínculo institucional. Turmas de 40-50 alunos, ensino médio. 25-45 anos. Corrige manualmente no fim de semana. Já usou IA (ou tem aversão por frustração com ferramentas incompletas).
**Dor central:** tempo fora do trabalho consumido por obrigações do trabalho.
**Canal:** Instagram via micro influenciadores + afiliados.
 
### ICP 2a — Infoprodutor / EdTech Informal
Produtor de conteúdo digital já inserido na venda pelo digital. Precisa validar conteúdo e agregar valor com avaliações. Usa ferramentas desconectadas.
**Dor central:** fragmentação de ferramentas + baixa qualidade das alternativas de IA.
 
### ICP 2b — Instituição de Ensino Tradicional
Escola, universidade ou instituto preso em processos manuais. Ainda não adotou IA por receio de qualidade. Se privada: quer aumentar ticket por aluno. Se pública: quer eficiência operacional.
**Dor central:** processos manuais + bloqueio para adoção de tecnologia.
**Ciclo de venda:** longo, relacional, precisa de prova social.
 
**Wedge de densidade (prioridade estratégica):** pré-vestibular / cursinho de exatas (STEM) — avaliação recorrente sobre o mesmo conteúdo, LaTeX, presença institucional. Loops em semanas, não semestres. É onde o flywheel gira mais rápido e a assertividade aparece primeiro.
 
---
 
## 8. Canais de Aquisição
 
**Ativos:**
- **Professores parceiros** (principal canal atual): professores que já usam e recomendam organicamente.
- **Recomendações de professores**: boca a boca qualificado dentro de redes de educadores.
- **Grupos educacionais** sem automações / gestão pedagógica avaliativa com inferência sobre aprendizagem — canal de entrada direto para o ICP 2b.
- Collabs com micro influenciadores no Instagram (rotina do professor com a Lúcida).
- Programa de afiliados: **comissão financeira 20% → 8% por volumetria** sobre receita indicada (o modelo de pagamento em crédito foi descartado). É custo de caixa real.
  - Indicação de professor: recompensa padrão (20%→8% por volume).
  - Conversão de instituição: esforço maior → recompensa maior (definir régua).
**Testados e descartados:**
- Ads pagos (Meta + Google Search/YouTube): CAC superou R$ 300 → inviável. Erro crítico: telefone não coletado → leads frios.
- Survey por formulário de ICP: apenas 2 respostas → não funciona com essa base.
**Base de leads existente:**
- >3k usuários em modalidade trial (de período de ads).
- ~1k seguidores Instagram.
---
 
## 9. Métricas Atuais
 
> ⚠ Re-baseline de checkout (jun/2026): base pagante reiniciada.
 
| Métrica | Valor atual | Histórico (pré-checkout) |
|---|---|---|
| Pagantes ativos | **2** (1 instituição + 1 infoprodutor) | 40 professores |
| MRR | ~R$ 250 (estimado) | R$ 749,55 |
| Total pagantes histórico | 84 | — |
| Retenção anual | ~50% | — |
| Usabilidade (respostas/prova) | 80% da base ativa | — |
| Instagram | ~1k seguidores | — |
| Leads trial frios | >3k | — |
 
**A maior alavanca de curto prazo:** migrar a base histórica e os leads frios para o preço de tabela atual — vale mais que aquisição nova no imediato.
 
---
 
## 10. Cenário Competitivo
 
### Concorrentes Diretos
Ensinei, Teachy, Lize, MagicSchool, Khanmigo, Educa AI, Letrus, ProfessorAI/Professoria, Profy.
 
**Ameaças relevantes no horizonte:**
- MagicSchool PT-BR completo: estimado 2026–2027. US$ 67M de funding. Sobreposição ~100% de features.
- Teachy: R$ 8M, 200k+ cadastros. Pode atacar os gaps (papel, creator).
- Khanmigo (gratuito via Microsoft): pisa o preço para zero e ocupa o lado do aluno.
### Radar de Big Tech — o golpe é de distribuição, não de tecnologia
 
| Feature da Lúcida | Quem já faz, como e a que preço |
|---|---|
| Geração de prova do material | **Google NotebookLM** — quizzes/flashcards das fontes; grátis; em Workspace for Education desde set/2025 |
| Correção offline / cartão resposta | **ZipGrade / GradeCam** (professor individual, celular, offline, grátis); **Gradescope/Turnitin** (institucional, cartão + manuscrito + rubrica) |
| Plano de aula / slides | Gemini (Slides/Docs), Microsoft Copilot, Canva — grátis com distribuição massiva |
| Métricas por aluno/turma | Google Classroom analytics + item analysis do Gradescope |
| Ambiente do aluno | Khanmigo (gratuito), Google Classroom |
 
**O golpe não é tecnológico — é distribuição + preço zero.** Google já tem todas as peças dentro de escolas que pagam Workspace. Para canibalizar a Lúcida, basta ligar um toggle no admin console — a custo marginal zero para o usuário. **Janela: ~18 meses.**
 
**A defesa não é feature — é moat de dado.** Loop fechado + dado de papel/discursivo + densidade no wedge BNCC é o que os players de distribuição não têm e não constroem rápido.
 
### Diferencial Real (reframe honesto)
- ❌ "Correção offline única" — contestável (Gradescope, ZipGrade já fazem).
- ✅ **Fluxo integrado em PT-BR** (gerar → aplicar → corrigir papel + online → diagnóstico) + nicho papel + moat de dado por competência BNCC — o que não existe junto em nenhum produto disponível para o professor avulso brasileiro.
---
 
## 11. Narrativa de Pitch (atualizada)
 
### Para professor (30s, gancho de dor)
> "Todo professor sabe ensinar — o que falta é tempo. Ele afoga em montar prova, corrigir no fim de semana, refazer plano de aula. A Lúcida assume essa parte: gera, corrige no papel ou online, e devolve o tempo dele. Mas o ponto não é só economizar tempo — é transformar cada prova em decisão. A gente mostra, por competência, onde o aluno travou e o que ensinar diferente."
 
### Para investidor (narrativa de moat)
A Lúcida é a primeira rede de dado de assertividade pedagógica do Brasil. O plano de aula segmentado por BNCC é o backbone que estrutura o contexto proprietário do professor; a avaliação (papel + digital + discursiva) é a fonte de dado que players digitais não capturam; o loop fechado a outcome é o data network effect que compõe. Quanto mais turmas, mais preciso o diagnóstico — e mais difícil de alcançar. A janela competitiva é de ~18 meses antes de big tech fechar o gap em PT-BR.
 
### Hero da landing (recomendado, pós-pivô)
> **"Notas dizem quanto. A Lúcida diz o quê."**
> Toda prova que você aplica vira diagnóstico por competência: exatamente qual habilidade cada aluno domina, onde travou, e o que ensinar a seguir — do seu próprio material, em minutos.
 
---
 
## 13. Base Científica do Motor de Assertividade
 
A Lúcida está ativamente estudando e implementando a literatura de Knowledge Tracing, Cognitive Diagnostic Models e psicometria para fundamentar o motor de inferência de aprendizagem. Abaixo a lógica e as referências por camada.
 
### 13.1 Três perguntas que o motor precisa responder
 
1. **Como granularizar o dado para inferir o gap de conhecimento por aluno?**
   Objetivo: sair do nível "errou a questão" e chegar ao nível "não domina o Knowledge Component X, que é pré-requisito do KC Y". Requer modelagem de KCs ligados ao BNCC e Q-matrix (mapa KC ↔ questão).
2. **Qual metodologia adaptativa adotar para direcionar o que estudar a seguir?**
   Objetivo: dado o perfil de domínio estimado do aluno, sugerir a próxima ação com maior probabilidade de avanço (conteúdo a revisar, questão de prática, nível de dificuldade). Requer modelo preditivo de transição de estado de conhecimento.
3. **Quantos touchpoints avaliativos são necessários para inferência confiável?**
   Objetivo: definir a frequência mínima de avaliações por KC para que a estimativa de domínio seja estatisticamente estável. Impacta diretamente o design do calendário avaliativo e a recomendação de espaçamento.
### 13.2 Ordem de leitura e implementação
 
**Camada 1 — Fundação pedagógica**
- Roediger & Karpicke (2006). *Test-Enhanced Learning.* Psychological Science. → O "porquê" da prova: recuperação ativa melhora retenção a longo prazo mais que estudo passivo.
- Dunlosky et al. (2013). *Improving Students' Learning With Effective Learning Techniques.* Psychological Science in the Public Interest. → Meta-revisão de 10 técnicas; define quais estratégias têm evidência forte (prática espaçada, testes) vs. fraca (releitura, destacar).
**Camada 2 — Knowledge Tracing (BKT e variantes)**
- Corbett & Anderson (1995). *Knowledge Tracing: Modeling the acquisition of procedural knowledge.* UMUI. → **Artigo fundador do BKT.** Modelo probabilístico de 4 parâmetros (p(L₀), p(T), p(S), p(G)) que estima a probabilidade de domínio de um KC a cada resposta.
- Yudelson, Koedinger & Gordon (2013). *Individualized BKT models.* AIED. → BKT com parâmetros individuais por aluno — melhora significativa de precisão.
- Baker, Corbett & Aleven (2008). *Contextual estimation of slip and guess.* ITS. → Slip e guess variam com o contexto do item: mesma questão, parâmetros diferentes por aluno.
- Pavlik, Cen & Koedinger (2009). *Performance Factors Analysis (PFA).* AIED. → Alternativa ao BKT, mais simples de implementar; modela efeitos de prática e erro acumulado.
**Camada 3 — Cognitive Diagnostic Models (CDM)**
- Tatsuoka (1983). *Rule Space.* JEM. → Origem do Q-matrix e do diagnóstico por padrões de erro — a base para ligar questão ↔ KC ↔ BNCC.
- de la Torre (2011). *The Generalized DINA Model (G-DINA).* Psychometrika. → Framework formal para detectar gaps por KC. G-DINA é o estado-da-arte em CDM interpretável.
- Junker & Sijtsma (2001). *DINA Model.* Applied Psychological Measurement. → Formulação original do DINA (Deterministic Input, Noisy And gate).
- Rupp, Templin & Henson (2010). *Diagnostic Measurement.* Guilford Press. → Tratado de referência de CDM aplicado.
**Camada 4 — Deep Knowledge Tracing**
- Piech et al. (2015). *Deep Knowledge Tracing (DKT).* NeurIPS. → Estado-da-arte neural: LSTM que prediz probabilidade de acerto em qualquer KC futuro a partir do histórico de respostas.
- Zhang et al. (2017). *DKVMN.* WWW. → Memória explícita por KC — mais interpretável que DKT puro.
- Yeung (2019). *Deep-IRT.* EDM. → DKT + interpretabilidade do IRT: combina poder preditivo neural com parâmetros legíveis (habilidade do aluno, dificuldade do item).
**Camada 5 — Surveys**
- Abdelrahman, Wang & Nunes (2023). *Knowledge Tracing: A Survey.* ACM Computing Surveys. → Mapa completo do campo: BKT, PFA, DKT e variantes num único texto.
- Liu et al. (2021). *A Survey of Knowledge Tracing.* arXiv:2105.15106. → Foco em métodos profundos.
- Liu, Xu & Ying (2024). *A Survey of Models for Cognitive Diagnosis.* arXiv:2407.05458. → Evolução de CDM e conexão com KT.
**Camada 6 — Psicometria / IRT**
- Embretson & Reise (2000). *Item Response Theory for Psychologists.* Lawrence Erlbaum. → Entrada mais didática no IRT; base para o parâmetro de dificuldade e discriminação que a Lúcida já exibe.
- Lord (1980). *Applications of IRT to Practical Testing Problems.* Lawrence Erlbaum.
- van der Linden & Hambleton (1997). *Handbook of Modern IRT.* Springer.
**Camada 7 — Espaçamento e dificuldade desejável**
- Bjork & Bjork (2011). *Making things hard on yourself.* Psychology and the Real World. → Teoria das dificuldades desejáveis: interleaving, variação, espaçamento melhoram retenção.
- Cepeda et al. (2008). *Spacing Effects in Learning.* Psychological Science. → Fórmula empírica do intervalo ótimo de revisão por nível de retenção desejado. Impacta o design do calendário avaliativo.
**Camada 8 — Taxonomias (tagging de KCs)**
- Krathwohl (2002). *A Revision of Bloom's Taxonomy.* Theory Into Practice. → Bloom revisado: 6 níveis cognitivos (lembrar → criar). Referência para taggar questões por nível cognitivo além do KC.
- Biggs & Collis (1982). *SOLO Taxonomy.* Academic Press. → Complementar a Bloom para questões dissertativas: 5 níveis de qualidade de resposta.
**Camada 9 — Carga cognitiva**
- Sweller (1988). *Cognitive Load During Problem Solving.* Cognitive Science. → Cognitive Load Theory: restringe o design de itens (não sobrecarregar a memória de trabalho). Impacta a geração de questões pela IA.
- Craik & Lockhart (1972). *Levels of Processing.* JVLVB. → Processamento profundo (elaboração, conexão com o que já se sabe) melhora retenção mais que repetição superficial.
### 13.3 Implicações diretas para o produto
 
| Decisão de produto | Fundamentação científica |
|---|---|
| Backbone BNCC como grafo de KCs | Q-matrix (Tatsuoka 1983) + G-DINA (de la Torre 2011) |
| Diagnóstico por pré-requisito | BKT com grafo de dependência de KCs (Corbett & Anderson 1995) |
| Calendário avaliativo com frequência recomendada | Spacing effects (Cepeda et al. 2008) + Test-enhanced learning (Roediger & Karpicke 2006) |
| Tagging de questões por dificuldade e nível cognitivo | IRT (Embretson & Reise 2000) + Bloom revisado (Krathwohl 2002) |
| Metodologia adaptativa por aluno | DKT / DKVMN (Piech 2015; Zhang 2017) + PFA (Pavlik 2009) |
| Número mínimo de touchpoints para estimativa confiável | BKT convergência (Corbett & Anderson 1995) + Spacing (Cepeda 2008) |
| Dificuldade desejável no design de provas | Bjork & Bjork (2011) + Cognitive Load (Sweller 1988) |
| Rubrica de correção dissertativa em níveis | SOLO Taxonomy (Biggs & Collis 1982) |
 
---
 
## 14. Motor de Assertividade — Arquitetura de Inferência
 
Esta seção descreve o que está sendo construído para operacionalizar a visão de assertividade. Distingue o que já existe, o que está em pesquisa ativa e o que é roadmap.
 
### 14.1 O que já existe (hoje no produto)
- Item analysis: dificuldade (p) e índice de discriminação (correlação ponto-bisserial).
- Acerto por nível de dificuldade (fácil / médio / difícil).
- Evolução do aluno prova a prova (nota absoluta + percentil na turma).
- Domínio por critério de rubrica (questões discursivas).
- Marcação de confiabilidade: "Confiável" (n ≥ threshold) vs. "Direcional".
### 14.2 Em pesquisa e desenvolvimento ativo
- **Granularização por Knowledge Component (KC):** ligar cada questão a um ou mais KCs mapeados no BNCC via Q-matrix. Permite estimar domínio por habilidade, não por nota.
- **Estimativa de domínio por BKT ou CDM:** a cada resposta do aluno, atualizar a probabilidade de domínio do KC subjacente. Abordagem inicial: BKT (mais simples, interpretável, menos dado necessário) com migração futura para DKT conforme o volume de histórico crescer.
- **Detecção de gap de pré-requisito:** dado o grafo de dependências de KCs (ex.: fração → divisão → multiplicação), identificar em qual nível o aluno quebrou a cadeia.
- **Frequência ótima de avaliação:** usando os parâmetros de espaçamento de Cepeda et al. (2008), recomendar ao professor o intervalo ideal entre avaliações de um mesmo KC para maximizar retenção.
### 14.3 Roadmap de assertividade (ainda não iniciado)
- **Metodologia adaptativa:** dado o perfil de domínio estimado, sugerir a próxima ação por aluno (qual KC revisar, qual nível de dificuldade praticar, qual material do plano de aula acessar).
- **Deep Knowledge Tracing:** substituir o BKT por DKT (ou Deep-IRT) quando houver histórico suficiente (estimativa: >500 respostas por KC na rede).
- **Relatório adaptativo para pais/aluno:** inferir nível de linguagem, resumir o perfil de domínio e as próximas ações recomendadas de forma legível para não-especialistas.
### 14.4 A distinção que protege o moat
 
O motor é defensável não porque usa BKT ou DKT (algoritmos públicos), mas porque:
1. O dado que entra é proprietário: papel + discursivo + trajetória longitudinal que players digitais não capturam.
2. O Q-matrix está ligado ao BNCC, o que permite comparabilidade na rede (o que funciona para a habilidade X em outras turmas/escolas da rede).
3. O loop fecha com outcome: a eficácia do redesenho de metodologia é medida na avaliação seguinte, gerando feedback que melhora o próprio modelo — data network effect.
---
 
## 15. Breaking Changes (histórico)
 
| Data | Mudança |
|---|---|
| abr/2025 | Pivô de ferramenta de provas → ecossistema do professor |
| abr/2025 | Modelo migrado de quantidade de provas/alunos → consumo de créditos |
| abr/2025 | Adição de planos de aula, slides; início de white-label e área do aluno |
| jun/2026 | **Shift de visão: eficiência → eficácia (assertividade).** A eficiência vira camada de aquisição; o dado longitudinal ligado a outcome é o moat. Substitui o enquadramento de "ecossistema de ferramentas" com correção offline como diferencial central. |
| jun/2026 | **Plano de aula vira backbone BNCC.** Extrai info do material, alimenta provas e redesenho de metodologia. Loop: plano → prova → resultado por competência → redesenha → atualiza o plano. |
| jun/2026 | **GTM professor-led.** Professor adota → afiliado → pressiona instituição → instituição fornece acesso ao aluno. |
| jun/2026 | **Afiliado financeiro (20%→8% por volumetria).** O modelo de pagamento em crédito foi descartado. É custo de caixa real. |
| jun/2026 | **Ambiente do aluno expandido:** QR Code + gabarito virtual, calendário avaliativo, artefatos pedagógicos (vinculado à instituição), avaliação da disciplina, relatório para pais/aluno. |
| jun/2026 | **Re-baseline de checkout.** Base pagante reiniciada para 2 usuários (1 instituição + 1 infoprodutor). Histórico de 40 pagantes / MRR R$ 749,55 passa a ser referência, não posição atual. |
| jun/2026 | **Motor de assertividade fundamentado em literatura científica** (BKT, CDM, DKT, IRT, spacing effects). Pesquisa ativa em inferência de gap por KC e metodologia adaptativa. |
| jun/2026 | **Biblioteca** (domínio `library`): professor sobe PDF/DOCX/TXT (upload presigned a S3/Railway Buckets), texto extraído uma vez e reusável como fonte das gerações sem custo extra. Gateada por acesso (dono/org/assinante). |
| jun/2026 | **Tipo de atividade na prova** (`exam`/`mockExam`/`quiz`/`exerciseList`, default `exam`): só classifica/filtra; não muda geração, preço ou correção. |
| jun/2026 | **PIX (AbacatePay) pausado** por kill-switch (`PIX_TOPUP_ENABLED = false`): top-up só por cartão; webhook segue liquidando cobranças já emitidas. Pausa temporária. |
 
