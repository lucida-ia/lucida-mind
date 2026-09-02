---
quando_usar: se orientar na área de regras — qual doc tem a regra que você procura
última_revisão: 2026-08-30
status: canônico
---

# Mapa das regras

Quatro docs. A diferença entre eles é **o que a regra governa**, não o quanto ela pesa.

| Doc | Governa |
|---|---|
| [regras/processo.md](processo.md) | como se trabalha — as regras **numeradas 1–18**, os três princípios, onde registrar cada decisão |
| [regras/codigo.md](codigo.md) | o que o código pode e não pode — invioláveis, hooks bloqueantes, checklist dos reviewers |
| [regras/produto.md](produto.md) | como o produto se comporta — degradação graciosa, acesso do aluno, rubrica, quem é assinante |
| [regras/comunicacao.md](comunicacao.md) | o que se escreve — copy pt-BR, tom por frente, tração e churn |

## Por onde começar

Por **[regras/processo.md](processo.md)**: é lá que vive a numeração canônica, a que se cita em ADR,
contrato e prompt de subagent. [regras/codigo.md](codigo.md) detalha as de código e diz qual hook
bloqueia cada uma — a numeração continua sendo a do `processo.md`.

## Onde esta área encosta nas outras

- **A arquitetura que as regras 8–10 protegem** está em
  [tecnico/arquitetura.md](../tecnico/arquitetura.md); o modelo de frontend, em
  [ui/modelo-de-ui.md](../ui/modelo-de-ui.md).
- **O trio de testes de posse** da regra 11 está em [tecnico/testes.md](../tecnico/testes.md).
- **O débito atômico** da regra 6 está em [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).
- **Os hooks, agents e comandos** que fazem as regras valerem estão inventariados em
  [tecnico/framework-claude.md](../tecnico/framework-claude.md).
- **O porquê** de um comportamento de produto está em
  [produto/decisoes-de-produto.md](../produto/decisoes-de-produto.md) — invariante é aqui, decisão é lá.

---

Outras áreas: [negocio/mapa-do-negocio.md](../negocio/mapa-do-negocio.md) · [produto/mapa-do-produto.md](../produto/mapa-do-produto.md) · [tecnico/mapa-tecnico.md](../tecnico/mapa-tecnico.md) · [ui/mapa-da-ui.md](../ui/mapa-da-ui.md)
