---
quando_usar: entender por que o reporte mira Knowledge Component em vez de nota de prova, e o que existe disso hoje
última_revisão: 2026-10-22
status: canônico
tags: [analytics, instituicao]
---

# Indicadores por KC, mirando IDEB

> Decisão de 2026-08-15, tomada junto com as outras da fundação do motor de assertividade —
> ver [produto/decisoes-de-produto.md](../decisoes-de-produto.md). **Em construção** no épico #141;
> nada dele está na `staging`.

Reportar desempenho por **Knowledge Component** em vez de por nota da prova, com o código **BNCC**
como chave quando aplicável e KC provisório onde a taxonomia não se aplica
(FACULDADE/INFOPRODUTOR). Nunca vazio. É o que permitiria à instituição ler o próprio resultado na
mesma unidade do indicador oficial.

**Hoje:** o cubo de analytics já tem o corte `habilidade`, modelado e sempre vazio ("BNCC ainda não
mapeado nas questões"). As questões não carregam habilidade, e o prompt de geração proíbe código BNCC
no conteúdo.

**No #141:** o KC é um conceito do catálogo da organização, com `source` `bncc` ou `custom` e `code`
livre, não validado contra lista oficial. A etapa da org (fundamental, médio, superior, livre) decide
onde a BNCC se aplica, e entra antes da Fase 2. O corte por habilidade é preenchido na Fase 4 (acerto
por resposta e conceito); domínio por conceito na turma, no professor e na org é a Fase 5.

Detalhe em [produto/objeto-de-aprendizagem.md](../objeto-de-aprendizagem.md). Fundamento em
[produto/motor-assertividade.md](../motor-assertividade.md).
