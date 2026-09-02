---
quando_usar: entender as decisões do rebuild do scanner OMR (geometria, ArUco, onde vive o scoring)
última_revisão: 2026-08-25
status: canônico
tags: [omr]
---

# Rebuild do scanner OMR

Geometria única em `@lucida/omr-template` (`geometry.json`), **vendorizada** no serviço Python para
deploy isolado. **Preset fixo A4 50×5** (2 colunas). **Identidade por QR por aluno** (payload
`LUCIDA1|examId|studentId`). Pipeline próprio: 4 marcadores **ArUco** → correção de perspectiva → QR →
fill-ratio. O **PDF é gerado pelo servidor** (1 página por aluno); o **scoring vive na API**, não no
Python. Validado ponta a ponta.

Integração e envs em [tecnico/integracoes.md](../../tecnico/integracoes.md).
