---
name: lucida-docs
description: Como escrever na base de conhecimento da Lucida (lucida-mind e os segundos cérebros dos outros projetos do ecossistema). Define o leitor (humano, não agente), o corte entre fato e processo de descoberta, o frontmatter obrigatório, a regra do última_revisão, links relativos entre docs, e a fronteira entre a metade verificável no código e a metade de negócio. Carregue ao criar ou editar qualquer .md da base — inclusive ao promover rascunho, corrigir defasagem ou responder ao check-drift.sh.
---

# Escrever na base de conhecimento da Lucida

A base é lida **por pessoas**, quase nunca por agentes. Founder abrindo antes de uma call, dev novo
tentando entender billing, alguém montando um pitch. Escreva para eles.

## O corte que mais importa: fato, não descoberta

Registre **o que é verdade**. Não registre como você descobriu, o que verificou, contra o que
comparou, nem em que data conferiu.

| Não |  Sim |
|---|---|
| "Conferido 1:1 contra o disco em 2026-08-25, são 27 domínios" | "27 bounded contexts" |
| "A afirmação vem do arquivo X, que não é editado desde maio, então pode estar velha" | "É o estado de mai/2026 — cheque antes de repetir" |
| "Sem número de linha de propósito: o composition root cresce a cada feature" | "Procure pelo símbolo, não pela linha" |
| "Esta seção foi reescrita na revisão de ago/2026 porque o rascunho contradizia o código" | (nada — só o fato certo) |

A data de conferência já vive no `última_revisão`. Repeti-la no corpo é ruído.

**A exceção é quando a idade do fato muda a decisão de quem lê.** "Números de jun/2026" antes de uma
tabela de tração é informação; "não reverificado na revisão de 2026-08-25" é processo. Uma linha,
nunca um parágrafo.

## Tom

Direto e corrido. Frase curta, voz ativa, sem preâmbulo e sem fecho.

- Sem hedge defensivo. "Não existe" > "aparentemente ainda não foi implementado".
- Sem jargão quando há palavra comum. "Carteira de créditos" > "wallet aggregate".
- Termo técnico em inglês fica em inglês (`securityLevel`, `ExamSchedule`) — é o nome real no código.
  O resto é português.
- Negrito para o que o leitor precisa levar embora, não para dar ênfase a esmo.
- Tabela quando são fatos paralelos. Prosa quando há causa e consequência.
- Se a explicação ficou maior que o fato, corte a explicação.

## Estrutura de um doc

```markdown
---
quando_usar: <em que situação abrir este doc — é o que vai para o INDEX.md>
última_revisão: AAAA-MM-DD
status: canônico
tags: [billing, instituicao]   # opcional
---

# Título

Uma ou duas frases dizendo o que é. Sem "este documento descreve".

## Seções curtas, com o fato mais importante primeiro
```

`status`: `canônico` (vale hoje), `parcial` (tem lacuna declarada), `rascunho` (não aprovado).

`tags` é opcional e existe para o grafo do Obsidian: cada tag vira um nó que liga docs de pastas
diferentes. **Só tagueie o doc que é substancialmente sobre o assunto** — que tem seção dedicada a
ele, não que o menciona de passagem. Medido nesta base: `ia` é mencionado em 38 dos 38 docs e
`assinatura` em 29 — taguear por menção ligaria quase tudo a quase tudo e destruiria o grafo. As nove
em uso, com 3 a 8 docs cada: `billing`, `instituicao`, `moat`, `analytics`, `ia`, `correcao`,
`biblioteca`, `omr`, `classroom`. Tag nova só se separar um grupo real de 3+ docs.

**`última_revisão` é quando o doc foi conferido, não quando foi escrito.** Corrigiu um fato? Suba.
Não conferiu? Não suba — data falsa é pior que data velha.

## Onde o doc mora: `rascunhos/` ou a raiz

**Quem decide não é o `status:` do frontmatter, é a pasta.** Doc que ninguém do time validou vive em
`rascunhos/`, espelhando a estrutura da base:

```
rascunhos/negocio/metricas.md   ← não validado
negocio/monetizacao-creditos.md ← canônico
```

Assim dá para ver o estado de tudo num `ls`, sem abrir arquivo por arquivo. Promover é `git mv`
preservando o caminho, mais os ajustes de índice e frontmatter — a receita inteira está em
[rascunhos/LEIA-ME.md](../../../rascunhos/LEIA-ME.md), e o caminho de volta também.

**Você não promove nada.** Tirar um doc de `rascunhos/` exige alguém do time confirmar o conteúdo;
número de negócio pede fonte real. Escreveu conteúdo não validado? Nasce em `rascunhos/`. Na dúvida
sobre se algo foi validado, trate como não validado — foi assim que oito docs subiram a canônico sem
revisão nesta base.

## Links

Referência a outro doc é **link markdown relativo**, sempre:

```markdown
Detalhe em [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).
```

Caminho cru (`tecnico/billing-ledger.md` solto no texto) não navega. Arquivo na raiz linka sem `../`.
O texto do link é o caminho **a partir da raiz**; o alvo é relativo ao arquivo. Os dois divergem, e é
de propósito.

Doc novo entra em **dois** lugares: no [`INDEX.md`](../../../INDEX.md) e no `mapa-*` da sua área
(`tecnico/mapa-tecnico.md`, `negocio/mapa-do-negocio.md`…). Doc fora do índice é doc invisível; doc
fora do mapa não aparece na ordem de leitura de quem está chegando.

**Exceção: pasta com nota-índice.** `produto/decisoes/` tem 22 notas e nenhuma delas está no
`INDEX.md` — quem entra no índice é [`produto/decisoes-de-produto.md`](../../../produto/decisoes-de-produto.md),
que lista todas com uma linha cada. Decisão nova vira uma nota na pasta **e** uma linha na tabela
desse índice. A regra real é "nenhum doc é inalcançável", não "todo doc no INDEX.md".

**Nunca `[[wikilink]]`.** A base é um vault do Obsidian e o Obsidian resolve link markdown relativo
sem ajuda nenhuma — mas o validador do `check-drift.sh` só enxerga link markdown, e dois arquivos de mesmo
nome (`icp-beachhead.md` existe em `negocio/` e em `rascunhos/negocio/`) ficariam ambíguos. O
`.obsidian/app.json` já força `useMarkdownLinks`, então o autocomplete do editor sai no formato certo.

**Gotcha ao renomear ou mover dentro do Obsidian:** com `alwaysUpdateLinks`, ele reescreve o **alvo**
de todo link que apontava para o arquivo — mas não o **texto**. Depois de um `git mv` promovendo
rascunho, os textos ainda dizem `rascunhos/…` e precisam ser corrigidos à mão.

## As duas metades da base

**Verificável no código** (`tecnico/`, `produto/`, `ui/`, `regras/codigo.md`): o código é a fonte
primária. Divergiu, o doc está velho. Boa parte é conferida pelo `check-drift.sh` — mas ele só
alcança contagem, enum e tabela. Gotcha, invariante e o porquê de uma decisão são revisão humana.

**Contexto de negócio** (`rascunhos/negocio/`, `rascunhos/regras/pitch.md`): não tem fonte no
repositório e nenhum script alcança. Marque o vintage numa linha no topo.

O corte não é por pasta, é por afirmação. `negocio/monetizacao-creditos.md` é canônico e misto: preço
dos planos, créditos por ciclo e o kill-switch do PIX saem do código e o `check-drift.sh` confere; o
contrato institucional negociado fora do sistema é negócio puro. Rode o detector também nos docs de
negócio — parte deles ele alcança.

Nunca misture as duas numa afirmação só. "O plano institucional custa R$ 374,25" é falso se o produto
não tem esse SKU — o certo é dizer o preço **e** que ele é negociado fora do sistema.

## Erros que já aconteceram aqui

- **Promover rascunho por cima do canônico.** Rascunho pode ser mais velho que o doc que substitui.
  Mescle, não sobrescreva: em 2026-08 dois rascunhos diziam que o top-up saía por PIX (desligado por
  kill-switch) e teriam apagado Biblioteca e Calendário do doc de suíte.
- **Concluir por busca que falhou.** Um `grep` que não retorna nada pode ser um `grep` quebrado. Uma
  env lida de `process.env` não aparece procurando no `env.ts`. Confirme pelo positivo antes de
  escrever "não existe".
- **Número de linha em referência a código.** `main.ts:1479` fura em uma semana. Cite o símbolo.
- **Descrever o plano como se fosse a entrega.** Se o doc é fundamento ou roadmap e nada dele existe
  em código, diga isso na primeira linha.
