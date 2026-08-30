# Lucida — Base de Conhecimento
> Comece aqui. Abra só o doc relevante. Se a resposta não estiver na base, diga que não está.

## Negócio
- [negocio/mapa-do-negocio.md](negocio/mapa-do-negocio.md) — Use quando: se orientar na área e ver em que ordem ler os docs de negócio
- [negocio/visao-geral.md](negocio/visao-geral.md) — Use quando: explicar o que é a Lucida, o problema e a proposta de valor
- [negocio/posicionamento.md](negocio/posicionamento.md) — Use quando: falar de marca, sub-marcas, as três frentes (professor/instituição/aluno)
- [negocio/monetizacao-creditos.md](negocio/monetizacao-creditos.md) — Use quando: falar de planos, preços, top-ups, créditos de boas-vindas
- [negocio/icp-beachhead.md](negocio/icp-beachhead.md) — Use quando: discutir público-alvo e expansão (parcial — ICP detalhado e GTM estão em rascunho)

## Produto
- [produto/mapa-do-produto.md](produto/mapa-do-produto.md) — Use quando: se orientar na área e ver em que ordem ler os docs de produto
- [produto/suite.md](produto/suite.md) — Use quando: listar os módulos do produto e o que cada um faz
- [produto/glossario.md](produto/glossario.md) — Use quando: precisar do significado de um termo de domínio (exam, submission, rubric, OMR…)
- [produto/estilos-de-questao.md](produto/estilos-de-questao.md) — Use quando: tipos de questão, estilos de geração, dificuldade, idiomas
- [produto/decisoes-de-produto.md](produto/decisoes-de-produto.md) — Use quando: entender o porquê de uma decisão. É o índice de `produto/decisoes/`, uma nota por decisão
- [produto/motor-assertividade.md](produto/motor-assertividade.md) — Use quando: fundamentar o motor de assertividade (BKT/CDM/IRT), sustentar a tese de moat, consultar as referências científicas
- [produto/maturidade-do-motor.md](produto/maturidade-do-motor.md) — Use quando: definir escopo de mudança por fase de maturidade, consultar parâmetros e os dois princípios de design de avaliação
- [produto/objeto-de-aprendizagem.md](produto/objeto-de-aprendizagem.md) — Use quando: consultar o schema proposto da Q-matrix, regras de feedback, e o que o ADR-0012 decidiu

## Técnico
- [tecnico/mapa-tecnico.md](tecnico/mapa-tecnico.md) — Use quando: se orientar na área e ver em que ordem ler os docs técnicos
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
- [ui/mapa-da-ui.md](ui/mapa-da-ui.md) — Use quando: se orientar na área e ver em que ordem ler os docs de UI
- [ui/modelo-de-ui.md](ui/modelo-de-ui.md) — Use quando: criar tela/componente, Server vs Client, Server Action, estado, shadcn-first
- [ui/design-tokens.md](ui/design-tokens.md) — Use quando: usar tokens CSS, theme switch, primitivos shadcn de components/ui
- [ui/identidade-visual.md](ui/identidade-visual.md) — Use quando: escolher cor, tipografia, logo, contraste, tom de voz

## Regras
- [regras/mapa-das-regras.md](regras/mapa-das-regras.md) — Use quando: descobrir qual dos quatro docs tem a regra que você procura
- [regras/codigo.md](regras/codigo.md) — Use quando: revisar/escrever código — regras invioláveis, hooks bloqueantes, checklist dos reviewers
- [regras/processo.md](regras/processo.md) — Use quando: citar uma regra numerada, entender como se trabalha no monorepo, decidir onde registrar uma decisão
- [regras/produto.md](regras/produto.md) — Use quando: decidir comportamento de produto (degradação graciosa, idiomas, rubrica, replica set)
- [regras/comunicacao.md](regras/comunicacao.md) — Use quando: escrever copy pt-BR, falar de tração/churn (involuntário ≠ cancelamento)

---

## Rascunhos — não validados

**Não cite nada daqui como fato da Lucida.** São propostas de jun/2026 que ninguém do time conferiu:
tração, preço institucional, cenário competitivo, ICP e narrativa de pitch. Estão indexados para
serem achados e revisados — não para embasar cotação a cliente, pitch ou decisão de preço.

Validado, o arquivo sobe de pasta com `git mv` e entra na seção correspondente acima.
Convenção em [rascunhos/LEIA-ME.md](rascunhos/LEIA-ME.md).

- [rascunhos/negocio/icp-beachhead.md](rascunhos/negocio/icp-beachhead.md) — ICP detalhado, wedge de cursinho STEM, GTM professor-led. Preenche o "a definir" do canônico.
- [rascunhos/negocio/metricas.md](rascunhos/negocio/metricas.md) — tração, MRR, retenção, base pagante
- [rascunhos/negocio/modelo-institucional.md](rascunhos/negocio/modelo-institucional.md) — preço institucional, canal parceiro vs. direto, desconto por volume
- [rascunhos/negocio/canais-aquisicao.md](rascunhos/negocio/canais-aquisicao.md) — canais, afiliados, o que foi testado e descartado
- [rascunhos/negocio/competidores.md](rascunhos/negocio/competidores.md) — cenário competitivo, radar de big tech
- [rascunhos/negocio/moat-flywheel.md](rascunhos/negocio/moat-flywheel.md) — vantagem competitiva, flywheel, janela competitiva
- [rascunhos/produto/roadmap.md](rascunhos/produto/roadmap.md) — prioridades e sequência de desenvolvimento pela lente de moat
- [rascunhos/regras/pitch.md](rascunhos/regras/pitch.md) — pitch, landing page, copy de aquisição, narrativa para investidor

---

Este repositório também é um **vault do Obsidian** — abra a pasta como vault para ver o grafo,
os backlinks e o painel [`Lucida.base`](Lucida.base) (status e `última_revisão` de tudo).
Cada área tem um `mapa-*` com a ordem de leitura; este índice segue sendo a rota mais curta
para um doc específico.

Os docs fora de `rascunhos/` saem do código. Divergiu do código, o código ganha — e
`./check-drift.sh` aponta onde.
