---
quando_usar: escrever copy pt-BR, definir tom por frente, falar de tração/churn, responder sobre a Lucida
última_revisão: 2026-06-27
status: canônico
---

# Regras de comunicação

## Copy de produto
- **UI sempre em pt-BR** (labels, botões, mensagens, placeholders). É a única parte do produto em
  português — o código é inglês (ver tecnico/convencoes-de-codigo.md).
- **Tom por frente**: claro, direto, de apoio ao professor. A cor acompanha a frente (professor azul,
  instituição roxo) — ver ui/identidade-visual.md. Não misturar tons numa mesma tela.
- **Uma marca**: é "Lucida", sem sub-marcas. "Lucida para professores/instituições/alunos" é
  qualificador, não nome de produto separado (negocio/posicionamento.md).

## Métricas e tração (cuidado com nuance)
- **Churn involuntário ≠ cancelamento.** Falha de pagamento (cartão recusado, expirado) não é o cliente
  pedindo para sair — não conte como churn voluntário nem como "cancelamento". Separe sempre os dois ao
  reportar retenção/receita. (Disciplina de **reporte**: o código ainda **não distingue** — `Subscription`
  não tem `cancelReason` e as métricas contam todo `canceled` igual; a separação é manual por enquanto.)
- Tokens consumidos são **telemetria**, não cobrança — não apresente custo de IA como se fosse preço ao
  cliente (o preço é a tabela de créditos).
- Receita líquida = bruta − (fees Stripe + impostos); demais despesas (infra, IA, payroll, marketing)
  **não** entram no cálculo de net revenue. Não confunda ao falar de margem.

## Ao responder sobre a Lucida (uso desta base)
- Consulte o `INDEX.md` e abra **só** o doc relevante.
- **Não invente.** Se a informação não estiver na base nem no código, diga que não está — não preencha
  lacuna com suposição. Itens marcados `a definir` são lacunas conhecidas, não convites a inventar.
- Quando houver conflito, o **código do `lucida-monorepo` é a fonte primária**; esta base resume.
