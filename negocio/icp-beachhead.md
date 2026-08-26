---
quando_usar: discutir público-alvo, ICP, beachhead, estratégia de expansão e GTM
última_revisão: 2026-08-25
status: canônico
---

# ICP e beachhead

## Wedge de densidade (prioridade estratégica)

**Pré-vestibular / cursinho de exatas (STEM)** — avaliação recorrente sobre o mesmo conteúdo, LaTeX
obrigatório, presença institucional. Loops em semanas, não semestres. É onde o flywheel gira mais
rápido e a assertividade aparece primeiro. Ver [negocio/moat-flywheel.md](../negocio/moat-flywheel.md).

## ICP 1 — Professor Sobrecarregado

**Perfil:** mais de um vínculo institucional. Turmas de 40-50 alunos, ensino médio. 25-45 anos.
Corrige manualmente no fim de semana. Já usou IA (ou tem aversão por frustração com ferramentas
incompletas).

**Dor central:** tempo fora do trabalho consumido por obrigações do trabalho.

**Canal de aquisição:** Instagram via micro influenciadores + programa de afiliados.
Ver [negocio/canais-aquisicao.md](../negocio/canais-aquisicao.md).

## ICP 2a — Infoprodutor / EdTech Informal

**Perfil:** produtor de conteúdo digital já inserido na venda pelo digital. Precisa validar conteúdo
e agregar valor com avaliações. Usa ferramentas desconectadas.

**Dor central:** fragmentação de ferramentas + baixa qualidade das alternativas de IA.

**Canal de aquisição:** digital direto, comunidades de criadores.

> O produto reconhece esse ICP no modelo de dados: `INFOPRODUTOR` é um dos quatro segmentos de plano
> de aula e de disciplina da Biblioteca (ao lado de `FUNDAMENTAL`, `MEDIO`, `FACULDADE`), com preço
> de geração próprio. Ver [produto/glossario.md](../produto/glossario.md).

## ICP 2b — Instituição de Ensino Tradicional

**Perfil:** escola, universidade ou instituto preso em processos manuais. Ainda não adotou IA por
receio de qualidade. Se privada: quer aumentar ticket por aluno. Se pública: quer eficiência
operacional.

**Dor central:** processos manuais + bloqueio para adoção de tecnologia.

**Ciclo de venda:** longo, relacional, precisa de prova social. O movimento institucional é
*downstream* do amor do professor pelo produto — não empurrar venda institucional antes do gancho
de eficiência do professor estar cravado.

**GTM professor-led:**
```
Professor adota (gancho de eficiência)
  → ama o produto → vira afiliado
  → pressiona a instituição a adquirir
  → instituição implanta para os demais professores
  → instituição fornece acesso ao aluno
```

Preço, faixas por volume e canal parceiro em [negocio/modelo-institucional.md](../negocio/modelo-institucional.md).

## O que o produto evidencia

- **Usuário primário = professor individual.** Créditos de boas-vindas concedidos no cadastro, billing
  com escopo padrão `user`, app do professor (`/app`) como produto principal, geração/correção
  pensadas para um docente operando sozinho. A **Biblioteca** (acervo reusável de material) reforça o
  uso individual recorrente.
- **Expansão = instituição.** Camada de organização (plugin de organização no BetterAuth) com
  `/analytics` (dashboard de instituição, frente roxa), gestão de membros, **billing com escopo `org`
  que faz pooling de créditos**, e analytics pedagógico agregando turmas/alunos/provas.
- **Caminho natural:** professor entra sozinho → vira referência dentro da escola → escola adota a
  camada de instituição. O produto suporta os dois lados; o pulo entre eles é organizacional, não
  técnico.
- **A última milha do aluno ainda não existe.** O último passo do GTM ("instituição fornece acesso
  ao aluno") não tem produto: o aluno não faz login, só responde pelo link público. É exatamente o
  que o ADR de *modelo multi-tenant de instituição* (aluno só-por-convite) endereça — em branch,
  fora do `main`.

Fontes do que está afirmado: domínio `iam` (organization plugin), `billing` (escopo user/org),
área `/analytics` no web. Posicionamento de marca em [negocio/posicionamento.md](../negocio/posicionamento.md).
