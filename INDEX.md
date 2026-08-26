# Lucida — Base de Conhecimento
> Comece aqui. Abra só o doc relevante. Se a resposta não estiver na base, diga que não está.

## Negócio
- [negocio/visao-geral.md](negocio/visao-geral.md) — Use quando: explicar o que é a Lucida, o problema e a proposta de valor
- [negocio/posicionamento.md](negocio/posicionamento.md) — Use quando: falar de marca, sub-marcas, as três frentes (professor/instituição/aluno)
- [negocio/icp-beachhead.md](negocio/icp-beachhead.md) — Use quando: discutir público-alvo, ICP, wedge de cursinho STEM, GTM professor-led
- [negocio/monetizacao-creditos.md](negocio/monetizacao-creditos.md) — Use quando: falar de planos, preços, top-ups, créditos de boas-vindas
- [negocio/modelo-institucional.md](negocio/modelo-institucional.md) — Use quando: discutir preço institucional, canal parceiro vs. direto, desconto por volume
- [negocio/metricas.md](negocio/metricas.md) — Use quando: reportar tração, MRR, retenção, base pagante
- [negocio/canais-aquisicao.md](negocio/canais-aquisicao.md) — Use quando: falar de canais, afiliados, o que foi testado e descartado
- [negocio/competidores.md](negocio/competidores.md) — Use quando: discutir cenário competitivo, big tech, diferencial real
- [negocio/moat-flywheel.md](negocio/moat-flywheel.md) — Use quando: discutir vantagem competitiva, flywheel, janela competitiva

## Produto
- [produto/suite.md](produto/suite.md) — Use quando: listar os módulos do produto e o que cada um faz
- [produto/glossario.md](produto/glossario.md) — Use quando: precisar do significado de um termo de domínio (exam, submission, rubric, OMR…)
- [produto/estilos-de-questao.md](produto/estilos-de-questao.md) — Use quando: tipos de questão, estilos de geração, dificuldade, idiomas
- [produto/decisoes-de-produto.md](produto/decisoes-de-produto.md) — Use quando: entender o porquê de uma decisão (rebrand, analytics-cubo, OMR, Classroom)
- [produto/roadmap.md](produto/roadmap.md) — Use quando: discutir prioridades de produto, sequência de desenvolvimento, lente de moat
- [produto/motor-assertividade.md](produto/motor-assertividade.md) — Use quando: fundamentar o motor de assertividade (BKT/CDM/IRT), definir escopo por fase de maturidade, consultar parâmetros e princípios de design de avaliação

## Técnico
- [tecnico/stack.md](tecnico/stack.md) — Use quando: saber versões, libs, comandos, layout do monorepo
- [tecnico/arquitetura.md](tecnico/arquitetura.md) — Use quando: criar/mover domínio, decisão de camada (Clean Arch + DDD), DI manual, ordem de middleware
- [tecnico/dominios.md](tecnico/dominios.md) — Use quando: mapear os domínios da api e suas entidades centrais
- [tecnico/billing-ledger.md](tecnico/billing-ledger.md) — Use quando: mexer em créditos, ledger, débito atômico, custo por operação
- [tecnico/biblioteca.md](tecnico/biblioteca.md) — Use quando: mexer na Biblioteca (upload de arquivos, presigned S3, extração, fonte de geração)
- [tecnico/calendario.md](tecnico/calendario.md) — Use quando: mexer em agendamento de prova (janela de resposta), calendário, notificação de abertura por e-mail (outbox + cron)
- [tecnico/ai-ops.md](tecnico/ai-ops.md) — Use quando: mexer em geração/correção de IA, modelo OpenAI, extractors, SSE
- [tecnico/integracoes.md](tecnico/integracoes.md) — Use quando: integrar/depurar Stripe, PIX, NFE.io, Resend, Classroom, OMR, YouTube, PostHog
- [tecnico/eventos-posthog.md](tecnico/eventos-posthog.md) — Use quando: consultar a taxonomia de eventos PostHog (nome, propriedades, onde dispara), montar funil/insight, instrumentar evento novo
- [tecnico/convencoes-de-codigo.md](tecnico/convencoes-de-codigo.md) — Use quando: nomear arquivo, idioma do código, comentário, import ESM, clean code
- [tecnico/testes.md](tecnico/testes.md) — Use quando: escrever teste, entender a estratégia por camada, rodar a suíte, interpretar cobertura, montar E2E
- [tecnico/framework-claude.md](tecnico/framework-claude.md) — Use quando: saber que skill/agent/comando/hook existe no monorepo, escolher quem chamar, entender o que é bloqueado automaticamente

## UI
- [ui/modelo-de-ui.md](ui/modelo-de-ui.md) — Use quando: criar tela/componente, Server vs Client, Server Action, estado, shadcn-first
- [ui/design-tokens.md](ui/design-tokens.md) — Use quando: usar tokens CSS, theme switch, primitivos shadcn de components/ui
- [ui/identidade-visual.md](ui/identidade-visual.md) — Use quando: escolher cor, tipografia, logo, contraste, tom de voz

## Regras
- [regras/codigo.md](regras/codigo.md) — Use quando: revisar/escrever código — regras invioláveis, hooks bloqueantes, checklist dos reviewers
- [regras/processo.md](regras/processo.md) — Use quando: citar uma regra numerada, entender como se trabalha no monorepo, decidir onde registrar uma decisão
- [regras/produto.md](regras/produto.md) — Use quando: decidir comportamento de produto (degradação graciosa, idiomas, rubrica, replica set)
- [regras/comunicacao.md](regras/comunicacao.md) — Use quando: escrever copy pt-BR, falar de tração/churn (involuntário ≠ cancelamento)
- [regras/pitch.md](regras/pitch.md) — Use quando: escrever pitch, landing page, copy de aquisição, narrativa para investidor

---

**Antes de usar:** os docs técnicos e de produto saem do código — se divergirem dele, o código ganha, e
`./check-drift.sh` aponta onde. Os de negócio trazem números de jun/2026 sem fonte no repositório;
confirme antes de levar a pitch ou decisão de preço.
