---
quando_usar: discutir prioridades de produto, sequência de desenvolvimento, lente de moat
última_revisão: 2026-08-25
status: parcial
---

# Roadmap de produto (lente de moat)

> **Parcial.** A priorização e a sequência abaixo são proposta de jun/2026, não roadmap aprovado —
> o que o time está executando vive nas **GitHub Issues**, na milestone Instituição. As seções "O que
> já está entregue" e "Onde a Fase 1 está sendo desenhada" foram conferidas no código e valem.

| Peça | Papel no moat | Prioridade |
|---|---|---|
| **Plano de aula (backbone BNCC)** | Hub que gera o grafo de competências + switching cost | Arquitetura central |
| LaTeX em provas (STEM) | Destrava o wedge de maior densidade | Pré-requisito estratégico |
| Provas discursivas + espelho | Combustível mais rico (raciocínio + rubrica + dado papel) | Alto |
| **Inferência de gap por Knowledge Component** | Granularização do dado por KC — separa motor de combustível | Crítico para o moat |
| **Metodologia adaptativa** | Direciona o que estudar a seguir por aluno | Crítico para a assertividade |
| **Touchpoints avaliativos otimizados** | Frequência ideal de avaliação por retenção e evidência | Motor do loop |
| Ambiente do aluno (QR + calendário + artefatos) | Dado longitudinal + lock-in institucional | Piloto institucional |
| Diagnóstico por competência BNCC + pré-requisito | Fecha o loop de assertividade | Crítico para o moat |
| Relatório para pais / aluno | Expansão de valor para formação de base | Médio prazo |
| Slides + roteiro | Commodity; derivar do plano de aula | Esforço mínimo |
| White-label institucional | Lock-in de dado para redes | Médio prazo |

## Sequência recomendada

```
backbone + LaTeX + discursivas
  → inferência de gap por KC (BKT/CDM)
  → metodologia adaptativa
  → ambiente do aluno (começa pelo QR Code + calendário)
  → relatório para pais
```

**Diagnóstico por competência BNCC o quanto antes** — é o que fecha o loop e torna o moat
mensurável. Sem ele, não é possível distinguir dado que acumula vantagem de vanity data.

## O que já está entregue

- **LaTeX em provas** — ✅ entregue. LaTeX inline renderizado com KaTeX na prova online e na
  imprimível, com pipeline de reparo/normalização e backfill retroativo. Ver [tecnico/ai-ops.md](../tecnico/ai-ops.md).
- **Provas discursivas + rubrica** — ✅ entregue, com correção assistida por IA e aprovação do
  professor. Ver [produto/suite.md](../produto/suite.md).
- **Plano de aula** — ✅ entregue como módulo (BNCC, DOCX, gerar prova a partir do plano). O que
  **não** existe é o papel de *backbone*: o resultado da avaliação não volta a escrever no plano no
  nível da habilidade.
- **Inferência por KC** — ❌ não começou. Questões não carregam tag de habilidade.

## Onde a Fase 1 está sendo desenhada

A ponte para o motor está em **dois ADRs de produto ainda em branch, fora do `main`**:

- **Questão como objeto rastreável** — KC / Q-matrix, `family_id`.
- **Modelo multi-tenant de instituição** — instituição = `organization` do BetterAuth, org-padrão por
  professor, `organizationId` obrigatório, roles owner/admin/secretary/teacher, **aluno = usuário
  só-por-convite**, migração opt-in.

> Cite os dois **pelo título**. Na branch eles estão numerados 0009 e 0010, que já estão ocupados no
> `main` — vão ser renumerados no merge, e qualquer número escrito agora nasce errado.

O roadmap de produto corrente é operado em **GitHub Issues**, na milestone **Instituição** —
distinto desta lente de moat, que é a estratégia de longo prazo. As duas se encontram no modelo
multi-tenant: a área do aluno, que a milestone prioriza, depende dele.

## Critério de sequenciamento: a escada de maturidade

O escopo de cada mudança de código no motor segue as fases de [produto/motor-assertividade.md](../produto/motor-assertividade.md) (§4):

| Fase | O que existe | O que destrava |
|---|---|---|
| 0 — Atual | Item analysis isolado por prova, sem KC | Escopo imediato: tagging de KC + `family_id` nas questões (proposta de schema em [produto/motor-assertividade.md](../produto/motor-assertividade.md) §8 — aguardando avaliação) |
| 1 — Objeto longitudinal | Questões carregam KC(s) via Q-matrix | Séries temporais por KC entre provas |
| 2 — BKT por KC | ≥4 observações por KC | `p(domínio)`, "aprendido vs. não", Confiável/Direcional |
| 3 — Pré-requisito (CDM) | Grafo de KCs + volume de padrões | Loop fechado de redesenho de material |
| 4 — Neural (DKT) | Dado longitudinal denso | Refinamento — não é pré-requisito do MVP |

## Restrições de design do gerador

Duas regras de [produto/motor-assertividade.md](../produto/motor-assertividade.md) (§5–§6) que restringem geração e orientação ao professor:

- **N ≥ 4 atividades com tópicos sobrepostos** por KC antes de feedback confiável — orientar o
  professor a construir sequências, não provas avulsas. Abaixo disso, estimativa é "Direcional".
- **Amplitude máxima de KCs por atividade**; sob escassez de material, máximo de formatos por KC
  (mede transferência). Amplitude opera dentro da atividade; profundidade, ao longo da sequência —
  não competem.
