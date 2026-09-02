---
quando_usar: entender a nota de corte configurável e por que ela não é um domínio novo
última_revisão: 2026-08-25
status: canônico
tags: [analytics]
---

# Média de aprovação configurável

O professor define sua **nota de corte** (0–10, default **6**) — usada para marcar aprovado/reprovado nas
análises e indicadores. Decisões: mora como **campo do usuário no BetterAuth** (não um domínio novo);
resolução em cascata **org → professor → 6**, com o **nível de organização adiado** (instituição usa 6 por
ora); o cubo de analytics devolve o valor resolvido em `meta.passingGrade` e o front consome via contexto.
É a **nota de aprovação**, distinta da **aprovação da correção** de questões abertas pelo professor.
