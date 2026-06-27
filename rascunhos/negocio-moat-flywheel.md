---
destino: negocio/moat-flywheel.md (arquivo novo)
acao: criar
origem: contexto-externo.md §2 · §3
quando_usar: discutir vantagem competitiva, flywheel, estratégia de longo prazo, por que o moat é defensável
última_revisão: 2026-06
status: rascunho
---

# Moat & Flywheel

**Flywheel = fluxo.** A engrenagem que, girando, acumula vantagem. É a causa.
**Moat = estoque.** A barreira acumulada que resulta do flywheel girar. É o efeito.

Não se constrói moat diretamente: desenha-se o flywheel e gira-se até o moat existir.

## O loop concreto

```
Plano de aula (BNCC)
  → gera prova
  → resultado escrito de volta no nível da competência
  → identifica lacuna de pré-requisito
  → redesenha metodologia / material para aquele aluno
  → atualiza o plano
  ↻ mais dado → calibragem melhor → mais turmas
```

## O que é combustível (copiável)

- Inferir erro de aluno e sugerir próximo passo — qualquer LLM faz.
- Item analysis (dificuldade, discriminação) — Gradescope já entrega.

## O que é motor (defensável)

1. **Loop fechado ligado a outcome.** Data network effect: mais turmas → calibragem melhor → mais
   turmas. Quanto mais a rede cresce, mais preciso o diagnóstico.
2. **Dado de papel + discursivo + trajetória do aluno.** Players digital-first (Google, MagicSchool)
   não capturam esse dado por construção — o pipeline OMR + questão aberta é a fonte de dado que
   eles não têm.
3. **Contexto proprietário do professor, estruturado pelo plano de aula segmentado por BNCC.** Permite
   agregar no nível da competência/habilidade ("o que funciona para a habilidade EF07MA10") e
   diagnosticar no nível do pré-requisito, não do "errou a questão".

## Estado atual do flywheel (jun/2026)

**Projetado, mas parado.** Base re-baselinada para 2 pagantes pós-checkout.

A densidade necessária para o flywheel girar exige concentração num **wedge** — aposta:
**pré-vestibular / cursinho de exatas (STEM)**, onde:
- Avaliação recorrente sobre o mesmo conteúdo (loops fecham em semanas, não semestres).
- LaTeX é pré-requisito inegociável — destrава a barreira técnica.
- Presença institucional + afiliados aceleram adoção.

**Pré-condição crítica:** instrumentar o outcome no nível da competência BNCC (ex.: variação de acerto
por habilidade entre avaliações consecutivas). Sem isso, o redesenho de metodologia é combustível
copiável.

**Risco a vigiar:** vanity data — volume sem loops fechados gera moat ilusório.

**Janela competitiva estimada:** ~18 meses antes de big tech fechar o gap em PT-BR (detalhe em
negocio/competidores.md).

## O que protege o moat

O motor é defensável não porque usa BKT ou DKT (algoritmos públicos), mas porque:
1. O dado que entra é proprietário: papel + discursivo + trajetória longitudinal.
2. O Q-matrix está ligado ao BNCC — permite comparabilidade na rede.
3. O loop fecha com outcome: a eficácia do redesenho de metodologia é medida na avaliação seguinte,
   gerando feedback que melhora o próprio modelo — data network effect real.
