---
quando_usar: consultar o que o ADR-0013 decidiu sobre instituição multi-tenant e o aluno como usuário
última_revisão: 2026-08-25
status: canônico
tags: [instituicao]
---

# ADR-0013 — modelo multi-tenant de instituição

> Status `proposto`, em branch no `lucida-monorepo`. **Não implementado.**

A instituição **é** o `organization` do BetterAuth, não uma entidade nova; toda conta de professor
nasce com organização-padrão ("tenant de um"); `organizationId` vira **obrigatório**; papéis
`owner`/`admin`/`secretary`/`teacher`; e o aluno é usuário BetterAuth **só-por-convite**.

A migração professor→instituição é **opt-in e explícita**: aceitar convite de uma escola **não** expõe
as turmas pessoais do professor a ela.

Como a instituição funciona hoje está em [tecnico/dominios.md](../../tecnico/dominios.md) (domínio
`iam`) e [regras/produto.md](../../regras/produto.md).
