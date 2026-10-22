---
quando_usar: decidir comportamento de produto — degradação, idiomas, rubrica, aprovação, replica set, acesso do aluno, features de assinante
última_revisão: 2026-10-22
status: canônico
tags: [correcao, instituicao]
---

# Regras de produto

Invariantes de comportamento que o produto respeita. Mecânica em tecnico/*.

## Degradação graciosa
Integrações são **opcionais por env**. Sem a env, a feature correspondente devolve **503/502** mas o
resto da api continua. Vale para OMR (502), Stripe (cartão), NFE.io, Classroom (card indisponível),
PostHog (no-op), transcrição, **Biblioteca/S3** (503 sem `LIBRARY_S3_*`), CRON (503). Nunca derrubar o
app por falta de integração secundária. Detalhe em [tecnico/integracoes.md](../tecnico/integracoes.md).

> **PIX é diferente**: não é opcional-por-env, é **desligado por kill-switch** (`PIX_TOPUP_ENABLED =
> false`) — devolve 503 **mesmo com `ABACATEPAY_*` configurado**. É pausa intencional, não falta de env.

- **Tickets** — sem `TICKETS_INBOUND_SECRET`, o inbound de e-mail devolve 503.
- **Métricas de produto** — sem as envs da Query API do PostHog, `/kintal/metricas` (aba Produto)
  devolve 503; o resto do Kintal segue.

## Features de assinante
- **Biblioteca**, **Calendário** e **Meu Estilo** são **exclusivos de assinante** — liberados para
  staff, quem tem organização ativa ou assinatura ativa (`SubscriberAccessPolicy` compartilhada). Sem
  direito → **402** no backend e tela de **upsell** no web. É alavanca de conversão, não bug. O 402 do
  Meu Estilo tem erro próprio, distinto do 402 de crédito.
- Agendar a janela de uma prova **não** é gate de assinante; só ler o calendário é.
- **Notificação de abertura de prova** depende do cron interno; sem `CRON_SECRET`/cron registrado, o envio
  automático não roda — o professor ainda tem o **reenvio manual**. Nunca derrubar nada por isso.

## Geração e correção
- **Três idiomas** de geração: pt-BR, inglês, espanhol.
- **Questão aberta exige rubrica** — não existe aberta sem critérios/níveis.
- **Correção de aberta é assistida, não automática**: a IA sugere nível por critério; **só conta no
  score depois da aprovação do professor**. A IA nunca arbitra a nota numérica sozinha.
- Preço de IA é **determinístico por config** — o que é cotado é o que é debitado ([tecnico/billing-ledger.md](../tecnico/billing-ledger.md)).
- **Múltipla escolha gerada tem sempre 5 alternativas**, uma correta (`MULTIPLE_CHOICE_OPTION_COUNT`).
- **Tipo de atividade** (`exam`/`mockExam`/`quiz`/`exerciseList`, default `exam`) só classifica/filtra a
  prova — não muda geração, preço ou correção.
- **Meu Estilo** é opt-in por geração (`useTeacherStyle`): o acesso é checado **antes** do billing;
  sem perfil destilado, a geração cai no preset em vez de falhar.
- A **Biblioteca** (arquivos do professor, extract-once) é fonte de geração; reutilizar arquivo já
  extraído **não cobra crédito** de extração ([tecnico/biblioteca.md](../tecnico/biblioteca.md)).
- **Dois "aprovar" distintos**: a **aprovação da correção** (professor valida o nível sugerido pela IA, e
  só então conta no score) é diferente da **média de aprovação** (`passingGrade`, default 6) — esta é só a
  nota de corte que classifica aluno aprovado/reprovado nas **análises**, configurável por professor.

## Créditos
- Toda ação de IA **debita créditos**; há pré-check de saldo antes de operações caras.
- Saldo esgotado tem **dois** erros distintos, e a copy precisa distinguir: `InsufficientCredits`
  (professor individual — quem compra é ele) e `InstitutionOutOfCredits` (pool da instituição — quem
  compra é o admin). Ver [tecnico/billing-ledger.md](../tecnico/billing-ledger.md).
- Mongo **precisa de replica set** — o débito atômico usa transação. Sem isso, qualquer cobrança quebra.
- Welcome credits são **idempotentes** (não duplicar em retry) e caem na carteira pessoal do
  professor. **Conta de aluno não recebe welcome credits** nem conta como cadastro de professor no
  funil.

## Acesso do aluno
- O aluno **tem conta**: a **Área do Aluno** (`/aluno`), da ADR-0019 do código. É a mesma conta
  BetterAuth para quem é professor e aluno; quem tem os dois papéis escolhe a área em `/escolher` a
  cada entrada.
- Conta criada pela porta do aluno (`/aluno/cadastro`) nasce `role: "student"`, **gravado só pelo
  servidor** a partir de um cookie de intenção — o cliente nunca escreve `role`. Conta de aluno não
  entra em `/app`.
- A conta se liga ao registro da turma pelo **link de convite da turma**, gerado e revogado pelo
  professor. O professor pode desfazer o vínculo de um aluno, o que invalida os links de resposta
  já emitidos para ele.
- Hoje o código **também liga por e-mail verificado**: no aceite e a cada entrada no portal, todo
  registro sem conta com o e-mail comprovado da conta é reivindicado (`claimUnlinkedByEmail`), haja
  convite ou não. E a conta de aluno nasce sem conferir convite. O ADR-0013 (decisão 14) manda
  remover a varredura e exigir convite válido no cadastro de aluno; a correção é a issue #213,
  ainda não feita.
- O aluno vê **um contexto por vez**: cada instituição é um contexto, e as turmas de professores sem
  instituição formam "Meus professores". O escopo é resolvido no servidor a cada requisição.
- **A Área do Aluno só deixa responder dentro da janela** (ou a qualquer hora, se a prova não tem
  janela), uma tentativa por prova. Fora disso ela lista as provas que ainda vão abrir e
  mostra o resultado das já respondidas. Não há prática livre fora da janela.
- Responder reaproveita a página pública: o portal assina um link `/exam/[shareId]/start/[token]`
  para o próprio registro do aluno, preso à conta.
- Sem conta, continuam as portas públicas: `/exam/[shareId]` (por código de 7 dígitos ou por e-mail,
  com auto-cadastro de quem não está na turma) e o link por aluno emitido pelo escopo `exams:share`
  da API pública.

## Integridade da prova
- No modo de aplicação **estrito** (`securityLevel: "strict"`), a submissão **auto-finaliza no 3º
  strike** de troca de aba/blur e fica flagrada (`endReason: "violation"`). Os contadores ficam em
  `integrityFlags`. No modo livre, nada disso acontece.
- O modo é editável **depois** da criação, e prova copiada **herda** o modo da origem — o professor
  precisa conseguir ver qual é antes de aplicar.
- **Entrada pública sem prova de posse** (ADR-0021 do código): por código ou e-mail, a entrada só
  devolve a tentativa a quem acabou de criá-la. Tentativa existente responde só o status
  (`in_progress_elsewhere` ou `already_submitted`), sem nota nem nome. Aluno que travou numa
  tentativa em andamento depende do professor **liberar a tentativa** (`release-attempt`); tentativa
  enviada nunca é liberada.
- As duas portas limitam tentativas **por visitante** (IP repassado pela web sob credencial própria)
  e têm um teto compartilhado por turma ou prova como último recurso.

## Auxiliares
- O vínculo professor↔auxiliar é N:N e vive **dentro de uma organização**; revogação é soft-delete.
- Delegação concede os **dados** do professor, **nunca a autoridade administrativa** dele: gate de
  privilégio lê o usuário real, filtro de dado lê o efetivo.
- Sair da organização revoga os vínculos de auxiliar derivados daquele professor.

## Organização vs. professor individual
- `organizationId = null` → professor individual. Com organização, há billing/analytics no escopo da
  instituição (frente roxa, `/analytics`).
- **Unicidade de matrícula** é configurável por organização: `teacher` (default) ou `organization`.
  Trocar o escopo numa org já ativa pode deixar matrículas legadas inconsistentes — a validação
  disso **ainda não existe** no código.
- **Organização só nasce pelo Kintal.** O cliente não cria nem apaga organização
  (`allowUserToCreateOrganization: false`, `disableOrganizationDeletion: true`) e só atribui os
  papéis `member` e `admin`.
- Biblioteca, Calendário e Meu Estilo saem liberados para quem tem organização ativa — **ter org é
  direito**, hoje.

> **Proposto, não executado.** O ADR-0013 do código (status `proposto`) faz da instituição o nível 0:
> toda conta de professor ganha uma org solo "Minha sala de aula" no fim do onboarding, a org é dona
> dos dados, todo crédito vira pool da org, papéis `owner`/`admin`/`secretary`/`teacher`, o direito a
> recurso pago vem do **plano**, não de ter org, e o professor escolhe quais turmas antigas leva para
> a escola. Nada disso roda: `organizationId` continua nulo por padrão, não há org solo e a
> `SubscriberAccessPolicy` ainda libera por org ativa. Detalhe em
> [produto/decisoes/adr-0013-multi-tenant.md](../produto/decisoes/adr-0013-multi-tenant.md).
>
> Os sócios decidiram o mesmo piso (todo professor é instituição de um; o aluno fica vinculado à
> instituição) e, além do ADR, um **hub** acima da instituição, só leitura — ver
> [produto/decisoes/hub-de-instituicoes.md](../produto/decisoes/hub-de-instituicoes.md).

## Backoffice
- `/kintal` é **staff-only** e nunca exposto ao cliente. Gating por role fica no servidor, não no edge.
