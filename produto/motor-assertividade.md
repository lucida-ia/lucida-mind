---
quando_usar: fundamentar o motor de assertividade (BKT/CDM/IRT), definir escopo de mudança de código por fase, consultar parâmetros do motor e princípios de design de avaliação
última_revisão: 2026-08-25
status: canônico
---

# Base Científica do Moat e Parametrização do Motor de Assertividade

> **Propósito:** consolidar a fundamentação científica que sustenta a defensabilidade da Lucida **e**
> traduzi-la em parâmetros que o agente de produto usa para definir escopos de mudança no código —
> do estado atual da base de dados até o estágio capaz de inferir domínio por KC.
> **Nota de roteamento:** a *narrativa de moat* derivada daqui (para investidor) é subproduto e deve
> viver em `/negocio` ou alimentar o deck — este arquivo é o **fundamento técnico**, não a peça de pitch.

> ⚠ **Artefatos referenciados ainda não definidos nesta base** (`a definir` — lacunas conhecidas,
> não convites a inventar):
> - **`family_id`** — mecanismo que amarra exposições do mesmo KC entre atividades (skill Objeto de
>   Aprendizagem). Sem doc na base.
> - **Skill "Objeto de Aprendizagem"** — referida como dona do schema da Q-matrix e do reporte de
>   concentração de itens. Sem doc na base.
> - **"Modo B (estilo)"** e **`N_min_calibracao_professor`** — calibração por provas antigas do
>   professor. Sem doc na base.

---

## 1. A tese do moat em uma frase

O defensável não é gerar avaliação com qualidade (copiável por qualquer ferramenta). É a
**interoperabilidade entre o que avaliar, quando avaliar e como avaliar**, fechada com **outcome
medido** — gerando um data network effect que players digital-first não capturam. A ciência abaixo
é o que torna essa interoperabilidade implementável, não apenas retórica.

---

## 2. A pilha científica (o que cada bloco resolve)

### Bloco A — Estimar domínio a cada resposta (Knowledge Tracing)
Resolve **"aferir o nível"**: estimar `p(domínio)` por KC, não por nota.
- Corbett & Anderson (1995), *Knowledge Tracing* — BKT, parâmetros `p(L0)`, `p(T)`, `p(S)` (slip), `p(G)` (guess).
- Yudelson, Koedinger & Gordon (2013) — BKT individualizado por aluno.
- Baker, Corbett & Aleven (2008) — slip/guess variáveis por contexto.
- Pavlik, Cen & Koedinger (2009), *PFA* — alternativa mais simples de implementar.

### Bloco B — Diagnóstico por componente e pré-requisito (CDM)
Resolve **"o quê" travou** e **onde na cadeia de pré-requisito**.
- Tatsuoka (1983), *Rule Space* — origem da **Q-matrix** (questão ↔ KC ↔ BNCC).
- de la Torre (2011), *G-DINA* — CDM interpretável, múltiplos KCs por item.
- Junker & Sijtsma (2001), *DINA* — formulação original.
- Rupp, Templin & Henson (2010) — tratado de referência.

### Bloco C — Psicometria / IRT (base do que já roda hoje)
Sustenta dificuldade e discriminação por item (item analysis atual).
- Embretson & Reise (2000) — entrada didática no IRT.
- Lord (1980); van der Linden & Hambleton (1997) — clássicos.

### Bloco D — Mensuração neural (roadmap, quando houver volume)
- Piech et al. (2015), *DKT* — LSTM que prediz acerto futuro por KC.
- Zhang et al. (2017), *DKVMN* — memória explícita por KC, mais interpretável.
- Yeung (2019), *Deep-IRT* — poder neural com parâmetros legíveis.

### Camadas de apoio (definem *o quê* e *quando* medir)
- **Nível cognitivo:** Krathwohl (2002), Bloom revisado; Biggs & Collis (1982), SOLO.
- **Frequência/consolidação:** Cepeda et al. (2008), spacing; Roediger & Karpicke (2006), test-enhanced learning.
- **Avaliação formativa (o campo que originou tudo):** Black & Wiliam (1998, 2009); Shute (2008),
  *Focus on Formative Feedback*; Shute & Rahimi (2017), *Computer-based Assessment for Learning* —
  o elo entre a tradição pedagógica e a formalização algorítmica.
- **Estrutura do feedback:** Hattie & Timperley (2007) — níveis tarefa / processo / autorregulação / self.

**Os três nomes que sustentam o mínimo viável:** Corbett & Anderson (1995) para estimar domínio,
Tatsuoka (1983) para ligar questão a KC, Embretson & Reise (2000) para o que já roda.

---

## 3. Da ciência ao parâmetro (o que o agente de produto usa)

Cada capacidade científica vira parâmetro configurável. Estes são os controles que o agente de
produto lê para definir escopo de código.

| Parâmetro | Significado | Valor inicial sugerido | Fonte |
|---|---|---|---|
| `N_min_observacoes_kc` | Respostas por KC antes de emitir estimativa | **≥ 4** (ver §5) | BKT / convergência |
| `threshold_confiavel` | `p(domínio)` acima do qual o KC conta como "aprendido" | 0.85 (calibrar) | BKT |
| `n_min_confiavel` | Observações para marcar estimativa como "Confiável" vs "Direcional" | = `N_min_observacoes_kc` | Item analysis atual |
| `q_matrix` | Mapa questão → KC(s) → BNCC | schema no arquivo da skill (`a definir` na base) | Tatsuoka 1983 |
| `bkt_params` | `p(L0)`, `p(T)`, `p(S)`, `p(G)` por KC | priors globais, refinar por KC | Corbett & Anderson 1995 |
| `intervalo_revisao` | Janela até reexposição ao KC | curto/médio/longo | Cepeda 2008 |
| `nivel_feedback_max` | Até qual nível de Hattie exibir por exposição | tarefa→processo→autorregulação | Hattie & Timperley 2007 |
| `N_min_calibracao_professor` | Provas antigas para ativar Modo B (estilo) | a definir | — |
| `amplitude_kc_min` | Nº mínimo de KCs distintos por atividade | maximizar (ver §6) | design |

---

## 4. Escada de maturidade: do estado atual ao estágio inferencial

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
> Ver §8.7 abaixo. A auditoria que fundamenta o ADR confirma o diagnóstico da Fase 0: a questão é um
> Value Object sem identidade, e a resposta agrega por **índice posicional**, não por KC.

**Fase 2 — BKT por KC.**
Com `N_min_observacoes_kc` atingido por KC (≥4), estimar `p(domínio)` e marcar Confiável/Direcional.
Requisito: ≥4 atividades com tópicos sobrepostos por KC (§5). → destrava "aferir o nível" e
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
> por KC** (§5). É aí que mora a defensabilidade.

---

## 5. Princípio de design 1 — N ≥ 4 atividades com tópicos sobrepostos

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

## 6. Princípio de design 2 — Amplitude máxima de KCs

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

**Tensão a gerir com o §5:** amplitude (muitos KCs) vs. profundidade (≥4 observações por KC).
Resolução: a amplitude se dá **dentro de uma atividade** (cobrir muitos KCs); a profundidade se dá
**ao longo da sequência** (o mesmo KC reaparece em ≥4 atividades via `family_id`). As duas regras
operam em eixos diferentes e não competem.

---

## 7. Os cinco pontos de interoperabilidade (o moat, destrinchado)

Nenhum ponto isolado é defensável; cada um já existe em alguma ferramenta. O que ninguém tem junto:

1. **Feedback nivelado** (Hattie) escrito de volta num
2. **grafo de KC validado** (Q-matrix + BNCC), através de
3. **objetos rastreáveis longitudinalmente** (`family_id`), numa
4. **avaliação de dupla função** (somativa + formativa) sem fricção pro professor,
5. de forma **invisível** (orquestração inferida, não digitada).

O algoritmo é público; a orquestração fechada com dado proprietário é o moat.

---

## 8. Complemento — comportamento proposto do objeto de aprendizagem

> **Enquadramento:** derivado da skill operacional "Objeto de Aprendizagem" (a skill em si vive fora
> desta base, no repo de skills do agente — aqui só o conhecimento de produto). Descreve como o
> produto **possivelmente** deve se comportar segundo a instrução construída na skill. **Não é
> decisão canônica**: os itens do bloco `a definir` no topo permanecem pendentes de avaliação futura.

### 8.1 Princípio central

"Cada questão é um objeto de aprendizagem" só é verdade se ela carregar identidade suficiente para
ser rastreável **entre provas diferentes**, não apenas dentro de uma prova. Sem essa estrutura, a
questão é evento isolado; com ela, cada resposta do aluno vira evidência dentro da trajetória de um
KC.

### 8.1.1 O que "identidade" significa aqui — três conceitos, não um

O gerador **cria questões novas a cada prova**; ele não reusa o mesmo objeto-questão entre provas.
Isso é o que ninguém deduz do código, e confundir os três leva a modelagem errada:

- **`questionId`** — identidade da *instância*: uma ocorrência de questão numa prova. É o que permite
  atribuir a resposta a ela.
- **`family_id`** — chave de *agrupamento* das instâncias que testam o(s) mesmo(s) KC(s) entre provas.
  É o âncora longitudinal de verdade, e o gancho de deduplicação.
- **`kc[]`** — os códigos (BNCC ou provisórios) que a instância exercita.

"Dar identidade à questão" é, na prática, **dar `questionId` à instância + dar dono ao `family_id`**.

### 8.2 Schema proposto do objeto

| Campo | Tipo | Descrição |
|---|---|---|
| `questao_id` | string | Identificador da questão |
| `kc` | lista | Código(s) BNCC ou KC provisório |
| `kc_status` | validado \| não validado | Se o professor confirmou o mapeamento |
| `nivel_cognitivo` | Bloom (6) ou SOLO (5) | Bloom para objetivas; SOLO para discursivas |
| `dificuldade_prior` | baixa \| média \| alta | Estimativa qualitativa pré-dado; o motor recalibra com respostas reais |
| `discriminacao_esperada` | baixa \| alta | Sinaliza revisão se baixa — questões de baixa discriminação poluem a estimativa de domínio |
| `feedback_tarefa` | texto | Sempre presente |
| `feedback_processo` | texto \| null | Obrigatório se nível "aplicar"+ ou discursiva |
| `feedback_autorregulacao` | texto \| null | Só a partir da 2ª exposição ao KC |
| `distrator_diagnostico` | mapa alternativa→concepção | Só objetivas |
| `family_id` | string | Agrupa questões do mesmo KC entre provas |
| `intervalo_sugerido_revisao` | curto \| médio \| longo | Baseado em spacing (Cepeda 2008) |

### 8.3 Conceitos do schema

- **`family_id`** — agrupa questões que testam o(s) mesmo(s) KC(s), mesmo em provas diferentes. É o
  que permite ao BKT tratar respostas de provas distintas como a mesma série temporal. Também é o
  gancho de deduplicação: duas questões com mesmo `family_id` e mesmos números são redundância.
- **`kc_status` (validado / não validado)** — o mapeamento nasce "não validado"; após validação
  única pelo professor, reutiliza sem repedir; só re-sinaliza se o padrão de resposta divergir de
  outras questões do mesmo KC. Espelha o padrão `ai_suggested → approved` que a correção de abertas
  já usa (professor-in-the-loop com fricção mínima).
- **KC provisório** — sem plano BNCC vinculado, cria-se KC com nome curto descritivo (ex.:
  `razao_trabalho_conjunto`); nunca deixar vazio. É o mecanismo dos KCs abertos para os segmentos
  FACULDADE/INFOPRODUTOR, onde a taxonomia BNCC não se aplica.
- **`distrator_diagnostico`** — para cada alternativa incorreta de objetiva, a concepção errada
  específica que levaria a escolhê-la. Cada distrator vira uma sonda de sub-erro distinto: transforma
  "1 questão" em "1 questão + N sondas de erro" e multiplica a resolução do diagnóstico sem custo
  extra para o professor (conecta com o princípio de amplitude, §6). Se dois distratores mapeiam a
  mesma concepção, ou um não corresponde a erro plausível → sinal de baixa discriminação. Para
  discursivas, o equivalente é a rubrica/espelho por níveis SOLO.

### 8.4 Regras propostas de feedback (Hattie & Timperley 2007)

Roteiro em até 3 níveis por exposição:
- **Tarefa** — o que estava certo/errado no resultado (sempre presente).
- **Processo** — qual passo do raciocínio falhou (obrigatório para discursivas e nível "aplicar"+).
- **Autorregulação** — pergunta que o aluno deveria ter se feito (só a partir da 2ª exposição ao
  mesmo KC).
- **Nunca** feedback de nível "self" (elogio/crítica pessoal) — o menos eficaz na literatura.

### 8.5 Verificações de qualidade que o pipeline deve embutir

Aprendidas em testes reais com provas da Lucida:

1. **Recalcular e conferir o gabarito** ao estruturar — recomputar a resposta e comparar com o
   gabarito gerado. Bloqueia na origem questões defeituosas (sem alternativa correta) — já observado
   em prova real.
2. **Deduplicar por `family_id`** — detectar itens equivalentes na mesma prova.
3. **Sinalizar mismatch de tagging** — se o título/plano diz um conteúdo (ex.: "Logaritmos") mas os
   KCs das questões são de pré-requisito (ex.: potências/radicais), avisar: o gap diagnosticado
   cairia na camada errada.
4. **Cobertura cognitiva** — reportar se a prova concentra tudo em "aplicar" e não toca
   "analisar/avaliar".

### 8.6 Modo B — calibração por professor (complemento ao Modo A; possível feature futura)

O Modo B **não sobrepõe o Modo A** (estruturação) — é complemento. Quando o professor sobe **provas
antigas** na sua Biblioteca, abre-se a possibilidade de inferência sobre duas coisas:

- o **formato das provas** — formato de enunciado, distribuição de dificuldade, tipos de questão
  preferidos;
- os **KCs construídos nas questões já montadas** — as provas passadas também alimentam a Q-matrix.

O efeito: as atividades novas podem **se moldar ao formato das provas passadas** do próprio
professor. O acionamento é **uma via opcional do professor na criação da prova** (opt-in), não
automático. O parâmetro `N_min_calibracao_professor` (§3) define o volume mínimo de provas antigas
para a inferência ser estatisticamente confiável — a definir. Até lá, os priors de dificuldade são
heurísticos, não calibrados por professor.

**Implicação para a Q-matrix:** com o Modo B, as provas antigas viram uma **terceira fonte de dado**
para a Q-matrix, ao lado de (1) o tagging na geração de questões novas e (2) a inferência de KCs
sobre o material didático no upload da Biblioteca. É dado retroativo: o histórico do professor passa
a alimentar o grafo de KCs antes mesmo da primeira prova gerada na Lucida — encurtando o caminho até
`N_min_observacoes_kc` (§5) para professores que chegam com acervo.

---

### 8.7 O que o ADR-0012 decidiu (Fase 0→1)

Diferente do resto da §8, isto **não** é proposta: é decisão registrada (status `proposto`, aguardando
merge), e supera o que estiver em conflito acima. Quatro pontos:

1. **Identidade de instância** — `Question`/`QuestionDoc` ganham `questionId` (id-string custom, criado
   na geração). O `Exam` **continua** agregado raiz e dono do array ordenado de snapshots imutáveis.
2. **Registro Q-matrix separado** — novo domínio `learning-object`, coleção `learning_objects`, um doc
   por `questionId`, escopado por `ownerId` + `organizationId`, com `kc[]` (nunca vazio),
   `kc_status` (`not_validated` → `validated` numa ação única do professor, espelhando o
   `ai_suggested → approved` da correção de abertas), `family_id`, `nivel_cognitivo` (Bloom para
   objetiva, SOLO para discursiva) e `distrator_diagnostico` (só objetivas).
3. **Resposta por KC** — a `Submission` passa a carregar o `questionId` de cada resposta, **além** do
   índice posicional, que permanece para não quebrar OMR, impressão e correção. A série temporal por
   KC é a junção `resposta → questionId → learning_object.kc/family_id`.
4. **Escopo fechado na Fase 0→1.** Entrega identidade + modelo de dado + persistência da resposta por
   KC. **Não** decide BKT, `p(domínio)`, feedback de Hattie, IDEB por KC nem área do aluno — só cria a
   fundação que esses consomem.

A razão de a metadata pedagógica viver **fora** do `Exam`: ela é mutável, e o `Exam` é registro de
avaliação **imutável**. Se corrigir o mapeamento de KC de uma questão alterasse provas já aplicadas, a
nota do aluno mudaria retroativamente — inaceitável.

## 9. Referências (para due diligence técnica)

Corbett & Anderson (1995) · Yudelson et al. (2013) · Baker et al. (2008) · Pavlik et al. (2009) ·
Tatsuoka (1983) · de la Torre (2011) · Junker & Sijtsma (2001) · Rupp, Templin & Henson (2010) ·
Embretson & Reise (2000) · Lord (1980) · van der Linden & Hambleton (1997) · Piech et al. (2015) ·
Zhang et al. (2017) · Yeung (2019) · Krathwohl (2002) · Biggs & Collis (1982) · Cepeda et al. (2008) ·
Roediger & Karpicke (2006) · Black & Wiliam (1998, 2009) · Shute (2008) · Shute & Rahimi (2017) ·
Hattie & Timperley (2007).
