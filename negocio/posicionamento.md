---
quando_usar: falar de marca, nome, as frentes de mercado (School/Creators), as três frentes de uso (professor/instituição/aluno), como nomear o produto
última_revisão: 2026-10-22
status: canônico
tags: [instituicao]
---

# Posicionamento

A Lucida vende **experiência de aprendizagem** — a parte avaliativa e a relação entre aluno e
educador —, não ferramental. Gerar prova e plano de aula é meio, não a proposta.

## Duas frentes de mercado: Lucida School e Lucida Creators

> Decisão dos sócios de out/2026. **O código não tem traço das duas frentes**: produto, rotas e copy
> seguem como "Lucida".

| Frente | Cobre |
|---|---|
| **Lucida School** | Todo processo de aprendizagem formal: escola pública ou privada, IES, pós e MBA |
| **Lucida Creators** | O informal: expert, edtech, club, in-company |

Isto substitui a regra "Lucida única, sem sub-marcas" **no que diz respeito a frentes de mercado**.
As sub-marcas de produto do rebrand ("Lucida Exam", "Lucida Learning", "Lucida Analytics") continuam
descontinuadas. Decisão em [produto/decisoes/school-e-creators.md](../produto/decisoes/school-e-creators.md).

Outras decisões do mesmo reposicionamento, nenhuma executada no código:

- **O piso de cliente é a instituição.** Todo professor é uma instituição de um, e o vínculo do aluno
  fica com a instituição, não com o professor. O ADR-0013 do código decide o mesmo e ainda não foi
  executado — ver [produto/decisoes/adr-0013-multi-tenant.md](../produto/decisoes/adr-0013-multi-tenant.md).
- **Hub acima da instituição.** Uma instituição pode virar conglomerado, com uma tela de visão
  agregada, só leitura — ver [produto/decisoes/hub-de-instituicoes.md](../produto/decisoes/hub-de-instituicoes.md).
- **A geração de IA migra para o LuAS**, serviço próprio. Planejado; os contratos estão em rascunho e
  não há nada no código.

## As três frentes de uso (uma cor por frente)

Dentro do produto, o que muda entre contextos de uso é **cor + um qualificador funcional**, não o nome.

| Frente | Como se chama | Cor | Onde aparece |
|---|---|---|---|
| Professor | "Lucida para professores" | Azul `#007AFF` | App do professor (`/app/*`) |
| Instituição | "Lucida para instituições" | Roxo `#6C3CFB` | Dashboard de organização (`/analytics/*`) |
| Aluno | "Lucida para alunos" | Azul claro `#5CDAFF` (token `--color-student-primary`) | Área do Aluno (`/aluno/*`) |

Regra visual: **nunca misturar** as três cores na mesma tela. Ao entrar numa frente, toda a hierarquia
visual (CTA, links, accents) herda aquele tom. Detalhe de cores em [ui/identidade-visual.md](../ui/identidade-visual.md).

## O que é só rótulo de marca vs. o que é técnico

- Nomes **técnicos** seguem em inglês e não mudam com marca: o domínio continua `exam`, a área de
  organização continua `analytics`, a do aluno é `student-portal`. "Frente" é camada de marca/copy,
  não de código.
- A frente do **aluno** tem produto: a **Área do Aluno** (`/aluno`), com conta própria, entrada por
  convite da turma e contexto por instituição. O link público da prova continua existindo para quem
  não tem conta. Detalhe em [produto/decisoes/aluno-como-usuario.md](../produto/decisoes/aluno-como-usuario.md).

## Pendências

- **Login unificado por frente** (destino pós-login `/app` vs `/analytics` por membership de
  organização, sem campo `accountType`) segue adiado. O que existe é a tela `/escolher`, só para
  quem é professor e aluno ao mesmo tempo: escolhe entre `/app` e `/aluno` a cada entrada.
