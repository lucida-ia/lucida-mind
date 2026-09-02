#!/usr/bin/env bash
# Detecta divergência entre esta base e o código do lucida-monorepo.
#
# Por que existe: a base ficou 7 semanas errada sem nenhum sinal (jul-ago/2026). O que rotou não foi
# prosa — foi contagem, enum e tabela, que mudam num commit só. Este script confere exatamente essa
# classe de fato. Prosa envelhece devagar e continua sendo revisão humana.
#
# Uso:
#   ./check-drift.sh                      # assume ../lucida-monorepo
#   ./check-drift.sh /caminho/do/monorepo
#   LUCIDA_MONOREPO=/caminho ./check-drift.sh
#
# Sai com 0 se tudo bate, 1 se algo divergiu (serve em CI).
#
# Quando FALHAR: o código ganha. Corrija o doc citado, não o código — e suba o `última_revisão` dele.

set -uo pipefail

REPO="${1:-${LUCIDA_MONOREPO:-$(cd "$(dirname "$0")/.." && pwd)/lucida-monorepo}}"

if [ ! -d "$REPO/apps/api/src/domains" ]; then
  echo "erro: não achei o lucida-monorepo em '$REPO'"
  echo "      passe o caminho como argumento ou defina LUCIDA_MONOREPO."
  exit 2
fi

API="$REPO/apps/api/src"
WEB="$REPO/apps/web/src"
fail=0

# check <doc que afirma> <o que é> <esperado pela base> <obtido do código>
check() {
  if [ "$3" = "$4" ]; then
    printf '  ok     %s\n' "$2"
  else
    printf '  FALHA  %s\n         base (%s) diz: %s\n         código diz:      %s\n' "$2" "$1" "$3" "$4"
    fail=1
  fi
}

echo "conferindo $REPO"
echo

echo "tecnico/dominios.md"
check "dominios.md" "número de bounded contexts" \
  "27" "$(find "$API/domains" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')"

echo
echo "tecnico/integracoes.md"
for rota in expire-credits dispatch-exam-window-notifications invoicing/process-pending rescue-exam-generation; do
  if grep -rqs -- "/v1/internal/$rota" "$API"; then
    printf '  ok     cron /v1/internal/%s existe\n' "$rota"
  else
    printf '  FALHA  cron /v1/internal/%s NÃO existe mais no código\n' "$rota"
    fail=1
  fi
done
check "integracoes.md" "total de rotas /v1/internal" \
  "4" "$(grep -rhos -- '"/v1/internal/[a-z/-]*"' "$API" | sort -u | wc -l | tr -d ' ')"
check "integracoes.md/glossario.md" "escopos de API key" \
  "7" "$(grep -hos -E '"[a-z]+:[a-z]+"' "$API/domains/api-access/domain/api-key-scope.ts" | sort -u | wc -l | tr -d ' ')"

echo
echo "tecnico/ai-ops.md + tecnico/billing-ledger.md"
check "ai-ops.md" "default do OPENAI_MODEL" \
  "gpt-4.1-mini" "$(grep -s 'OPENAI_MODEL' "$API/env.ts" | grep -os -E 'default\("[^"]+"\)' | grep -os -E '"[^"]+"' | tr -d '"')"
# Esta asserção nasceu ao contrário: a revisão de 2026-08-25 afirmou que o verificador tinha sido
# removido, porque procurou a env só no env.ts. Ela é lida de process.env direto. O check existe para
# fixar o fato certo — o verificador EXISTE e a env É o override dele.
check "ai-ops.md" "override de modelo do verificador (R2_VERIFIER_MODEL)" \
  "1" "$(grep -rls 'R2_VERIFIER_MODEL' "$API" 2>/dev/null | wc -l | tr -d ' ')"
check "billing-ledger.md" "base de geração de prova" \
  "250" "$(grep -os -E 'BASE_CREDITS = [0-9]+' "$API/domains/ai-ops/domain/exam-pricing.ts" | grep -os -E '[0-9]+')"
check "billing-ledger.md" "crédito por questão (simple/analytical/reflective/contextual)" \
  "25 42 45 45" "$(grep -os -E '^  (simple|analytical|reflective|contextual): [0-9]+' "$API/domains/ai-ops/domain/exam-pricing.ts" | grep -os -E '[0-9]+' | tr '\n' ' ' | sed 's/ $//')"
check "billing-ledger.md" "crédito por questão aberta" \
  "60" "$(grep -os -E 'PER_OPEN_QUESTION = [0-9]+' "$API/domains/ai-ops/domain/exam-pricing.ts" | grep -os -E '[0-9]+')"
check "billing-ledger.md" "crédito por resposta aberta corrigida" \
  "30" "$(grep -os -E 'CREDITS_PER_GRADED_ANSWER = [0-9]+' "$API/domains/ai-ops/domain/grading-pricing.ts" | grep -os -E '[0-9]+')"
check "billing-ledger.md + monetizacao-creditos.md" "plano de aula por segmento (FUND/MEDIO/FACUL/INFO)" \
  "300 300 400 350" "$(grep -os -E '^  (FUNDAMENTAL|MEDIO|FACULDADE|INFOPRODUTOR): [0-9]+' "$API/domains/ai-ops/domain/lesson-plan-pricing.ts" | grep -os -E '[0-9]+' | tr '\n' ' ' | sed 's/ $//')"

echo
echo "negocio/monetizacao-creditos.md"
check "monetizacao-creditos.md" "preço dos 4 planos em centavos" \
  "4990 47900 9990 95900" "$(grep -os -E 'priceCents: [0-9]+' "$API/domains/billing/domain/plan.ts" | grep -os -E '[0-9]+' | tr '\n' ' ' | sed 's/ $//')"
check "monetizacao-creditos.md" "créditos por ciclo dos 4 planos" \
  "5_000 60_000 15_000 180_000" "$(grep -os -E 'creditsPerCycle: [0-9_]+' "$API/domains/billing/domain/plan.ts" | grep -os -E '[0-9_]+' | tr '\n' ' ' | sed 's/ $//')"
check "monetizacao-creditos.md + integracoes.md" "kill-switch do PIX" \
  "false" "$(grep -os -E 'PIX_TOPUP_ENABLED = (true|false)' "$API/domains/billing/presentation/billing-controller.ts" | grep -os -E '(true|false)')"

echo
echo "produto/glossario.md + tecnico/dominios.md"
check "glossario.md" "modo de aplicação da prova" \
  '"off" | "strict"' "$(grep -os -E 'SecurityLevel = "[a-z]+" \| "[a-z]+"' "$API/domains/exam/domain/exam.ts" | sed 's/.*SecurityLevel = //')"
check "dominios.md" "limite da descrição da prova" \
  "10000" "$(grep -os -E 'DESCRIPTION_MAX = [0-9]+' "$API/domains/exam/domain/exam.ts" | grep -os -E '[0-9]+')"

echo
echo "tecnico/eventos-posthog.md"
check "eventos-posthog.md" "eventos server-side" \
  "10" "$(grep -cs -E '^  [a-zA-Z]+: "' "$API/shared/observability/event-names.ts")"
check "eventos-posthog.md" "eventos client-side na taxonomia" \
  "19" "$(grep -cs -E '^  [a-zA-Z]+: "' "$WEB/features/analytics/events.ts")"

echo
echo "ui/design-tokens.md"
check "design-tokens.md" "primitivos em components/ui" \
  "15" "$(find "$WEB/components/ui" -name '*.tsx' ! -name '*.test.tsx' | wc -l | tr -d ' ')"

echo
echo "tecnico/framework-claude.md"
check "framework-claude.md" "skills" \
  "4" "$(find "$REPO/.claude/skills" -name 'SKILL.md' | wc -l | tr -d ' ')"
check "framework-claude.md" "agentes" \
  "9" "$(find "$REPO/.claude/agents" -name '*.md' | wc -l | tr -d ' ')"
check "framework-claude.md" "comandos" \
  "14" "$(find "$REPO/.claude/commands" -name '*.md' | wc -l | tr -d ' ')"
check "framework-claude.md" "hooks (7 guardrails + o runner de teste)" \
  "8" "$(find "$REPO/.claude/hooks" -maxdepth 1 -type f \( -name '*.py' -o -name '*.sh' \) ! -name '_hooklib.py' | wc -l | tr -d ' ')"

echo
echo "navegação"
broken=$(python3 - "$(cd "$(dirname "$0")" && pwd)" <<'PY'
import os, re, sys
base = sys.argv[1]
fence = re.compile(r"```.*?```", re.S)
link = re.compile(r"\]\(([^)#]+\.md)[^)]*\)")
bad = []
for root, dirs, files in os.walk(base):
    dirs[:] = [d for d in dirs if d not in (".git", ".obsidian")]
    for name in files:
        if not name.endswith(".md"):
            continue
        path = os.path.join(root, name)
        text = fence.sub("", open(path, encoding="utf-8").read())  # exemplo em bloco de código não é link
        for target in link.findall(text):
            if not os.path.exists(os.path.normpath(os.path.join(root, target))):
                bad.append(f"{os.path.relpath(path, base)} -> {target}")
for b in bad:
    print(b)
PY
)
if [ -z "$broken" ]; then
  printf '  ok     todos os links entre docs resolvem\n'
else
  printf '%s\n' "$broken" | while IFS= read -r line; do
    printf '  FALHA  link quebrado: %s\n' "$line"
  done
  fail=1
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "tudo bate. (Isto não certifica a prosa — só contagem, enum e tabela.)"
else
  echo "divergiu. O código ganha: corrija o doc citado e suba o 'última_revisão' dele."
fi
exit "$fail"
