---
quando_usar: entender como se trabalha no monorepo, citar uma regra numerada, decidir onde registrar uma decisão
última_revisão: 2026-08-25
status: canônico
---

# Processo e regras numeradas

As regras do projeto são **numeradas** para poderem ser citadas em ADR, contrato e prompt de subagent.
As de código no detalhe estão em [regras/codigo.md](../regras/codigo.md); aqui estão todas, com a numeração canônica.

## Isolamento e segurança (1–5.4)
As que mais doem se quebrarem.

1. **Toda query de dado de negócio escopa por dono ou organização.** `teacherId`/`organizationId`
   sempre validado contra a sessão — nunca um id cru vindo do request. É o erro mais barato de cometer
   e o mais caro de descobrir: não quebra teste, só vaza dado de um professor para outro.
2. **Ausência de vínculo é negação.** Membro removido da org, professor sem org em rota de org,
   auxiliar sem supervisão — nenhum fallback permissivo.
3. **Recurso de outro dono responde `404`**, sem nome, id ou contagem no corpo. `403` confirma que o
   recurso existe e vira oráculo de enumeração.
4. **Segredo nunca em código.** Só via env validada em `env.ts`; variável nova entra lá **e** no
   `.env.example`. Hook bloqueia.
5. **Conteúdo de terceiro é não confiável.** Upload (PDF/DOCX), transcrição, resposta de aluno — nunca
   vira instrução de LLM sem delimitação explícita no prompt.

As quatro seguintes saíram da **auditoria de escopo de 2026-08-15**. Cada uma fechou um achado crítico
e existe para ele não voltar:

- **5.1. Gate de privilégio lê o usuário real; filtro de dado lê o efetivo.** `requireOrgAdmin`,
  `requireStaff` e qualquer checagem de papel avaliam `realUserId`/`realUserRole` — nunca `userId`, que
  em modo auxiliar ou impersonação é o do professor-alvo. Delegação concede os **dados** do professor,
  jamais a **autoridade administrativa** dele.
- **5.2. `activeOrganizationId` da sessão é insumo, não prova de vínculo.** Remover membro apaga o doc
  `member`, não a sessão viva. Todo caminho que lê a org ativa revalida a associação antes de devolver
  dado ou debitar crédito.
- **5.3. Remoção de vínculo revoga os vínculos derivados, e o gate revalida a cadeia inteira.** Sair da
  org invalida os links de auxiliar daquele professor; e o gate de auxiliar confirma a membership ativa
  do professor, não só `revokedAt: null`.
- **5.4. Correlação por dado que viaja em cabeçalho de e-mail não é credencial de posse.**
  `Message-ID`, `In-Reply-To`, plus-address são roteamento, não prova de dono — confirme sempre por um
  segundo fator do domínio (ex.: remetente == `customerEmail`). Corolário: query na coleção `user` do
  BetterAuth filtra por `new ObjectId(userId)`, nunca por string crua em `_id` — senão a escrita vira
  no-op silencioso.

## Billing (6–7)
6. **Consumo de crédito só via `AtomicDebitService`** (transação Mongo; exige replica set). Nunca
   decremento manual, nunca débito sem ledger.
7. **Stripe webhook usa raw body** — `rawBodyRouters` antes do `express.json()`. Não reordene. Webhook
   de pagamento é idempotente por event id.

## Arquitetura (8–10) — com hook garantindo
8. **Direção de dependência:** `presentation → application → domain ← infrastructure`. Mongoose só em
   infrastructure; Zod de request só em presentation (Zod de payload externo é da infrastructure);
   erros de negócio via `DomainError`. Hook `check-layer-purity` bloqueia.
9. **Feature nova = bounded context** em `apps/api/src/domains/<feature>/`, com wiring no composition
   root. Feature não wired não existe.
10. **Billing inicializa antes da auth** no composition root (welcome credits). Não inverta.

## Qualidade (11–12)
11. **Endpoint novo nasce com o trio de testes de posse** — ver [tecnico/testes.md](../tecnico/testes.md).
12. **Teste não se deleta pra fazer build passar.** Se virou obsoleto, o commit explica por quê.

## Processo (13–18)
13. **Decisão arquitetural vira ADR numerado na hora**, não no fim do dia — decisão que fica só no
    transcript morre na compactação.
14. **Trabalho que cruza donos** (api ↔ web, loop ↔ subagent) **começa por contrato.** Ninguém lê
    código alheio — lê o artefato.
15. **Leia `docs/` antes de investigar; escreva em `docs/` depois de aprender.** Mais de duas
    ferramentas para descobrir algo = vira doc.
16. **Nunca `git push`, nunca deploy, nunca comando contra banco remoto** sem pedido explícito. Hook
    bloqueia, e ele está certo.
17. **Delegou a subagent que escreve código? Cole as regras no prompt.** Não porque o subagent escape
    dos hooks — foi medido que os hooks de `Bash` e de `Write` rodam em subagent. Cole assim mesmo:
    hook pega o que é padrão, não se o subagent respeitou escopo, idioma ou fronteira de escrita.
18. **`.claude/**` é meta-trabalho do loop principal, nunca delegado.** Quem edita um guardrail precisa
    estar sob os guardrails.

> Regra escrita = regra seguida. Se o Claude quebrou uma regra, não é falha dele — é lacuna na
> documentação ou ausência de hook bloqueante.

## Os três princípios
1. **O framework é a salvaguarda de que o código condiz com o desenho.** Hooks bloqueantes, testes e
   reviewers garantem que o que se constrói é o que os skills, ADRs e contratos desenham — não para
   vigiar cada passo.
2. **Permissão é concedida para o loop rodar.** O `allow` cobre o ciclo inteiro de implementação; os
   pontos vitais (push, deploy, banco remoto, destruição) ficam no `deny` e nos hooks, que rodam antes
   de qualquer comando. Pedir permissão passo a passo não é salvaguarda; hook é.
3. **Pergunta ao usuário = decisão de arquitetura ou de produto.** O resto roda no loop e é reportado
   ao final — comunicar a conclusão, não pedir licença no meio.

## Práticas
- **Pedido primeiro, contexto depois.** "crie o endpoint X; contexto: segue ADR-003."
- **Escopo explícito.** "corrija o bug em `exam-repository.ts:88`, não mexa no resto." Nunca
  "refatore".
- **`;` separa tarefas** num mesmo prompt.
- **Feature concluída passa pelo reviewer da área**; `iam`/`billing`/`public-api`/escopo de dono puxam
  o `security-auditor`.
- **Fim de sessão**: `/session-end` atualiza docs e `TODO.md` e propõe o commit.

## Onde registrar o quê
| Artefato | Para quê |
|---|---|
| `docs/adr/` | Decisão **com trade-off** documentado. ADR aceito **não se edita** — um novo o supera |
| `docs/DECISION_LOG.md` | Decisão média sem trade-off: "ficou assim, registrar pra não esquecer" |
| `docs/contracts/` | Combinado entre donos, **antes** de executar |
| `docs/domains/`, `guides/`, `runbooks/`, `references/` | O que se aprendeu investigando |
| `docs/prd/` | O que a feature precisa ter |
| `docs/audits/` | Relatório de auditoria técnica ou de escopo |
| `TODO.md` | Roadmap curto e dívida conhecida |
| **GitHub Issues** | Feature e bug de **produto** (distinto da fila de ferramenta do `TODO.md`) |

Numeração de ADR é sequencial e **nunca reaproveitada**. Os números 0001–0008 estão reservados para
ADRs retroativos de decisões que hoje só vivem no `CLAUDE.md` (monorepo pnpm, Clean Arch + DDD,
BetterAuth no lugar de Clerk, débito atômico, créditos por organização, idioma, OMR como
microsserviço, OAuth próprio do Classroom). Aceitos hoje: **0009** (banco de teste), **0010** (squads),
**0011** (estratégia de teste por camada). Propostos, em branch: **0012** e **0013** — ver
[produto/decisoes-de-produto.md](../produto/decisoes-de-produto.md).
