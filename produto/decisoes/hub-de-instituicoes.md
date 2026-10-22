---
quando_usar: entender o nível de agregação acima da instituição (conglomerado, hub de edtechs) e o que ele pode fazer
última_revisão: 2026-10-22
status: canônico
tags: [instituicao, analytics]
---

# Hub de instituições

> Decisão dos sócios de 2026-10-22. **Não existe em código.**

Uma instituição pode virar conglomerado, e um parceiro como a Unifast precisa enxergar as várias
instituições que usam a Lucida. Para isso existe um nível acima da instituição: o **hub**.

O hub é uma **tela de visão agregada, somente leitura**, com recortes sobre os dados das instituições
que o compõem. Não age sobre elas: não remove aluno, não mexe em turma, não altera membro — nem quando
um aluno pertence a mais de uma organização do conglomerado. Ação a partir do hub pode fazer sentido
no futuro; agora não.

**Diverge do código.** O ADR-0013 do `lucida-monorepo` (`docs/adr/0013-instituicao-como-nivel-0.md`)
põe "hierarquia de orgs" fora do escopo, e hoje a única visão de várias organizações é o Kintal, só
para staff. O ADR precisa ser revisto lá. O site institucional já anuncia "visão consolidada da rede".

Modelo de instituição em [produto/decisoes/adr-0013-multi-tenant.md](adr-0013-multi-tenant.md).
