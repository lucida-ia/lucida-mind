---
quando_usar: consultar o schema proposto do objeto de aprendizagem (Q-matrix), as regras de feedback e o que o ADR-0012 decidiu
última_revisão: 2026-08-25
status: canônico
tags: [moat]
---

# Objeto de aprendizagem — comportamento proposto

O schema que amarra questão a Knowledge Component, as regras de feedback e as verificações de
qualidade que o pipeline deveria embutir. A última seção **não** é proposta: é o que o ADR-0012 já
decidiu.

> **Este doc é uma de três partes.** O fundamento científico está em
> [produto/motor-assertividade.md](motor-assertividade.md); os parâmetros e a escada de
> maturidade, em [produto/maturidade-do-motor.md](maturidade-do-motor.md); o objeto proposto,
> em [produto/objeto-de-aprendizagem.md](objeto-de-aprendizagem.md). **Nada disto existe em código.**

---

> **Enquadramento:** derivado da skill operacional "Objeto de Aprendizagem" (a skill em si vive fora
> desta base, no repo de skills do agente — aqui só o conhecimento de produto). Descreve como o
> produto **possivelmente** deve se comportar segundo a instrução construída na skill. **Não é
> decisão canônica**: os itens do bloco `a definir` no topo permanecem pendentes de avaliação futura.

## Princípio central

"Cada questão é um objeto de aprendizagem" só é verdade se ela carregar identidade suficiente para
ser rastreável **entre provas diferentes**, não apenas dentro de uma prova. Sem essa estrutura, a
questão é evento isolado; com ela, cada resposta do aluno vira evidência dentro da trajetória de um
KC.

### O que "identidade" significa aqui — três conceitos, não um

O gerador **cria questões novas a cada prova**; ele não reusa o mesmo objeto-questão entre provas.
Isso é o que ninguém deduz do código, e confundir os três leva a modelagem errada:

- **`questionId`** — identidade da *instância*: uma ocorrência de questão numa prova. É o que permite
  atribuir a resposta a ela.
- **`family_id`** — chave de *agrupamento* das instâncias que testam o(s) mesmo(s) KC(s) entre provas.
  É o âncora longitudinal de verdade, e o gancho de deduplicação.
- **`kc[]`** — os códigos (BNCC ou provisórios) que a instância exercita.

"Dar identidade à questão" é, na prática, **dar `questionId` à instância + dar dono ao `family_id`**.

## Schema proposto do objeto

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

## Conceitos do schema

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
  extra para o professor (conecta com o princípio de amplitude, em [produto/maturidade-do-motor.md](maturidade-do-motor.md)). Se dois distratores mapeiam a
  mesma concepção, ou um não corresponde a erro plausível → sinal de baixa discriminação. Para
  discursivas, o equivalente é a rubrica/espelho por níveis SOLO.

## Regras propostas de feedback (Hattie & Timperley 2007)

Roteiro em até 3 níveis por exposição:
- **Tarefa** — o que estava certo/errado no resultado (sempre presente).
- **Processo** — qual passo do raciocínio falhou (obrigatório para discursivas e nível "aplicar"+).
- **Autorregulação** — pergunta que o aluno deveria ter se feito (só a partir da 2ª exposição ao
  mesmo KC).
- **Nunca** feedback de nível "self" (elogio/crítica pessoal) — o menos eficaz na literatura.

## Verificações de qualidade que o pipeline deve embutir

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

## Modo B — calibração por professor (complemento ao Modo A; possível feature futura)

O Modo B **não sobrepõe o Modo A** (estruturação) — é complemento. Quando o professor sobe **provas
antigas** na sua Biblioteca, abre-se a possibilidade de inferência sobre duas coisas:

- o **formato das provas** — formato de enunciado, distribuição de dificuldade, tipos de questão
  preferidos;
- os **KCs construídos nas questões já montadas** — as provas passadas também alimentam a Q-matrix.

O efeito: as atividades novas podem **se moldar ao formato das provas passadas** do próprio
professor. O acionamento é **uma via opcional do professor na criação da prova** (opt-in), não
automático. O parâmetro `N_min_calibracao_professor` (ver [produto/maturidade-do-motor.md](maturidade-do-motor.md)) define o volume mínimo de provas antigas
para a inferência ser estatisticamente confiável — a definir. Até lá, os priors de dificuldade são
heurísticos, não calibrados por professor.

**Implicação para a Q-matrix:** com o Modo B, as provas antigas viram uma **terceira fonte de dado**
para a Q-matrix, ao lado de (1) o tagging na geração de questões novas e (2) a inferência de KCs
sobre o material didático no upload da Biblioteca. É dado retroativo: o histórico do professor passa
a alimentar o grafo de KCs antes mesmo da primeira prova gerada na Lucida — encurtando o caminho até
`N_min_observacoes_kc` (ver [produto/maturidade-do-motor.md](maturidade-do-motor.md)) para professores que chegam com acervo.

---

## O que o ADR-0012 decidiu (Fase 0→1)

Diferente do resto deste doc, isto **não** é proposta: é decisão registrada (status `proposto`, aguardando
merge), e supera o que estiver em conflito acima. O resumo pela lente de produto está em
[produto/decisoes-de-produto.md](decisoes-de-produto.md). Quatro pontos:

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
