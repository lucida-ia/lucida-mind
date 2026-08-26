---
quando_usar: saber que skill/agent/comando/hook existe no monorepo, escolher quem chamar, entender o que é bloqueado automaticamente
última_revisão: 2026-08-25
status: canônico
---

# O framework `.claude/` do monorepo

Inventário do que existe em `lucida-monorepo/.claude/`. As regras que ele aplica estão em
[regras/processo.md](../regras/processo.md) e [regras/codigo.md](../regras/codigo.md).

Um princípio explica o desenho: **permissão é concedida para o loop rodar**, e o que protege são os
hooks — que rodam antes de qualquer comando — não a aprovação passo a passo.

## Skills (4)
Auto-carregadas quando o contexto bate na descrição.

| Skill | Quando entra |
|---|---|
| `backend-clean-ddd` | Criar/editar feature, endpoint, entidade, repositório, use case ou rota em `apps/api` |
| `lucida-frontend` | Criar/editar componente, página, form ou estado em `apps/web` |
| `brand-lucida` | Qualquer trabalho visual — cores, tipografia, logo, marketing |
| `lucida-code-conventions` | Convenções transversais — idioma, comentários, clean code, naming |

> **Cuidado com o `backend-clean-ddd`**: o `references/folder-structure.md` dele descreve uma estrutura
> de pastas aninhada que **o código não segue**. O layout real é plano — ver [tecnico/arquitetura.md](../tecnico/arquitetura.md).

## Agents (9)
Dois grupos.

**Revisadores (3)** — não corrigem o que revisam; devolvem veredito estruturado com `file:line`.
Invocados sob demanda ao concluir uma tarefa.

| Agent | Quando invocar |
|---|---|
| `frontend-reviewer` | Ao concluir feature/página/componente/form em `apps/web` |
| `backend-reviewer` | Ao concluir feature/endpoint/use case/repositório/rota em `apps/api` |
| `security-auditor` | Ao concluir trabalho em `iam`, `billing`, `public-api` ou query escopada por dono/organização |

**Os três não são read-only.** Declaram `tools: Read, Grep, Glob, Bash` — sem `Write` e sem `Edit`, mas
`Bash` escreve arquivo por heredoc, `tee` ou `sed -i` sem passar pelos hooks do matcher
`Write|Edit|MultiEdit`. Nenhum deles se descreve como read-only de propósito: seria medir o rótulo em
vez da capacidade. A ausência de `Write`/`Edit` é **atrito na direção certa**; eles mantêm `Bash`
porque revisor sem `git diff` revisa só o que lhe mostraram.

**Especialistas (6)** — cada um com escopo fechado e artefato próprio.

| Agent | Modelo | Escopo |
|---|---|---|
| `tech-lead` | opus | ADRs, contratos, PRDs, decomposição em fases. Só escreve em `docs/` e `TODO.md` |
| `router` | haiku | Classificação de pedidos (via `/route`). Só lê |
| `devops` | sonnet | Dockerfiles, compose, `.github/`, ambiente de produção. Não executa — escreve o comando na resposta |
| `dba` | sonnet | Schemas Mongoose, índices, scripts de `apps/api/scripts/`. Propõe migração com plano de reversão; nunca lê o dump de produção |
| `qa-tester` | sonnet | Testes vitest/Playwright e fixtures. Não toca código de produção |
| `docs-writer` | sonnet | `docs/` (exceto adr/contracts), índices, `TODO.md`. Confirma que todo caminho citado existe |

A implementação continua no **loop principal** com os skills carregados — é onde os hooks rodam.

## Comandos (14)
| Comando | O que faz |
|---|---|
| `/route <pedido>` | Classifica e decompõe em tarefas com dono e dependência |
| `/flow-feature <feature>` | Contrato → backend → frontend → testes → revisão → docs, com parada por fase |
| `/flow-bugfix <bug>` | Reproduzir → teste que falha → causa → corrigir → verificar → registrar |
| `/flow-scope-audit [path]` | Varredura de isolamento entre professores/organizações |
| `/contract-new <feature>` | Rascunho de contrato via `tech-lead` |
| `/contract-review` | Revisa um contrato com os agentes escolhidos por caminho |
| `/grill-me <artefato>` | Interroga ADR/contrato/PRD procurando o buraco antes que vire bug |
| `/vote <decisão>` | Pareceres independentes de vários agentes (caro — só decisão cara de reverter) |
| `/review-pr` | Sessão de revisão de PR, isolada em worktree, um PR por sessão |
| `/session-end` | Fecha a sessão: diff, ADRs, docs, `TODO.md`, verificação, commit proposto |
| `/squad-review` | Revisores da área tocada, em paralelo |
| `/squad-quality` | `qa-tester` + reviewer da área |
| `/squad-platform` | `devops` + `dba` |
| `/squad-docs` | `docs-writer` + `tech-lead` |

Squad é comando que agrupa agentes (ADR-0010). **`allowed-tools` de um comando não limita o agente que
ele acorda** — o privilégio efetivo é a união dos `tools:` de todos eles.

Para mudança pequena, chame o agente ou o skill direto: um `flow` acorda vários agentes e cada um lê o
projeto do zero.

## Hooks (7 + biblioteca)
São o que realmente segura. Seis rodam em `PreToolUse` no matcher `Write|Edit|MultiEdit`, um no matcher
`Bash`, e um oitavo em `PostToolUse`.

| Hook | Matcher | Efeito |
|---|---|---|
| `check-layer-purity` | Write/Edit | **Bloqueia** import de infraestrutura em `domain/` ou `application/` |
| `check-code-language` | Write/Edit | **Bloqueia** identificador ou comentário em pt-BR no código |
| `check-secrets` | Write/Edit | **Bloqueia** segredo literal em código |
| `check-env-access` | Write/Edit | **Bloqueia** `process.env` cru fora de `env.ts` |
| `check-docs-pt-br` | Write/Edit | **Avisa** sobre doc em pt-BR sem acentuação |
| `check-claude-artifacts` | Write/Edit | Valida os próprios agents/skills/commands |
| `guard-dangerous-commands` | Bash | **Bloqueia** comando irreversível ou que toca produção |
| `auto-test-runner` | PostToolUse | **Bloqueia** edição que quebra teste relacionado; avisa quando o arquivo não tem teste |

`_hooklib.py` é a biblioteca compartilhada. Os hooks têm suíte própria
(`bash .claude/hooks/tests/run.sh`) — mexeu em hook, roda.

O `guard-dangerous-commands` já teve um buraco fechado: um agente escreveu arquivo do repo com
`python3 - <<'EOF'` e o hook não pegou, porque o regex exigia `-c`/`-e` e programa vindo da stdin
passava direto. Hoje cobre dash isolado, `--eval`/`--print` e `write_text`.

## Onde este framework não vale
Este doc descreve o `.claude/` do **`lucida-monorepo`**. A base de conhecimento (`lucida-mind`) tem
config própria e não herda nada disso.
