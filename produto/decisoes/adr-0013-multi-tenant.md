---
quando_usar: consultar o que o ADR-0013 decidiu sobre a instituição como nível 0 (org dona dos dados, do crédito e do cliente) e o que já está no código
última_revisão: 2026-10-22
status: canônico
tags: [instituicao]
---

# ADR-0013 — a instituição como nível 0

> Status `proposto`, mesclado na `staging` do `lucida-monorepo` em
> `docs/adr/0013-instituicao-como-nivel-0.md`. **As fases não foram executadas**; só os ajustes de
> segurança listados abaixo estão no código.

A instituição **é** o `organization` do BetterAuth, sem entidade nova, e é a raiz: dona dos dados,
do crédito e da relação de cliente. Professor e aluno são usuários dentro da org. Substitui o rascunho
multi-tenant anterior (o antigo "ADR-0010"/issue #11), que nunca foi aceito.

## O que decide

| Tema | Decisão |
|---|---|
| Org de todo professor | Toda conta de professor ganha uma org solo, nome default **"Minha sala de aula"**, criada pelo servidor **no fim do onboarding** |
| Solo vs. instituição | Org com 1 professor vinculado é "solo"; com mais de 1, "instituição". O upsell "Instituição" expande a mesma org |
| Dono dos dados | **A org.** Quem sai não leva turmas, alunos, respostas, planos nem agendamentos |
| `organizationId` | Obrigatório em todo dado de negócio, gravado a partir do escopo validado |
| Papéis | `owner`, `admin`, `secretary`, `teacher`, um por org; auxiliar convive com secretário |
| Crédito | **Pool único da org**; o solo é um pool de 1. Cota por professor só com mais de 1 professor |
| Direito a recurso pago | Vem do **plano** contratado, não de ter org. Meu Estilo exige assinatura individual; painel, API, comunicados e convite exigem plano Instituição |
| Turmas antigas | O professor **escolhe** quais turmas da org solo leva para a escola, e a escola aceita ou recusa cada uma |
| Aluno | A conta se liga ao registro da turma **só pelo aceite do convite**; a reivindicação por e-mail verificado sai (decisão 14, issue #213) |
| Hierarquia de orgs | Fora do escopo: "rede de escolas não existe neste modelo" |

O ADR supera em parte o ADR-0018 (Meu Estilo passa a ser um perfil por professor por org), o
ADR-0014 (log de atividade) e o ADR-0019 (Área do Aluno, no vínculo por e-mail).

## O que já está no código

- O cliente **não cria nem apaga** organização (`allowUserToCreateOrganization: false`,
  `disableOrganizationDeletion: true`). Org só nasce pelo Kintal (`create-institution`).
- O cliente só atribui os papéis `member` e `admin`; `owner` não é atribuível.

## O que ainda não está

- Org solo por professor: não existe. `organizationId` continua **nulo por padrão** nos dados.
- Direito por plano: a `SubscriberAccessPolicy` ainda libera Biblioteca, Calendário e Meu Estilo
  para quem tem **org ativa**. Não há política de direito por plano.
- Pool único: welcome credits e consumo do professor solo seguem na **carteira pessoal**.
- Papéis `secretary` e `teacher`: não configurados.
- Vínculo do aluno só por convite: a varredura por e-mail (`claimUnlinkedByEmail`) continua.

## Divergência com a decisão dos sócios

Os sócios decidiram em 2026-10-22 que existe um **hub acima da instituição** — visão agregada, só
leitura, sem ação sobre as orgs. Isso contradiz o "hierarquia de orgs fora do escopo" do ADR, que
precisa ser revisto lá. Ver [produto/decisoes/hub-de-instituicoes.md](hub-de-instituicoes.md).

Como a instituição funciona hoje está em [tecnico/dominios.md](../../tecnico/dominios.md) (domínio
`iam`) e [regras/produto.md](../../regras/produto.md).
