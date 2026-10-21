---
quando_usar: discutir o posicionamento da Lucida como camada de jornada e evidência de aprendizagem (School e Creators), o cenário competitivo dessa arena e o canal de aquisição via Unifast
última_revisão: 2026-10-21
status: rascunho
tags: [moat, instituicao]
---

# Estratégia — jornada de aprendizagem e canal Unifast

> **Rascunho — nunca validado.** Análise de out/2026. Os números da Unifast vêm das apresentações
> da Convenção 2027 (Dia 1 e Dia 2), não de fonte auditada. Concorrentes citados são hipótese de
> mercado: cheque antes de repetir.

A Lucida deixa de competir em ferramental (gerar prova, plano de aula) e passa a ser a **camada que
desenha a jornada de aprendizagem e produz evidência do que o aluno aprendeu**, para escola, IES e
expert. Em paralelo ao movimento direto, a parceria com a Unifast vira canal de aquisição para o
lado informal (Creators) e para a formalização (School).

## O novo posicionamento, em uma frase

**Lucida transforma o material de quem ensina numa jornada de atividades contínuas e devolve, por
competência, a evidência do que cada aluno de fato aprendeu.**

| | Lucida School | Lucida Creators |
|---|---|---|
| Quem | Escola (pública ou privada), IES, pós/MBA — todo processo formal | Expert, infoprodutor, club, mentoria, in-company |
| Espinha dos KCs | BNCC na educação básica; matriz curricular/PPC no superior | KC provisório, derivado do material do expert |
| O que a instituição compra | Permanência e progressão do aluno, índices acadêmicos, evidência para certificação | Engajamento contínuo, prova de resultado, caminho para formalizar |
| Canal principal | Direto (redes, grupos educacionais) + IES via Unifast | Unifast (Discovery → licença Campuzz) + entrada pela ferramenta |

Base comum às duas: todo professor é uma instituição de 1; a geração de IA roda no **LuAS**, que
devolve o resultado à conta Lucida vinculada; a área do aluno permite avaliação fora do período
avaliativo; o estilo de prova do professor é inferido das provas que ele já validou.

### O que a promessa pode e não pode dizer

- **Pode:** a Lucida **mede e sustenta** a aprendizagem — estima domínio por competência a partir de
  atividades distribuídas no tempo e mostra onde o aluno travou.
- **Não pode (ainda):** "garante a aprendizagem" ou "valida matematicamente". O motor dá estimativa
  probabilística (BKT), confiável só a partir de ≥4 observações por KC — ver
  [produto/maturidade-do-motor.md](../../produto/maturidade-do-motor.md). E **nada do motor existe
  em código**.
- **Hipótese de longo prazo:** prever desempenho no mercado de trabalho exige dado de desfecho
  (empregabilidade, avaliação de empregador) que a Lucida não captura. É roadmap condicionado a
  parceiro de dado, não argumento de venda.
- **Hipótese a provar:** "aluno de alta performance permanece e melhora os índices da escola". A
  relação permanência ↔ desempenho é plausível; a contribuição causal da Lucida precisa de piloto com
  medição antes e depois.

## Diagnóstico

O diferencial que o novo posicionamento vende — evidência longitudinal por competência — **é
justamente a parte que não está construída**. O que está construído (gerar prova do material,
corrigir, item analysis por prova) é a parte que LLMs e big tech já comoditizaram (ver
[rascunhos/negocio/competidores.md](competidores.md)).

O motor só vira diferencial com **densidade**: muitos alunos, ≥4 exposições por KC, ao longo do
tempo. A base própria é pequena (flywheel "projetado, mas parado", em
[rascunhos/negocio/moat-flywheel.md](moat-flywheel.md)). A Unifast resolve a densidade — meta de 100
edtechs até set/27, mais de 120 mil alunos certificados declarados — mas concentra poder de
comprador num único parceiro, que tem plataforma própria (Campuzz) e poderia internalizar a camada.

**O desafio central:** converter a distribuição da Unifast em densidade de dado por KC, rápido o
bastante para que a camada de evidência fique mais valiosa dentro da Lucida do que qualquer versão
que o Campuzz construa sozinho — e sem prometer ao mercado o que o motor ainda não mede.

## Análise da arena

### Cinco forças (arena: jornada e evidência de aprendizagem no Brasil)

| Força | Intensidade | Por quê |
|---|---|---|
| Rivalidade | **Alta** em ferramental, **baixa** em evidência por competência | Gerar prova/quiz tem dezenas de players; medir domínio longitudinal atravessando formal e informal, quase ninguém em PT-BR |
| Novos entrantes | **Alta** em geração, **média-baixa** em evidência | Geração é chamada de LLM; evidência exige dado longitudinal, integração e confiança institucional |
| Substitutos | **Alta** | Prova própria do professor, quiz nativo do LMS ou da área de membros, Google Forms, NotebookLM |
| Poder do comprador | **Alto** no canal (Unifast, Eduzz), **médio** em redes, **baixo** no expert avulso | Canal concentrado e com plataforma própria: ameaça real de integração para trás |
| Poder do fornecedor | **Médio** | Provedor de LLM (hoje OpenAI) — o LuAS abstrai e permite trocar; o canal também é "fornecedor" de distribuição |

**Leitura:** a arena é pouco atraente na camada de ferramental e atraente na de evidência, desde que
a Lucida chegue lá com dado antes de o canal ou a big tech fecharem o gap.

### Quem disputa o mesmo trabalho

| Tipo | Exemplos (hipótese — conferir) | Onde ganham | Onde a Lucida difere |
|---|---|---|---|
| Ferramental de IA para professor | MagicSchool, Teachy, NotebookLM, Gemini/Copilot | Distribuição, preço zero | A Lucida sai dessa briga |
| LMS / área de membros | Moodle, Canvas, Google Classroom; áreas de membros das plataformas de infoproduto (inclusive a da Eduzz) | Já têm o aluno e o conteúdo | A Lucida não entrega conteúdo — **embute-se** no LMS (decisão Unifast: embutida no Campuzz) |
| Aprendizagem adaptativa | Plataformas adaptativas de sistemas de ensino da educação básica; Khanmigo | Conteúdo próprio + adaptatividade | A Lucida parte do **material de quem ensina**, não de conteúdo próprio, e cobre o informal |
| Correção/avaliação | Gradescope, ZipGrade, Lize | Correção em escala | Correção é insumo; o produto é a trajetória por KC |
| Credencial digital | Plataformas de badge/microcredencial | Emitir e verificar certificado | A Lucida é **complementar**: anexa evidência de domínio ao certificado, não emite |

### Canvas de valor (o que muda em relação aos rivais)

| Fator | Movimento |
|---|---|
| Ferramental de geração (prova, plano, slide) | **Reduzir** — vira meio, roda no LuAS |
| Entrega de conteúdo / LMS | **Eliminar** — fica com o parceiro |
| Preço por professor | **Eliminar** no canal — trocar por preço por aluno ativo ou embutido na licença |
| Avaliação fora do período avaliativo | **Elevar** — área do aluno com atividade contínua |
| Jornada desenhada a partir do material de quem ensina | **Criar** |
| Evidência de domínio por competência anexada à certificação | **Criar** |
| Continuidade do histórico do informal ao formal (Creators → School) | **Criar** |

### SWOT

| Forças | Fraquezas |
|---|---|
| Geração e correção (inclusive discursiva com rubrica) prontas; API pública com geração assíncrona e webhook; fundamento científico do motor documentado; um produto que cobre formal e informal | Motor de evidência não existe em código (Fase 0); área do aluno e identidade persistente ainda em construção; base pagante pequena; time pequeno para dois movimentos |
| **Oportunidades** | **Ameaças** |
| Unifast como canal com densidade; IES parceiras dela como porta do School; Eduzz (sócia da Unifast) como topo de funil de infoprodutores; demanda por evidência de aprendizagem no EAD | Campuzz internalizar a camada; conflito com a área de membros da Eduzz; big tech fechar o gap em PT-BR; dependência de um canal; overclaim queimar credibilidade com IES |

## Estratégia

### Política-guia

**Ser a camada de evidência de aprendizagem embutida onde o aluno já está, entrando primeiro pelo
canal Unifast — onde formal e informal convivem e o volume existe — e só vender o que o motor já
mede.**

Escolhas explícitas (*onde jogar / como ganhar*):

- **Onde jogar:** Creators via Unifast primeiro (volume e ciclo curto); School via IES da Unifast
  como caso de referência; escolas da educação básica pelo movimento direto, sem desviar o time.
- **Como ganhar:** dado longitudinal por KC que atravessa tenants (expert, edtech, IES, escola) — o
  que nenhum parceiro sozinho tem, porque cada um enxerga só os próprios alunos.
- **Onde não jogar:** LMS, entrega de conteúdo, ferramental de criação como produto.

### Ações coerentes

| # | Ação | Por que reforça as outras | Dono | Quando |
|---|---|---|---|---|
| 1 | **Levar a Fase 1 ao `main`**: ADR-0012 (questão rastreável, `learning_object`) + área do aluno com identidade persistente | Sem isso o canal gera volume, mas não dado por KC — a ação 3 vira só revenda de ferramental | Produto + engenharia | Q4/26 – Q1/27 |
| 2 | **Contrato com a Unifast antes do piloto**: dado agregado/anonimizado de calibração fica com a Lucida; portabilidade quando o expert sai; hub vê agregado por padrão; indicação nos dois sentidos | Protege o efeito de rede que as ações 3 e 5 constroem | Founders | Antes do piloto |
| 3 | **Diagnóstico concierge nos próximos Discovery** (raio-x de aprendizagem como material de venda) e **piloto embutido no Campuzz** com 2–3 edtechs no Creators | Gera o primeiro dado por KC e valida a disposição a pagar | Founders + CS | Nov/26 – Q1/27 |
| 4 | **Preço do canal por aluno ativo**, embutido no bundle do licenciamento; geração do LuAS como consumo | Alinha a Lucida ao revenue share da Unifast e remove a fricção por professor | Founders | Junto com o contrato |
| 5 | **Caso de referência School**: um programa de pós via IES da Unifast com histórico de competências anexado ao certificado | Prova o argumento "complementar à certificação" com um caso real; vitrine no FASTVAL (mai/27) | Produto + Unifast | Q2/27 |

As ações se encadeiam: (1) torna o dado possível, (2) garante que ele fique na Lucida, (3) gera o
volume, (4) remove a fricção de entrada, (5) transforma o dado num argumento de venda para IES e
escolas — que realimenta o movimento direto do School.

## Fluxo paralelo — o canal de aquisição Unifast

O canal roda ao lado do movimento direto, com três portas de entrada e um retorno.

```
                ┌──────────── Eduzz · MLS · mar aberto ────────────┐
                ▼                                                  │
  [1] Discovery mensal (evento Unifast)                            │
        │                                                          │
        ▼                                                          │
  [2] Diagnóstico ── raio-x de aprendizagem Lucida (material de venda)
        │
        ▼
  [3] Licença Campuzz ── Lucida Creators embutida no bundle
        │                  (modelagem da jornada: Lucida + BPO educacional Unifast)
        ▼
  [4] Acompanhamento ── indicadores por KC no Partnerbook (check-in de 15 em 15 dias)
        │
        ▼
  [5] Promoção (> R$ 1 mi/ano) ── formalização → Lucida School
        │                          (evidência anexada ao certificado da IES)
        ▼
  Hub Unifast ── visão agregada das edtechs que usam Lucida

  Porta paralela: expert entra direto pela ferramenta (Creators)
        └─► sinal de prontidão para formalizar ──► indicação à Unifast (retorno)
```

**As três portas:**

1. **Pelo funil da Unifast** (principal): o raio-x de aprendizagem entra no Diagnóstico como
   material de venda, sem virar critério de seleção. Quem assina a licença já recebe a conta
   Creators configurada com o mapa de KCs e o estilo inferido.
2. **Pela ferramenta**: o expert chega ao Creators sozinho. Quando o mapa de KCs e o volume mostram
   que o curso sustenta formalização, a Lucida indica o expert à Unifast. **O canal é de mão dupla** —
   a Lucida também gera lead para a Unifast, o que dá base para negociar comissão de indicação.
3. **Pela IES parceira da Unifast**: o caso School (ação 5) abre conversa direta com a IES, que pode
   levar a Lucida a outros programas dela, fora da esteira da Unifast.

**Quem opera a modelagem da jornada:** Lucida e o BPO educacional da Unifast juntos, como plano
complementar para o expert que entra na esteira. A implementação se adapta ao material do expert —
não há matriz imposta pela IES nem formato único.

**Ritmo do canal** (rampa da Unifast, ainda "proposta para a liderança fechar"): 30 edtechs em
dez/26, 45 em mar/27, 70 em mai/27 (FASTVAL), 100 em set/27. A receita da Lucida no canal é
`edtechs ativas × alunos ativos por edtech × preço por aluno` — **alunos por edtech e preço são
incógnitas**; perguntar à Unifast antes de projetar.

### Métricas do canal

| Métrica | O que diz |
|---|---|
| Conversão Discovery → licença, com e sem raio-x | Se o diagnóstico vende |
| % de edtechs do hub que usam Lucida | Penetração no canal |
| Alunos com ≥4 exposições por KC | Se o volume vira dado (o que importa para o moat) |
| % de KCs com estimativa "Confiável" | Maturidade do dado por edtech |
| Atividade do aluno fora do período avaliativo | Se a área do aluno engaja |
| Indicações Lucida → Unifast | Se a porta da ferramenta funciona |
| Churn de edtech com e sem Lucida | Valor retido pelo hub |

## Riscos

| Risco | Mitigação |
|---|---|
| Campuzz internaliza a camada de avaliação | Contrato (ação 2); dado que atravessa tenants, que o Campuzz sozinho não tem; velocidade da ação 1 |
| Conflito com a área de membros da Eduzz, sócia da Unifast | Posicionar como camada embutida, não como LMS concorrente; levantar o tema na negociação |
| Dependência de um canal | Manter o movimento direto do School na educação básica; porta da ferramenta no Creators |
| Overclaim ("garante", "valida matematicamente") queima credibilidade com IES | Vender "mede e sustenta"; selo "Confiável/Direcional" sempre visível |
| Canal gera volume antes de o motor existir (receita de ferramental, sem dado) | Condicionar o escopo do piloto à ação 1 |
| Projeção da Unifast não se confirma (meta de ~5× em um ano) | Nenhum investimento dedicado atrelado à rampa; escalar pelo que o piloto mostrar |
| LGPD com dado de aluno visto pelo hub | Hub vê agregado por padrão; controlador definido em contrato |

## Premissas a validar

- A Unifast aceita que o dado agregado de calibração fique com a Lucida.
- O expert valida o mapa de KCs com fricção baixa (o padrão `not_validated → validated` funciona fora
  da sala de aula).
- Alunos adultos de curso livre fazem atividade fora do período avaliativo.
- A IES dá valor a histórico de competências anexado ao certificado.
- Alunos ativos por edtech e disposição a pagar por aluno.
