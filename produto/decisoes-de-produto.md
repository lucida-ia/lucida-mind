---
quando_usar: entender o porquê de uma decisão de produto (rebrand, analytics, OMR, Classroom, transcrição, biblioteca, calendário, média de aprovação, matemática, onboarding)
última_revisão: 2026-08-25
status: canônico
---

# Decisões de produto

Decisões com lente de produto (o *porquê*). Origem: memórias de projeto do `lucida-monorepo`.

## Rebrand "Lucida única"
Sem sub-marcas (Exam/Learning/Analytics descontinuadas). Uma marca, três frentes por **cor +
qualificador**; nomes técnicos seguem em inglês. Login unificado por frente **adiado**.
Detalhe em [negocio/posicionamento.md](../negocio/posicionamento.md).

## Analytics como "cubo" parametrizável
Motor de analytics **calculado on-read** (sem materialização — volume baixo justifica), parametrizado
por escopo + corte (breakdown) + filtros + período. **Discriminação de item** usa o **índice dos 27%**
(grupos superior/inferior; split na mediana quando N<10). **Habilidades BNCC por questão** ficaram no
**roadmap** (as questões ainda não carregam tag de habilidade). Endpoints legados continuam vivos; a
contração para o cubo é faseada. Front novo em `features/analytics-cube`.

## Rebuild do scanner OMR
Geometria única em `@lucida/omr-template` (`geometry.json`), **vendorizada** no serviço Python para
deploy isolado. **Preset fixo A4 50×5** (2 colunas). **Identidade por QR por aluno** (payload
`LUCIDA1|examId|studentId`). Pipeline próprio: 4 marcadores **ArUco** → correção de perspectiva → QR →
fill-ratio. O **PDF é gerado pelo servidor** (1 página por aluno); o **scoring vive na API**, não no
Python. Validado ponta a ponta.

## Serviço de transcrição do YouTube
Serviço Python para extrair transcrição de vídeo e usar como fonte em provas/aulas: tenta a legenda
via yt-dlp e, sem legenda, transcreve o áudio pela API da OpenAI (não há Whisper local).
yt-dlp **exige** `player_client=android` (caso contrário bloqueia). Preferência de idioma pt → es → en →
qualquer; legendas manuais antes de auto antes de áudio. Há fallback JS (frágil). Deploy no Railway.

## Integração Google Classroom
**Fase 1 feita**: OAuth próprio (separado do BetterAuth, `access_type=offline` + `prompt=consent`),
tokens cifrados em repouso (AES-256-GCM), importação de turmas/alunos com **reconciliação por e-mail**.
Fases 2 (enviar prova → `courseWorkId`) e 3 (passback de nota) estão **implementadas e testadas, mas
não wired**: `SendExamToClassroomUseCase` e `PushGradeToClassroomUseCase` existem com teste e não são
referenciados por controller, rota ou UI em lugar nenhum — e o cliente da API do Google para elas é
stub. Pela regra do projeto ("feature não wired não existe"), é **código morto** hoje, não feature
engatilhada.
**Bloqueio**: projeto GCP ainda não criado (verificação OAuth leva semanas). Sem as envs, o card fica
indisponível (degradação graciosa).

## Biblioteca como fonte de conteúdo integrada
O professor sobe material **uma vez** e reutiliza nas gerações, em vez de re-anexar PDF a cada prova.
Decisões: o binário **não trafega pela API** (upload/download direto ao storage por **presigned URL** —
custo e latência fora do servidor); o texto é **extraído uma vez** no upload e reaproveitado (a
reutilização na geração **não cobra crédito** de extração); acesso **gateado** por dono/org/assinante
(alavanca de conversão — quem não tem acesso vê upsell); feature **desligável por env** (`LIBRARY_S3_*`
ausentes → 503, resto da api segue). Mecânica em [tecnico/biblioteca.md](../tecnico/biblioteca.md).

## PostHog (produto/observabilidade)
Cloud US, **product analytics + error tracking**. **Session replay e feature flags adiados** de propósito.
Reverse proxy `/ingest` para escapar de ad-blockers. Captura na API é **fire-and-forget** (nunca
aguardada). Tela `/kintal/metricas` combina Mongo (pedagógico) e HogQL (produto).

## Agendamento de prova + notificação por e-mail
A prova ganhou **janela de resposta** (abre/fecha) e a opção de **avisar os alunos por e-mail quando abrir**.
Decisões: o envio usa um **outbox em Mongo** (uma linha por aluno) — **sem Redis nem fila externa**, para
não somar infra; idempotência por índice único `(examId, studentId)` e **lease** para o drain não duplicar
em runs concorrentes; o disparo é por **cron do Railway** batendo num endpoint interno (`CRON_SECRET`), com
**reenvio manual** pelo professor como rede de segurança. É **feature de assinante** (mesma política da
Biblioteca). **Bloqueio de ops**: o cron ainda não foi registrado no Railway — até lá, só o reenvio manual
dispara e-mail. Mecânica em [tecnico/calendario.md](../tecnico/calendario.md).

## Média de aprovação configurável
O professor define sua **nota de corte** (0–10, default **6**) — usada para marcar aprovado/reprovado nas
análises e indicadores. Decisões: mora como **campo do usuário no BetterAuth** (não um domínio novo);
resolução em cascata **org → professor → 6**, com o **nível de organização adiado** (instituição usa 6 por
ora); o cubo de analytics devolve o valor resolvido em `meta.passingGrade` e o front consome via contexto.
É a **nota de aprovação**, distinta da **aprovação da correção** de questões abertas pelo professor.

## Nível e objetivos da turma
A turma deixou de ter só "série" e passou a carregar **nível de ensino** (stage `FUNDAMENTAL`/`MEDIO`/
`SUPERIOR`/`CUSTOM` + série livre) e **objetivos de aprendizagem** (BNCC ou personalizados) — contexto que
alimenta geração e análises. Atenção ao **enum de stage da turma ser diferente do Segment** do plano de
aula/Biblioteca (`FACULDADE`/`INFOPRODUTOR`). Gotcha de implementação (salvar apaga se não popular ambos)
em [tecnico/dominios.md](../tecnico/dominios.md).

## Matemática nas questões (LaTeX + KaTeX)
Fórmulas são **LaTeX inline no texto** da questão (sem campo dedicado), renderizadas com **KaTeX**. Como o
modelo às vezes devolve LaTeX que o `JSON.parse` corrompe (barras viram caracteres de controle), a geração
passa por um **pipeline de normalização/reparo** (inclui reescrever comandos em pt-BR como `\sen`/`\tg`), e
um **backfill** repara provas antigas. Mecânica em [tecnico/ai-ops.md](../tecnico/ai-ops.md).

## Onboarding com tour guiado
Primeira sessão no `/app` abre um **tour** (mascote **Lulu**) destacando os 5 caminhos principais
(dashboard, criar prova, criar plano, corrigir, análises). Decisões: **auto-inicia uma vez** (flag
`onboardingTourCompletedAt` no BetterAuth + cache local anti-flicker), **refazível** pelo menu de perfil,
**coachmarks no desktop / modal-resumo no mobile**, e **staff em modo preview não persiste** a flag.
Instrumentado no PostHog (ver [tecnico/eventos-posthog.md](../tecnico/eventos-posthog.md)).

## gpt-5 / tuning por família de modelo
A geração ficou **agnóstica à família do modelo**: um utilitário detecta modelos de raciocínio (`gpt-5`,
série `o`) e ajusta os parâmetros (sem `temperature`, com `reasoning_effort`, `max_completion_tokens`).
Trocar para um gpt-5 é só mudar `OPENAI_MODEL` — **o default segue `gpt-4.1-mini`** por ora. Em [tecnico/ai-ops.md](../tecnico/ai-ops.md).

## Descrição de prova: 500 → 10.000 caracteres
O limite de 500 apertava demais o enunciado de contexto de prova. Subiu para **10.000**. Decisão de
produto simples, registrada porque o número aparece em validação nos dois lados.

## Modo de aplicação editável depois da criação
O nível de segurança (livre / estrito) só podia ser escolhido no wizard: a página de detalhe não
mostrava nem deixava mudar, embora a api já devolvesse e aceitasse o campo. Pior, **prova copiada
herda o modo da origem** — dava para copiar uma prova estrita e aplicar sem o professor nunca ver.
Agora o detalhe mostra um selo "Modo estrito", o diálogo de metadados edita o campo, e o diálogo de
cópia diz o que é herdado (questões, duração, modo) e o que não é (janela de disponibilidade,
submissões).

## Delegação a auxiliares
Professor com secretaria/monitoria precisa delegar o operacional sem entregar a conta. Modelo: vínculo
**N:N** professor↔auxiliar **dentro de uma organização**, com seletor de professor-alvo e banner
"atuando como"; revogação por **soft-delete**, para o histórico não sumir. A fronteira é dura:
delegação dá acesso aos **dados** do professor, nunca à **autoridade administrativa** dele. Ver
[regras/produto.md](../regras/produto.md).

## Roadmap público como canal de priorização
Em vez de coletar pedido por e-mail e suporte, um **kanban público** onde o usuário sugere e vota
(`/roadmap`). Sugestão nasce aprovada por padrão, com fila de moderação reservada para quando o
volume justificar. É canal de produto, não vitrine: staff mexe pelas ações inline da própria página.

---

# Decisões de 2026-08-15 (fundação do motor de assertividade)

As três abaixo foram tomadas juntas e são **pré-condição** uma da outra. Nenhuma está implementada —
todas dependem do ADR-0012 (ver [produto/motor-assertividade.md](motor-assertividade.md)).

## Indicadores por KC, mirando IDEB
Reportar desempenho por **Knowledge Component** em vez de por nota da prova, com o código **BNCC**
como chave quando aplicável e KC provisório (slug curto) onde a taxonomia não se aplica
(FACULDADE/INFOPRODUTOR). Nunca vazio. É o que permitiria à instituição ler o próprio resultado na
mesma unidade do indicador oficial.

## Aluno como usuário
Para haver série histórica por aluno atravessando professores e turmas, o aluno precisa de identidade
persistente — hoje ele é registro de turma, não conta. Formalizado depois no ADR-0013
(só-por-convite). Ver [regras/produto.md](../regras/produto.md) e [negocio/posicionamento.md](../negocio/posicionamento.md).

## Flashcards como coletor de KC
Prova é evento raro; N≥4 observações por KC não chega rápido só com prova. Flashcards seriam a
superfície de **coleta barata e frequente** de resposta por KC, alimentando o motor entre avaliações.
Depende do objeto de aprendizagem existir primeiro.

## ADR-0012 — a questão como objeto rastreável
Decidido (status `proposto`, em branch): cada questão recebe um **`questionId` estável** embutido no
snapshot do `Exam`; a metadata pedagógica mutável (`kc[]`, `kc_status`, `family_id`,
`nivel_cognitivo`, `distrator_diagnostico`) vive num **novo bounded context `learning-object`** — a
Q-matrix, um documento por `questionId`; e a `Submission` passa a persistir o `questionId` de cada
resposta, além do índice posicional. O `Exam` continua **snapshot imutável** — reeditar questão nunca
pode mudar nota histórica. Escopo: só a Fase 0→1. Não decide BKT, feedback nem área do aluno.

## ADR-0013 — modelo multi-tenant de instituição
Decidido (status `proposto`, em branch): a instituição **é** o `organization` do BetterAuth, não uma
entidade nova; toda conta de professor nasce com organização-padrão ("tenant de um");
`organizationId` vira **obrigatório**; papéis `owner`/`admin`/`secretary`/`teacher`; e o aluno é
usuário BetterAuth **só-por-convite**. A migração professor→instituição é **opt-in e explícita**:
aceitar convite de uma escola **não** expõe as turmas pessoais do professor a ela.
