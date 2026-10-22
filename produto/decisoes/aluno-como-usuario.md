---
quando_usar: entender por que o aluno tem identidade persistente, como funciona a Área do Aluno e o que ela ainda não faz
última_revisão: 2026-10-22
status: canônico
tags: [instituicao]
---

# Aluno como usuário

> Decisão de 2026-08-15, tomada junto com as outras da fundação do motor de assertividade —
> ver [produto/decisoes-de-produto.md](../decisoes-de-produto.md). **Implementada** como Área do
> Aluno (ADR-0019 do código, em `staging`).

Para haver série histórica por aluno atravessando professores e turmas, o aluno precisa de identidade
persistente. Antes ele era só registro de turma; hoje o registro (`Student`) aponta para uma conta
(`userId`).

## Como funciona

| Pergunta | Resposta no código |
|---|---|
| Como o aluno entra? | `/aluno/entrar` e `/aluno/cadastro`, com Google ou e-mail/senha, igual ao professor |
| Professor que também é aluno? | **Conta única.** A tela `/escolher` pergunta a área a cada entrada |
| Como a conta se liga à turma? | Link de convite da turma (`/aluno/convite/[token]`), gerado e revogado pelo professor na aba de alunos da turma |
| Aluno de vários professores? | Um contexto por instituição; as turmas de professores sem instituição formam **"Meus professores"** |
| O que ele vê? | Início (provas abertas, próximas, resultados recentes), turmas, calendário e o resultado com respostas e gabarito |
| Como responde? | O portal emite um link assinado para a página pública da prova, preso à conta |
| Vale para qual plano? | Qualquer professor, inclusive gratuito; não gasta crédito |

Conta criada pela porta do aluno nasce `role: "student"`, gravado só pelo servidor, sem welcome
credits e sem acesso a `/app`. A frente usa a paleta azul clara (`.theme-student`).

## O que ainda diverge ou falta

- **Vínculo por e-mail.** O código ainda reivindica, no aceite e a cada entrada no portal, todo
  registro sem conta com o e-mail comprovado da conta (`claimUnlinkedByEmail`), e a conta de aluno
  nasce sem conferir convite. O ADR-0013 (decisão 14) manda ligar **só pelo aceite do convite**;
  a correção é a issue #213. Ver [produto/decisoes/adr-0013-multi-tenant.md](adr-0013-multi-tenant.md).
- **Vínculo com a instituição.** Os sócios decidiram que o vínculo do aluno fica com a instituição,
  não com o professor. Hoje o registro é por turma e, sem org, agrupado sob "Meus professores".
- **Só dentro da janela.** O aluno só responde quando a prova está aberta (ou não tem janela); fora
  disso, nada a fazer além de ver resultados. Engajar o aluno **antes e depois** das janelas do
  professor é direção decidida pelos sócios — ver
  [produto/decisoes/engajamento-fora-da-janela.md](engajamento-fora-da-janela.md). A forma desse
  engajamento ainda não está decidida.

As regras de acesso do aluno estão em [regras/produto.md](../../regras/produto.md); a frente de marca,
em [negocio/posicionamento.md](../../negocio/posicionamento.md).
