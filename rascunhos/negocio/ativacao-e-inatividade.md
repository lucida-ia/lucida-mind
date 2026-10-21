---
quando_usar: montar régua de reativação, definir as tags de inatividade do professor, calibrar os cortes de tempo pelo uso de quem usa direito, saber que sinal existe hoje para cada gatilho
última_revisão: 2026-09-03
status: rascunho
tags: [analytics, billing]
---

# Ativação e reativação por inatividade

Os pontos em que o professor para de avançar, da conta criada sem nenhum uso até a prova pronta que
nunca foi aplicada. Cada ponto vira uma tag, um sinal que a identifica e uma ação.

> **Rascunho — nunca validado.** As tags, os cortes de tempo e as ações são proposta de set/2026 e
> ninguém do time conferiu. **Nada disto existe em código**: não há motor de ciclo de vida, régua,
> nem cohort configurada. O que existe é a matéria-prima descrita abaixo.

## O que existe hoje para operar isso

- **Canais**: inbox in-app com campanhas disparadas por staff ou admin de organização (domínio
  `notifications`), e-mail transacional via Resend, e o card "Lulu sugere" no dashboard, que já aponta
  correção pendente e aluno em risco. Ver [produto/suite.md](../../produto/suite.md).
- **Agendamento**: o padrão outbox em Mongo com lease e cron interno do `exam-notification` é
  reutilizável para uma régua. Ver [tecnico/calendario.md](../../tecnico/calendario.md).
- **Sinais**: os eventos server-side do PostHog e, principalmente, o estado no Mongo. Ver
  [tecnico/eventos-posthog.md](../../tecnico/eventos-posthog.md).

**A segmentação tem de sair do Mongo, não do PostHog.** Os eventos que descreveriam a aplicação de uma
prova estão definidos e não instrumentados, e os eventos de UI são client-side. O PostHog serve para
medir o funil depois, não para decidir quem recebe o quê.

Nomes de tag em inglês `snake_case`, como a taxonomia de eventos.

## Antes da primeira prova

| Tag | Estado | Sinal | Ação |
|---|---|---|---|
| `credits_untouched` | Conta criada, nenhuma ação de IA | Carteira `welcome` intacta e sem débito no ledger | Convite para a primeira geração, com o saldo nomeado |
| `tour_abandoned` | Tour pulado ou incompleto | `onboarding_tour_skipped`, ou started sem completed | Retomar no passo em que parou |
| `no_class` | Nenhuma turma | Coleção de turmas vazia | Criar turma, ou importar do Google Classroom |
| `class_without_students` | Turma sem aluno | Turma sem `Student` vinculado | Importar alunos; sem eles não há aplicação |
| `generation_abandoned` | Gerou e não salvou a prova | `ai_generation_completed` sem `exam_created` | Retomar o rascunho; o crédito já foi debitado |
| `library_dead_end` | Material subiu e morreu ali | `library_file_uploaded` sem `library_file_used_in_generation`, ou `library_file_extraction_failed` | Gerar prova a partir do arquivo, ou avisar da falha de extração |

`credits_untouched` é o único sinal cem por cento server-side de "criou e nunca usou". Crédito de
boas-vindas nunca expira e é a última fonte consumida, então saldo cheio significa nenhuma operação de
IA na vida da conta. Ver [negocio/monetizacao-creditos.md](../../negocio/monetizacao-creditos.md).

`generation_abandoned` só enxerga prova objetiva. A geração de prova aberta não emite evento nenhum.

## Prova criada e não aplicada

| Tag | Estado | Sinal | Ação |
|---|---|---|---|
| `exam_no_submissions` | Prova existe, zero resposta | Nenhuma `Submission` para o `examId` | Compartilhar link, agendar janela ou imprimir |
| `window_closed_empty` | Janela fechou vazia | `availableUntil` no passado, zero submissão | Reabrir a janela ou reaplicar |
| `notification_never_sent` | Aviso de abertura nunca saiu | `notifyOnOpen` verdadeiro, `availableFrom` no passado e `notificationsMaterializedAt` nulo | Reenvio manual pelo professor |
| `grading_pending` | Aplicou e não fechou a nota | `gradingStatus` em `pending` ou `partially_graded` | Fila de correção; só nota aprovada vira score |
| `single_exam` | Uma prova só, N dias depois | Contagem de provas do dono igual a um | Segunda prova, ou reaproveitar a primeira em outra turma |

Divida `exam_no_submissions` por causa antes de escrever copy: prova sem janela nenhuma, janela ainda
aberta e janela já fechada são três conversas diferentes.

**`notification_never_sent` costuma ser falha nossa, não do cliente.** O cron do Railway que materializa
esses e-mails ainda não foi registrado, então a abertura automática não dispara sozinha e depende do
botão de reenvio. Cobrar o professor por isso é cobrar por um bug nosso.

## Assinante esfriando

| Tag | Estado | Sinal | Ação |
|---|---|---|---|
| `active_no_generation` | Assinatura ativa, zero geração no ciclo | Ledger sem débito de IA desde o início do período | Pré-churn: contato humano, não campanha |
| `cycle_credits_expiring` | Créditos do ciclo vão virar pó | `expiresAt` da carteira `subscription` próximo | Lembrar do uso; no mensal os créditos não acumulam |
| `topup_expiring` | Top-up perto dos 365 dias | `expiresAt` da carteira `topup` próximo | Mesmo tratamento, prazo diferente |
| `out_of_credits` | Saldo zero | Débito recusado por saldo | Top-up ou upgrade |
| `payment_failed` | Cobrança recusada | Webhook Stripe de falha | Atualizar meio de pagamento |
| `subscription_canceled` | Cancelou | `subscription_canceled` | Winback |

`out_of_credits` muda de destinatário quando a organização paga: o erro é `InstitutionOutOfCredits` e
quem precisa comprar é o admin, não o professor que travou. Outra pessoa e outra copy.

`payment_failed` é churn involuntário e não é cancelamento. A separação é obrigatória no reporte e hoje
é manual, porque o código não distingue os dois. Ver
[regras/comunicacao.md](../../regras/comunicacao.md).

## Calibrar pelo uso assíduo

Os cortes de tempo das tags acima não devem ser arbitrados. Saem da distribuição real de quem usa a
Lucida com regularidade: se o intervalo típico entre duas provas é de duas semanas, silêncio de seis
semanas é anomalia. Sem essa base, `single_exam` e `active_no_generation` disparam no palpite.

**A espinha do estudo é o `credit_ledger`, não o PostHog.** Toda ação de IA grava uma entrada com
`actorUserId`, `billingPeriodId` e `relatedAction`, e o conjunto inclui `generate_exam`,
`generate_open_exam`, as regenerações, `grade_open_answer` e `generate_lesson_plan`. O ledger enxerga
o que a instrumentação não enxerga, a começar pela prova discursiva. Ver
[tecnico/billing-ledger.md](../../tecnico/billing-ledger.md).

Defina assíduo por **comportamento, não por pagamento**. Assinatura ativa sem geração no ciclo é
justamente uma das tags de risco, e membro de instituição usa sem ter assinatura própria.

| Dimensão | Corte | Fonte |
|---|---|---|
| Ritmo | Intervalo entre provas criadas, provas por ciclo | Ledger, por `billingPeriodId` |
| Mistura | Objetiva contra discursiva, plano de aula junto ou não | `relatedAction` |
| Refino | Regenerações por prova | `regenerate_question`, `regenerate_open_question` |
| Fechamento | Provas que recebem submissão, e destas as que têm correção aprovada | Provas contra submissões e `gradingStatus` |
| Latência | Dias de criar até aplicar, e de aplicar até aprovar a nota | `startedAt` e `submittedAt` da submissão |
| Escala | Alunos por turma, submissões por prova, link público contra scanner | `source` da submissão |
| Insumo | Reuso da Biblioteca contra upload avulso ou YouTube | `library_file_used_in_generation` |
| Calibragem | Créditos consumidos contra depositados no ciclo | Ledger contra o plano |

### O que o estudo tem de declarar

- **A amostra é minúscula.** A base pagante de jun/2026 é de dois clientes, uma instituição e um
  infoprodutor — número de rascunho, não conferido, em
  [rascunhos/negocio/metricas.md](metricas.md). Com esse N não há estatística: descreva cada caso por
  inteiro e não tire média entre frentes de uso opostas.
- **Sazonalidade pode explicar tudo.** Professor concentra prova em fim de bimestre, e janela curta de
  observação lê recesso como abandono. Não há nada na base sobre isso; é hipótese a testar.
- **O qualitativo já existe e é mais barato.** O Kintal tem "atuar como", com audit log, e há tickets
  de suporte e votos no roadmap público. Com dois clientes, conversa rende mais que dashboard.
- **Token consumido é telemetria, não preço.** O que o cliente paga é a tabela determinística de
  créditos.

## Onde o sinal não existe

- **Aplicação da prova é invisível no PostHog.** `exam_published`, `exam_link_shared`,
  `public_exam_started`, `grading_started`, `grading_approved` e `scanner_used` existem na taxonomia e
  nenhum `capture()` os dispara.
- **Prova discursiva não emite evento de geração.**
- **Não há evento de visualização de análise**, então "corrigiu e nunca olhou o resultado" não é
  taggeável sem instrumentar antes.
- **Segmentar instituição no PostHog não funciona.** Só os quatro eventos de Biblioteca mandam
  `groups`.
- **O aluno não é usuário**, é registro de turma. Nenhum gatilho fala com ele fora do e-mail de
  abertura de janela. Ver [produto/decisoes/aluno-como-usuario.md](../../produto/decisoes/aluno-como-usuario.md).
