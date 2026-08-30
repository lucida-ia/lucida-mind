---
quando_usar: fundamentar o motor de assertividade (BKT/CDM/IRT), sustentar a tese de moat, consultar as referências científicas
última_revisão: 2026-08-25
status: canônico
tags: [moat]
---

# Base Científica do Moat e Parametrização do Motor de Assertividade

> **Propósito:** consolidar a fundamentação científica que sustenta a defensabilidade da Lucida **e**
> traduzi-la em parâmetros que o agente de produto usa para definir escopos de mudança no código —
> do estado atual da base de dados até o estágio capaz de inferir domínio por KC.
> **Nota de roteamento:** a *narrativa de moat* derivada daqui (para investidor) é subproduto e deve
> viver em `/negocio` ou alimentar o deck — estes docs são o **fundamento técnico**, não a peça de pitch.

> ⚠ **Artefatos referenciados ainda não definidos nesta base** (`a definir` — lacunas conhecidas,
> não convites a inventar):
> - **`family_id`** — mecanismo que amarra exposições do mesmo KC entre atividades (skill Objeto de
>   Aprendizagem). Sem doc na base.
> - **Skill "Objeto de Aprendizagem"** — referida como dona do schema da Q-matrix e do reporte de
>   concentração de itens. Sem doc na base.
> - **"Modo B (estilo)"** e **`N_min_calibracao_professor`** — calibração por provas antigas do
>   professor. Sem doc na base.

**KC**, **Q-matrix** e as entidades citadas aqui estão definidas em
[produto/glossario.md](glossario.md); os domínios que este doc propõe mexer, em
[tecnico/dominios.md](../tecnico/dominios.md).

> **Este doc é uma de três partes.** O fundamento científico está em
> [produto/motor-assertividade.md](motor-assertividade.md); os parâmetros e a escada de
> maturidade, em [produto/maturidade-do-motor.md](maturidade-do-motor.md); o objeto proposto,
> em [produto/objeto-de-aprendizagem.md](objeto-de-aprendizagem.md). **Nada disto existe em código.**

---

## A tese do moat em uma frase

O defensável não é gerar avaliação com qualidade (copiável por qualquer ferramenta). É a
**interoperabilidade entre o que avaliar, quando avaliar e como avaliar**, fechada com **outcome
medido** — gerando um data network effect que players digital-first não capturam. A ciência abaixo
é o que torna essa interoperabilidade implementável, não apenas retórica.

---

## A pilha científica (o que cada bloco resolve)

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

## Os cinco pontos de interoperabilidade (o moat, destrinchado)

Nenhum ponto isolado é defensável; cada um já existe em alguma ferramenta. O que ninguém tem junto:

1. **Feedback nivelado** (Hattie) escrito de volta num
2. **grafo de KC validado** (Q-matrix + BNCC), através de
3. **objetos rastreáveis longitudinalmente** (`family_id`), numa
4. **avaliação de dupla função** (somativa + formativa) sem fricção pro professor,
5. de forma **invisível** (orquestração inferida, não digitada).

O algoritmo é público; a orquestração fechada com dado proprietário é o moat.

---

## Referências (para due diligence técnica)

Corbett & Anderson (1995) · Yudelson et al. (2013) · Baker et al. (2008) · Pavlik et al. (2009) ·
Tatsuoka (1983) · de la Torre (2011) · Junker & Sijtsma (2001) · Rupp, Templin & Henson (2010) ·
Embretson & Reise (2000) · Lord (1980) · van der Linden & Hambleton (1997) · Piech et al. (2015) ·
Zhang et al. (2017) · Yeung (2019) · Krathwohl (2002) · Biggs & Collis (1982) · Cepeda et al. (2008) ·
Roediger & Karpicke (2006) · Black & Wiliam (1998, 2009) · Shute (2008) · Shute & Rahimi (2017) ·
Hattie & Timperley (2007).
