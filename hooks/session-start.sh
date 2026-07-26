#!/usr/bin/env bash
# SessionStart: inject a one-screen orientation for lifecycle projects.
# Fail-open discipline: any missing dependency or surprise → exit 0 silently.
command -v jq >/dev/null 2>&1 || exit 0
input=$(cat) || exit 0
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
[ -n "$cwd" ] && [ -f "$cwd/docs/story-format.md" ] || exit 0
cd "$cwd" 2>/dev/null || exit 0

echo "[agile-lifecycle] Project orientation:"
branch=$(git branch --show-current 2>/dev/null)
[ -n "$branch" ] && echo "- branch: $branch"

if [ -f docs/ledger.md ]; then
  open_rows=$(grep -E '^\|' docs/ledger.md 2>/dev/null \
    | grep -viE '^\| *Id *\||^\| *-+ *\|| done | fixed | closed | retired ' || true)
  if [ -n "$open_rows" ]; then
    echo "- outstanding work (docs/ledger.md):"
    printf '%s\n' "$open_rows" | sed 's/^/    /'
  else
    echo "- ledger: nothing outstanding"
  fi
else
  echo "- docs/ledger.md missing — contract upgrade available (run bootstrap-project)"
fi

if [ -f docs/debt.md ]; then
  debt_open=$(grep -cE '^\|.*\|[[:space:]]*open[[:space:]]*\|?[[:space:]]*$' docs/debt.md 2>/dev/null || true)
  [ "${debt_open:-0}" -gt 0 ] 2>/dev/null && echo "- open debt entries: $debt_open (docs/debt.md)"
fi
exit 0
