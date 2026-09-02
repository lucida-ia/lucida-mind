---
quando_usar: entender por que a Biblioteca existe e as decisões de custo e acesso por trás dela
última_revisão: 2026-08-25
status: canônico
tags: [biblioteca, billing]
---

# Biblioteca como fonte de conteúdo integrada

O professor sobe material **uma vez** e reutiliza nas gerações, em vez de re-anexar PDF a cada prova.
Decisões: o binário **não trafega pela API** (upload/download direto ao storage por **presigned URL** —
custo e latência fora do servidor); o texto é **extraído uma vez** no upload e reaproveitado (a
reutilização na geração **não cobra crédito** de extração); acesso **gateado** por dono/org/assinante
(alavanca de conversão — quem não tem acesso vê upsell); feature **desligável por env** (`LIBRARY_S3_*`
ausentes → 503, resto da api segue). Mecânica em [tecnico/biblioteca.md](../../tecnico/biblioteca.md).
