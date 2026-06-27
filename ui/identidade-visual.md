---
quando_usar: escolher cor, tipografia, logo, checar contraste, definir tom de voz da marca
última_revisão: 2026-06
status: canônico
---

# Identidade visual

Fonte: skill `brand-lucida`. Uma marca, três frentes por cor (ver negocio/posicionamento.md). Tokens
de código em ui/design-tokens.md.

## Paletas
### Professor (azul)
| Uso | Hex | Pantone |
|---|---|---|
| Azul principal | `#007AFF` | 285 C |
| Azul escuro 01 (texto em bg claro) | `#1D14FF` | 2728 C |
| Azul escuro 02 | `#150BBC` | 2738 C |
| Azul claro (bg suave/accents) | `#7FBDF4` | 2905 C |

### Instituição (roxo)
| Uso | Hex | Pantone |
|---|---|---|
| Roxo principal | `#6C3CFB` | 2665 C |
| Roxo escuro 01 (texto em bg claro) | `#4D30CE` | 2725 C |
| Roxo escuro 02 | `#1E0A96` | 2736 C |
| Roxo claro (bg suave/accents) | `#927AFC` | 2645 C |

### Aluno (azul claro)
Frente de marca **futura** (sem auth dedicada hoje): azul claro `#5CDAFF`.

### Neutros (todas as frentes)
Azul super escuro `#051E2C` (fundo dark) · Off white `#F9F5EA` · Preto `#000000` · Branco `#FFFFFF` ·
escala de cinza `gray-50`…`gray-800` + `ink #0A0A0A`.

**Regra**: nunca misturar azul, roxo e azul claro na mesma tela — ao entrar numa frente, toda a
hierarquia herda o tom.

## Contraste (WCAG)
- `#007AFF` em branco = 3.04:1 → **AA só para texto grande** (≥ 24px, ou ≥ 18.66px bold). Para texto
  pequeno, use `#1D14FF` (8.2:1).
- `#6C3CFB` em branco ≈ 4.98:1 → AA para texto normal ≥ 14px. Texto pequeno → `#4D30CE` (~7.3:1).

## Tipografia
- **Poppins** — toda a UI (corpo e títulos).
- **Instrument Serif Italic** — só palavras de ênfase **dentro de títulos**, nunca corpo.
- Hierarquia: H1 Poppins Regular 70pt/lh1 · H2 40pt/lh1 · corpo 20pt/lh1 · detalhe Light 18pt/lh1.1.
- Nunca: esticar/distorcer, outline em texto, justificar, kern apertado, trocar a fonte.

## Logotipo
- Tamanho mínimo: **160px** (logo completo), **40px** (só o símbolo).
- Área de proteção: largura da letra "c" do logotipo, em todos os lados.
- Posições: 4 cantos + centro. Cores: colorida (azul+preto), preto ou branco.
- Nunca: rotacionar, mudar proporções, adicionar outline, recolorir, acrescentar elementos.

## Tom de voz
Claro, direto e de apoio ao professor. Copy de UI sempre em pt-BR (ver regras/comunicacao.md).
