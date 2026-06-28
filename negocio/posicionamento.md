---
quando_usar: falar de marca, nome, sub-marcas, as três frentes (professor/instituição/aluno), como nomear o produto
última_revisão: 2026-06-27
status: canônico
---

# Posicionamento — "Lucida única"

A marca é **uma só: Lucida**. Não existem sub-marcas como "Lucida Exam", "Lucida Learning" ou
"Lucida Analytics" — essas foram **descontinuadas** no rebrand. O produto se apresenta como Lucida e
ponto; o que muda entre contextos é **cor + um qualificador funcional**, não o nome.

## As três frentes (uma marca, três paletas)
| Frente | Como se chama | Cor | Onde aparece |
|---|---|---|---|
| Professor | "Lucida para professores" | Azul `#007AFF` | App do professor (`/app/*`) |
| Instituição | "Lucida para instituições" | Roxo `#6C3CFB` | Dashboard de organização (`/analytics/*`) |
| Aluno | "Lucida para alunos" | Azul claro `#5CDAFF` *(referência de marca; **sem token CSS** no código)* | Identidade futura; hoje o aluno só acessa o link público da prova |

Regra visual: **nunca misturar** as três cores na mesma tela. Ao entrar numa frente, toda a hierarquia
visual (CTA, links, accents) herda aquele tom. Detalhe de cores em ui/identidade-visual.md.

## O que é só rótulo de marca vs. o que é técnico
- Nomes **técnicos** seguem em inglês e não mudam com o rebrand: o domínio continua `exam`, a área de
  organização continua `analytics`, as rotas idem. "Frente" é camada de marca/copy, não de código.
- A frente do **aluno** ainda não tem auth nem produto dedicado — é referência de marca. O aluno entra
  apenas pelo **link público** `/exam/[shareId]`, sem cadastro.

## Pendências
- **Login unificado por frente** (decidir destino pós-login `/app` vs `/analytics` por membership de
  organização, sem campo `accountType`) foi **adiado** — "por enquanto não vamos mexer no login".

Fonte: memória de projeto `rebrand-lucida-unica.md`; cores em `apps/web/src/styles/globals.css`.
