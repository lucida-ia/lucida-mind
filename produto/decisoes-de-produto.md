---
quando_usar: entender o porquê de uma decisão de produto (rebrand, analytics, OMR, Classroom, transcrição, biblioteca, calendário, média de aprovação, matemática, onboarding)
última_revisão: 2026-06-30
status: canônico
---

# Decisões de produto

Decisões com lente de produto (o *porquê*). Origem: memórias de projeto do `lucida-monorepo`.

## Rebrand "Lucida única"
Sem sub-marcas (Exam/Learning/Analytics descontinuadas). Uma marca, três frentes por **cor +
qualificador**; nomes técnicos seguem em inglês. Login unificado por frente **adiado**.
Detalhe em negocio/posicionamento.md.

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
Serviço Python (yt-dlp + Whisper) para extrair transcrição de vídeo e usar como fonte em provas/aulas.
yt-dlp **exige** `player_client=android` (caso contrário bloqueia). Preferência de idioma pt → es → en →
qualquer; legendas manuais antes de auto antes de áudio. Há fallback JS (frágil). Deploy no Railway.

## Integração Google Classroom
**Fase 1 feita**: OAuth próprio (separado do BetterAuth, `access_type=offline` + `prompt=consent`),
tokens cifrados em repouso (AES-256-GCM), importação de turmas/alunos com **reconciliação por e-mail**.
Fases 2 (enviar prova → `courseWorkId`) e 3 (passback de nota) estão **engatilhadas, não implementadas**.
**Bloqueio**: projeto GCP ainda não criado (verificação OAuth leva semanas). Sem as envs, o card fica
indisponível (degradação graciosa).

## Biblioteca como fonte de conteúdo integrada
O professor sobe material **uma vez** e reutiliza nas gerações, em vez de re-anexar PDF a cada prova.
Decisões: o binário **não trafega pela API** (upload/download direto ao storage por **presigned URL** —
custo e latência fora do servidor); o texto é **extraído uma vez** no upload e reaproveitado (a
reutilização na geração **não cobra crédito** de extração); acesso **gateado** por dono/org/assinante
(alavanca de conversão — quem não tem acesso vê upsell); feature **desligável por env** (`LIBRARY_S3_*`
ausentes → 503, resto da api segue). Mecânica em tecnico/biblioteca.md.

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
dispara e-mail. Mecânica em tecnico/calendario.md.

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
em tecnico/dominios.md.

## Matemática nas questões (LaTeX + KaTeX)
Fórmulas são **LaTeX inline no texto** da questão (sem campo dedicado), renderizadas com **KaTeX**. Como o
modelo às vezes devolve LaTeX que o `JSON.parse` corrompe (barras viram caracteres de controle), a geração
passa por um **pipeline de normalização/reparo** (inclui reescrever comandos em pt-BR como `\sen`/`\tg`), e
um **backfill** repara provas antigas. Mecânica em tecnico/ai-ops.md.

## Onboarding com tour guiado
Primeira sessão no `/app` abre um **tour** (mascote **Lulu**) destacando os 5 caminhos principais
(dashboard, criar prova, criar plano, corrigir, análises). Decisões: **auto-inicia uma vez** (flag
`onboardingTourCompletedAt` no BetterAuth + cache local anti-flicker), **refazível** pelo menu de perfil,
**coachmarks no desktop / modal-resumo no mobile**, e **staff em modo preview não persiste** a flag.
Instrumentado no PostHog (ver tecnico/eventos-posthog.md).

## gpt-5 / tuning por família de modelo
A geração ficou **agnóstica à família do modelo**: um utilitário detecta modelos de raciocínio (`gpt-5`,
série `o`) e ajusta os parâmetros (sem `temperature`, com `reasoning_effort`, `max_completion_tokens`).
Trocar para um gpt-5 é só mudar `OPENAI_MODEL` — **o default segue `gpt-4.1-mini`** por ora. Em tecnico/ai-ops.md.
