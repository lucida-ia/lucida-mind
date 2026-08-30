---
quando_usar: entender por que o modo de aplicação virou editável e o risco da prova copiada
última_revisão: 2026-08-25
status: canônico
---

# Modo de aplicação editável depois da criação

O nível de segurança (livre / estrito) só podia ser escolhido no wizard: a página de detalhe não
mostrava nem deixava mudar, embora a api já devolvesse e aceitasse o campo. Pior, **prova copiada
herda o modo da origem** — dava para copiar uma prova estrita e aplicar sem o professor nunca ver.
Agora o detalhe mostra um selo "Modo estrito", o diálogo de metadados edita o campo, e o diálogo de
cópia diz o que é herdado (questões, duração, modo) e o que não é (janela de disponibilidade,
submissões).

Definição de `SecurityLevel` em [produto/glossario.md](../glossario.md).
