---
quando_usar: se orientar na área de UI — por onde começar e como os três docs se encadeiam
última_revisão: 2026-08-30
status: canônico
---

# Mapa da UI

Três docs, da marca até o componente na tela.

## Ordem de leitura

1. **[ui/identidade-visual.md](identidade-visual.md)** — a marca: paleta das três frentes, contraste,
   tipografia, logo, tom de voz. Vem de [negocio/posicionamento.md](../negocio/posicionamento.md), que
   decide quais são as frentes.
2. **[ui/design-tokens.md](design-tokens.md)** — a marca virada em CSS: tokens `@theme`, os dois theme
   switches e exatamente quais variáveis eles remapeiam, os primitivos shadcn disponíveis.
3. **[ui/modelo-de-ui.md](modelo-de-ui.md)** — como montar tela: Server Component por padrão, quando ir
   para Client, Server Action, a escada de decisão de estado, shadcn-first.

Cor e tipografia nunca se escolhem direto no componente: a decisão está no doc 1, o token no doc 2, o
uso no doc 3.

## Onde esta área encosta nas outras

- **A revisão de frontend** e os anti-padrões que o reviewer barra estão em
  [regras/codigo.md](../regras/codigo.md).
- **Idioma da interface é pt-BR e do código é inglês** — a regra e suas três exceções reais estão em
  [tecnico/convencoes-de-codigo.md](../tecnico/convencoes-de-codigo.md).
- **Copy** — como escrever o texto que vai na tela está em
  [regras/comunicacao.md](../regras/comunicacao.md).
- **O que a tela precisa fazer** (degradação graciosa, upsell, quem vê o quê) está em
  [regras/produto.md](../regras/produto.md).

---

Outras áreas: [negocio/mapa-do-negocio.md](../negocio/mapa-do-negocio.md) · [produto/mapa-do-produto.md](../produto/mapa-do-produto.md) · [tecnico/mapa-tecnico.md](../tecnico/mapa-tecnico.md) · [regras/mapa-das-regras.md](../regras/mapa-das-regras.md)
