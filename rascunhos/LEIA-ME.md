# Rascunhos

Doc que ainda **não foi validado por ninguém do time**. A pasta é a fonte da verdade sobre isso: se
o arquivo está aqui, não vale como fato da Lucida — não importa o que o texto dele afirme.

A pasta espelha a estrutura da base, então promover é um `git mv` sem renomear:

```
rascunhos/negocio/metricas.md   →   negocio/metricas.md
```

## Como promover

1. Alguém do time confirma o conteúdo. Números de negócio pedem uma fonte real (Stripe, o painel do
   Kintal, o que estiver valendo); estratégia pede aceite explícito de quem decide.
2. `git mv rascunhos/<secao>/<arquivo>.md <secao>/<arquivo>.md`
3. Ajuste `última_revisão` e o `status`: vira `canônico`, ou continua `parcial` se sobrou lacuna
   declarada no próprio doc — é o caso de `produto/roadmap.md`, que tem seções conferidas no código
   e outras que são proposta.
4. Mova a linha do [`INDEX.md`](../INDEX.md) da seção "Rascunhos" para a seção da área.
5. Tire o aviso de "não validado" do topo do arquivo.

O caminho contrário também vale: doc canônico que se descobre não confiável volta para cá, em vez de
ficar mentindo com ar de verdade.

## O que tem aqui hoje

Oito docs de contexto de negócio de jun/2026 — tração, preço institucional, ICP, canais,
concorrência, moat, roadmap e narrativas de pitch. Nenhum tem fonte no repositório, então nem o
`check-drift.sh` alcança: só uma pessoa pode validá-los.

O `produto/motor-assertividade.md` saiu daqui em jul/2026, depois de revisado — é o precedente de
como isto funciona.

## Por que não ficam soltos no canônico com um aviso

Já foi tentado nesta sessão, com `status:` no frontmatter. Não serve: obriga a abrir arquivo por
arquivo para saber em que pé está cada um. Pasta filtra de imediato, no `ls` e no GitHub.
