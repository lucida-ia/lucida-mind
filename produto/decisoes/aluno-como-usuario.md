---
quando_usar: entender por que o aluno precisaria de identidade persistente e o que isso destrava
última_revisão: 2026-08-25
status: canônico
tags: [instituicao]
---

# Aluno como usuário

> Decisão de 2026-08-15, tomada junto com as outras da fundação do motor de assertividade —
> ver [produto/decisoes-de-produto.md](../decisoes-de-produto.md). **Nada disto existe em código.**

Para haver série histórica por aluno atravessando professores e turmas, o aluno precisa de identidade
persistente — hoje ele é registro de turma, não conta. Formalizado depois no ADR-0013 (só-por-convite),
em [produto/decisoes/adr-0013-multi-tenant.md](adr-0013-multi-tenant.md).

O acesso do aluno como é hoje está em [regras/produto.md](../../regras/produto.md); a frente de marca
do aluno, em [negocio/posicionamento.md](../../negocio/posicionamento.md).
