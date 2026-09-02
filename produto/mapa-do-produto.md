---
quando_usar: se orientar na área de produto — por onde começar e como os cinco docs se encadeiam
última_revisão: 2026-08-30
status: canônico
---

# Mapa do produto

Cinco docs, do que existe hoje ao que ainda é fundamento.

## Ordem de leitura

1. **[produto/suite.md](suite.md)** — o inventário do que o usuário toca: provas, correção, planos de
   aula, Biblioteca, Calendário, turmas, OMR, analytics, API pública, Kintal. Comece por aqui.
2. **[produto/glossario.md](glossario.md)** — o vocabulário. Exam, Submission, Rubric, OpenGrade,
   CreditWallet, SecurityLevel. Todo doc técnico usa esses nomes; sem ele o resto lê mal. Guarda também
   as armadilhas de nome — `Segment` e `EducationLevel` são enums diferentes.
3. **[produto/estilos-de-questao.md](estilos-de-questao.md)** — o detalhe da geração: tipos de questão,
   quatro estilos, dificuldade, três idiomas. O estilo muda texto **e** preço.
4. **[produto/decisoes-de-produto.md](decisoes-de-produto.md)** — o *porquê* de 22 decisões (rebrand,
   cubo de analytics, OMR, Classroom, Biblioteca, agendamento). É o índice de `produto/decisoes/`, com
   uma nota por decisão; leia a tabela e abra só a que interessa.
5. **O motor de assertividade**, em três docs. **Nada disso existe em código hoje** — é fundamento e
   proposta, não entrega:
   - [produto/motor-assertividade.md](motor-assertividade.md) — a tese de moat, a pilha científica
     (BKT, CDM, IRT) e as referências.
   - [produto/maturidade-do-motor.md](maturidade-do-motor.md) — os parâmetros, a escada de fases e os
     dois princípios que restringem o design da avaliação.
   - [produto/objeto-de-aprendizagem.md](objeto-de-aprendizagem.md) — o schema proposto da Q-matrix e
     o que o ADR-0012 decidiu.

## Onde esta área encosta nas outras

- **Cada módulo da suíte tem um domínio** em [tecnico/dominios.md](../tecnico/dominios.md) — é o mesmo
  mapa pela lente técnica.
- **Geração e correção** são [tecnico/ai-ops.md](../tecnico/ai-ops.md); o que cada ação custa está em
  [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).
- **O comportamento obrigatório** de cada módulo (degradação graciosa, quem acessa o quê, rubrica em
  questão aberta) está em [regras/produto.md](../regras/produto.md) — decisão é aqui, invariante é lá.
- **Por que o produto existe** está em [negocio/visao-geral.md](../negocio/visao-geral.md).

---

Outras áreas: [negocio/mapa-do-negocio.md](../negocio/mapa-do-negocio.md) · [tecnico/mapa-tecnico.md](../tecnico/mapa-tecnico.md) · [ui/mapa-da-ui.md](../ui/mapa-da-ui.md) · [regras/mapa-das-regras.md](../regras/mapa-das-regras.md)
