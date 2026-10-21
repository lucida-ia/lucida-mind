---
quando_usar: evoluir o funil de autoavaliação (raio-x de aprendizagem) que entrega ao prospect um diagnóstico pré-fechado antes da call com o consultor, inclusive como inscrição de evento
última_revisão: 2026-10-21
status: rascunho
---

# Funil de autoavaliação

> **Rascunho — nunca validado.** Desenho de out/2026. **Nada disto existe no produto.** Contexto
> estratégico em [rascunhos/negocio/estrategia-jornada-e-canal-unifast.md](estrategia-jornada-e-canal-unifast.md).

O prospect faz um raio-x de aprendizagem sozinho, em cerca de 10 minutos, e sai com diagnóstico e
escopo preliminar montados. A call com o consultor deixa de ser descoberta e vira validação e
fechamento.

## Decisões tomadas

- **Sem preço no resultado.** O escopo chega pré-fechado; o preço é ofertado pelo vendedor na call.
- **Um funil, três usos:** aquisição direta, raio-x do Discovery da Unifast e **captação para o
  evento** — a autoavaliação é a inscrição. O prospect chega ao evento com o diagnóstico na mão e sai
  com a call marcada.
- **WhatsApp obrigatório** no perfil. Nos anúncios pagos, lead sem telefone esfriou sem canal de
  retorno (ver [rascunhos/negocio/canais-aquisicao.md](canais-aquisicao.md)).
- **A call se apresenta como "revisar seu diagnóstico"**, não como reunião de vendas.

## Etapas

| # | Etapa | Tempo | O que acontece |
|---|---|---|---|
| 1 | Perfil | 2 min | Frente (escola, IES/pós, expert/edtech, empresa), tamanho, cargo, nome, e-mail, WhatsApp, origem |
| 2 | Autoavaliação | 5 min | 12 perguntas, 4 dimensões, escala 1–4 |
| 3 | Amostra (opcional) | 3 min | Sobe prova ou material; recebe mapa de competências e uma missão no estilo dele |
| 4 | Resultado | — | Maturidade por dimensão, 3 lacunas, jornada sugerida, escopo e nível de serviço; cópia em PDF por e-mail |
| 5 | Agendamento | — | Agenda do consultor na mesma tela |

No uso como evento, a etapa 5 vira a inscrição confirmada, e a call é oferecida no fim do evento.

## Perguntas (versão 1)

Escala das respostas: **1** nunca/não · **2** às vezes · **3** na maioria das vezes · **4** sempre, com
dado. O vocabulário troca por frente (turma, programa, curso, equipe).

| Dimensão | Perguntas |
|---|---|
| Frequência | Fora das provas, com que frequência o aluno faz atividade avaliativa? · Quantas vezes a mesma competência é avaliada ao longo do curso? · O aluno pratica entre as aulas de forma acompanhada? |
| Granularidade | As questões estão ligadas a competências ou habilidades? · Você sabe, por competência, onde a turma trava? · Consegue ver isso por aluno? |
| Uso do dado | O resultado de uma avaliação muda a aula ou o curso seguinte? · Existe rotina de revisão do material a partir dos resultados? · Quem tem dificuldade recebe atividade diferente? |
| Evidência | Consegue mostrar ao aluno o que ele aprendeu? · Consegue mostrar à coordenação, à IES ou à empresa? · O certificado ou relatório final traz algo além da nota? |

**Nível por dimensão** = média das três respostas, arredondada: **1 Pontual** (só prova) ·
**2 Organizado** (avaliações regulares, sem leitura por competência) · **3 Diagnóstico** (lê por
competência, age pouco) · **4 Evidência** (mede, age e comprova).

## Resultado

- Nível por dimensão, em barras.
- **Três lacunas**, derivadas das dimensões mais baixas e, se houver amostra, do mapa de competências
  (competências sem questão, concentração num nível cognitivo, poucas atividades por competência
  contra o alvo de 4+).
- Jornada sugerida em uma página.
- **Escopo preliminar**: frente (School ou Creators), programas ou séries, nível de serviço
  (Essencial, Modelagem, Operação contínua).

## Roteamento

Pontuação = **aderência** (frente e tamanho) × **dor** (quanto mais baixa a maturidade, maior) ×
**intenção** (subiu amostra, agendou, cargo de decisão).

| Faixa | Ação |
|---|---|
| Alta | Consultor sênior em até 24 h; se não agendou, contato por WhatsApp |
| Média | Call agendada na tela, com lembrete |
| Nutrição | Nível Essencial no produto + régua de conteúdo |

## O consultor

**Dossiê:** respostas e níveis, mapa de competências da amostra, lacunas, escopo preliminar, nível
recomendado, origem (direto, Unifast, evento).

**Call de 30 min:** 5 confirmar o diagnóstico · 10 mostrar a amostra e a jornada · 10 ajustar o escopo
e apresentar o preço · 5 fechar ou marcar o piloto.

## Métricas

Início → conclusão · conclusão com amostra · conclusão → agendamento (ou inscrição) · comparecimento ·
call → fechamento · tempo até fechar. Os eventos de funil entram na taxonomia de
[tecnico/eventos-posthog.md](../../tecnico/eventos-posthog.md) quando forem instrumentados.

## O que existe e o que falta

**Reaproveita:** geração de atividade a partir de material e extração de texto (ver
[tecnico/biblioteca.md](../../tecnico/biblioteca.md)); geração via LuAS.

**Falta construir:** página da autoavaliação; captura de lead com telefone; geração da amostra com
limite por lead; tela e PDF de resultado; agenda dos consultores; roteamento por pontuação; eventos no
PostHog.

## Em aberto

- Pesos e cortes da pontuação de aderência e intenção.
- Limite e custo da amostra por lead no LuAS.
- Consentimento LGPD para o material enviado na amostra e para usá-lo na demonstração do evento.
- De quem é o lead captado no evento da Unifast, e como ele é compartilhado.
- Quem são os consultores e qual ferramenta de agenda.
- Se as perguntas precisam de versão diferente por frente além do vocabulário.
