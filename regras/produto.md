---
quando_usar: decidir comportamento de produto — degradação, idiomas, rubrica, aprovação, replica set, acesso do aluno, features de assinante
última_revisão: 2026-08-25
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
- **Biblioteca** e **Calendário** são **exclusivas de assinante** — liberadas para staff, membro de
  instituição ou assinatura ativa (`SubscriberAccessPolicy` compartilhada). Sem direito → **402** no
  backend e tela de **upsell** no web. É alavanca de conversão, não bug.
- **Notificação de abertura de prova** depende do cron interno; sem `CRON_SECRET`/cron registrado, o envio
  automático não roda — o professor ainda tem o **reenvio manual**. Nunca derrubar nada por isso.

## Geração e correção
- **Três idiomas** de geração: pt-BR, inglês, espanhol.
- **Questão aberta exige rubrica** — não existe aberta sem critérios/níveis.
- **Correção de aberta é assistida, não automática**: a IA sugere nível por critério; **só conta no
  score depois da aprovação do professor**. A IA nunca arbitra a nota numérica sozinha.
- Preço de IA é **determinístico por config** — o que é cotado é o que é debitado ([tecnico/billing-ledger.md](../tecnico/billing-ledger.md)).
- **Tipo de atividade** (`exam`/`mockExam`/`quiz`/`exerciseList`, default `exam`) só classifica/filtra a
  prova — não muda geração, preço ou correção.
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
- Welcome credits são **idempotentes** (não duplicar em retry).

## Acesso do aluno
- O aluno **não tem login**. Não há produto autenticado para aluno hoje, e a frente "aluno"
  (azul claro) segue como marca futura.
- Há **duas** portas de entrada, não uma: o **link público** `/exam/[shareId]` (anônimo; aluno fora
  da turma entra por auto-cadastro, com `code`/`matricula` gerados) e o **link por aluno**
  `/exam/[shareId]/start/[token]`, com identidade pré-preenchida, emitido pelo escopo `exams:share`
  da API pública.

> **Proposto, não em produção.** O **ADR-0013** decide que o aluno passa a ser um tipo de usuário
> BetterAuth distinto, **só-por-convite** — sem outra porta de entrada —, ligado ao `StudentDoc` por
> e-mail, e o `code` de 7 dígitos deixa de ser credencial. Está em branch com status `proposto`; o
> scaffolding no repositório (`domains/student-portal/`, `app/aluno/`) está **vazio**. Até isso
> mudar, vale o que está acima.

## Integridade da prova
- No modo de aplicação **estrito** (`securityLevel: "strict"`), a submissão **auto-finaliza no 3º
  strike** de troca de aba/blur e fica flagrada (`endReason: "violation"`). Os contadores ficam em
  `integrityFlags`. No modo livre, nada disso acontece.
- O modo é editável **depois** da criação, e prova copiada **herda** o modo da origem — o professor
  precisa conseguir ver qual é antes de aplicar.

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

> **Proposto, não em produção.** O ADR-0013 torna `organizationId` **obrigatório** em todo dado de
> negócio, com organização-padrão criada no cadastro de cada professor ("tenant de um"), papéis
> `owner`/`admin`/`secretary`/`teacher`, e migração professor→instituição **opt-in e explícita** (os
> dados pessoais do professor não migram ao aceitar convite). Em branch, status `proposto`.

## Backoffice
- `/kintal` é **staff-only** e nunca exposto ao cliente. Gating por role fica no servidor, não no edge.
