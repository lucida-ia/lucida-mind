# Lucida — Base de Conhecimento
> Comece aqui. Abra só o doc relevante. Se a resposta não estiver na base, diga que não está.

## Negócio
- negocio/visao-geral.md — Use quando: explicar o que é a Lucida, o problema e a proposta de valor
- negocio/posicionamento.md — Use quando: falar de marca, sub-marcas, as três frentes (professor/instituição/aluno)
- negocio/icp-beachhead.md — Use quando: discutir público-alvo, beachhead, expansão (parcial — estratégia a definir)
- negocio/monetizacao-creditos.md — Use quando: falar de planos, preços, top-ups, créditos de boas-vindas

## Produto
- produto/suite.md — Use quando: listar os módulos do produto e o que cada um faz
- produto/glossario.md — Use quando: precisar do significado de um termo de domínio (exam, submission, rubric, OMR…)
- produto/estilos-de-questao.md — Use quando: tipos de questão, estilos de geração, dificuldade, idiomas
- produto/decisoes-de-produto.md — Use quando: entender o porquê de uma decisão (rebrand, analytics-cubo, OMR, Classroom)
- produto/motor-assertividade.md — Use quando: fundamentar o motor de assertividade (BKT/CDM/IRT), definir escopo por fase de maturidade, consultar parâmetros e princípios de design de avaliação

## Técnico
- tecnico/stack.md — Use quando: saber versões, libs, comandos, layout do monorepo
- tecnico/arquitetura.md — Use quando: criar/mover domínio, decisão de camada (Clean Arch + DDD), DI manual, ordem de middleware
- tecnico/dominios.md — Use quando: mapear os ~25 domínios da api e suas entidades centrais
- tecnico/billing-ledger.md — Use quando: mexer em créditos, ledger, débito atômico, custo por operação
- tecnico/biblioteca.md — Use quando: mexer na Biblioteca (upload de arquivos, presigned S3, extração, fonte de geração)
- tecnico/calendario.md — Use quando: mexer em agendamento de prova (janela de resposta), calendário, notificação de abertura por e-mail (outbox + cron)
- tecnico/ai-ops.md — Use quando: mexer em geração/correção de IA, modelo OpenAI, extractors, SSE
- tecnico/integracoes.md — Use quando: integrar/depurar Stripe, PIX, NFE.io, Resend, Classroom, OMR, YouTube, PostHog
- tecnico/eventos-posthog.md — Use quando: consultar a taxonomia de eventos PostHog (nome, propriedades, onde dispara), montar funil/insight, instrumentar evento novo
- tecnico/convencoes-de-codigo.md — Use quando: nomear arquivo, idioma do código, comentário, import ESM, clean code
- tecnico/testes.md — Use quando: escrever teste, entender a estratégia por camada, rodar a suíte, interpretar cobertura, montar E2E
- tecnico/framework-claude.md — Use quando: saber que skill/agent/comando/hook existe no monorepo, escolher quem chamar, entender o que é bloqueado automaticamente

## UI
- ui/modelo-de-ui.md — Use quando: criar tela/componente, Server vs Client, Server Action, estado, shadcn-first
- ui/design-tokens.md — Use quando: usar tokens CSS, theme switch, primitivos shadcn de components/ui
- ui/identidade-visual.md — Use quando: escolher cor, tipografia, logo, contraste, tom de voz

## Regras
- regras/codigo.md — Use quando: revisar/escrever código — regras invioláveis, hooks bloqueantes, checklist dos reviewers
- regras/processo.md — Use quando: citar uma regra numerada, entender como se trabalha no monorepo, decidir onde registrar uma decisão
- regras/produto.md — Use quando: decidir comportamento de produto (degradação graciosa, idiomas, rubrica, replica set)
- regras/comunicacao.md — Use quando: escrever copy pt-BR, falar de tração/churn (involuntário ≠ cancelamento)
