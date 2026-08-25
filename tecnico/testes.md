---
quando_usar: escrever teste, entender a estratégia por camada, rodar a suíte, interpretar cobertura, montar E2E
última_revisão: 2026-08-25
status: canônico
---

# Testes

## Estado da suíte
Números da campanha de cobertura, **medidos em 2026-08-18**. Trate como snapshot: a contagem já andou
desde então (a api tinha 314 arquivos, hoje tem 316).

| Frente | Arquivos | Testes | Statements |
|---|---|---|---|
| `apps/api` unit | 277 | 2.108 | — |
| `apps/api` integração | 37 | 315 | — |
| `apps/api` **união** | 314 | **2.423** | **82,05%** |
| `apps/web` | 632 | **2.836** | **95,57%** |
| `services/omr` | 5 | 34 | 97% |
| `services/youtube-transcript` | 2 | 28 | 100% |

Camadas da api: `domain` 89,7% · `infrastructure` 88,2% · `presentation` 81,6% · `application` 81,5%.

### Três coisas que o número sozinho esconde
- **Os dois relatórios da api não somam.** `coverage/` (unit) e `coverage-integration/` respondem cada
  um "o que esta suíte sozinha exercita". Os 82,05% são a **união calculada arquivo a arquivo**; ler só
  o relatório unit dá **51,63%** e subestima.
- **`main.ts` conta como descoberto** (1.120 statements). Testá-lo exigiria refatorar o composition
  root. Excluí-lo levaria o número a ~84,7% sem nada real mudar — por isso não foi excluído.
- **`presentation` é testada como unit**, não por `supertest`. O controller recebe `Deps` no construtor,
  então dá para injetar fakes e paralelizar.

## Estratégia por camada (ADR-0011)
Cada camada usa a técnica que corresponde ao que ela realmente é:

| Camada | Técnica | Por quê |
|---|---|---|
| `domain` | unit puro, sem mock | entidades e VOs não têm dependência |
| `application` | unit com fakes das interfaces injetadas | use case recebe tudo por construtor |
| `presentation` | **unit** com `req`/`res`/`next` falsos | controller recebe `Deps`; paralelizável |
| `infrastructure` — repositórios | **integração** contra Mongo efêmero | ver abaixo |
| `infrastructure` — clientes/builders | unit com `vi.mock` do SDK ou `fetch` | sem banco envolvido |

**Por que repositório não se testa com Mongoose mockado** — foi a parte mais disputada da decisão.
Mockar o Mongoose que o repositório embrulha verifica "chamei `find` com estes argumentos", não se a
query está **correta**. Não é teórico: a campanha achou um repositório consultando `createdBy` num
schema cujo campo é `ownerId`. O Mongo não acusa erro em filtro por campo inexistente — apenas não casa
nada, e a métrica do painel ficava sempre 0. Um teste mockado teria asseverado a chamada e passado.

## Banco de teste (ADR-0009)
`mongodb-memory-server` com **`MongoMemoryReplSet`** (o replica set é obrigatório — o débito de crédito
usa transação), em **porta fixa 27018**, subido por `globalSetup` da config de integração.

A porta é fixa de propósito: a URI de teste fica **estática**, então pode viver num `.env.test`
versionado carregado **antes de qualquer import**, o que resolve propagar URI dinâmica para dentro dos
workers do vitest. O primeiro run é mais lento (download); o cache persiste entre execuções.

## Teste de posse
Regra do projeto: **endpoint novo nasce com o trio** — dono autorizado / não-dono → `404` / não
autenticado → `401` (em recurso de organização: membro de outra org → `404`, nunca `403`, que
confirmaria a existência do recurso).

Hoje todo controller com id tem o par dono-autorizado / não-dono-como-inexistente. As regras de
isolamento 5.1–5.3 (ver regras/processo.md) passaram a ter teste — antes eram só texto.

O teste de posse por rota (`*.integration.test.ts` com `supertest`) continua valendo como garantia
ponta a ponta em rotas escolhidas, **não** como veículo de cobertura da camada.

## Como rodar
```
pnpm test                     # workspaces JS/TS
pnpm test:services            # pytest dos dois serviços Python
pnpm --filter @lucida/api test:unit
pnpm --filter @lucida/api test:integration
pnpm --filter @lucida/api test:coverage
```

Gotcha de máquina: o vitest abria 1 fork por CPU, e com a instrumentação de cobertura o oom-killer
derrubava a sessão. Os dois configs de unit têm `poolOptions.forks.maxForks = 4` — o pico caiu de
3,87GB num fork para ~502MB em 5 processos, custando ~3s a mais na suíte. Não aumente sem medir.

## E2E (Playwright)
Specs em `e2e/` na raiz. O fluxo **exige o Docker Compose**, não `pnpm dev`:

```
docker compose up -d --build
docker compose exec api pnpm run seed:e2e-teacher
pnpm e2e          # ou pnpm e2e:ui
```

Não há workflow de CI em `.github/` — a suíte roda localmente.

## Regras
- **Teste não se deleta pra fazer build passar.** Se virou obsoleto, o commit explica por quê.
- Achado de produção descoberto por teste vira `it.fails` + entrada no `TODO.md` do monorepo —
  **nunca correção silenciosa**. Corrigir é decisão de quem tem contexto de produto.
- Um hook (`auto-test-runner`) bloqueia edição que quebra teste relacionado e avisa quando o arquivo
  editado não tem teste nenhum.
