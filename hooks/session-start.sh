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

# Contract-version drift: the project's stamp (docs/.contract-version, written at
# bootstrap/upgrade) vs. the loaded plugin's version. Older stamp → one advisory line;
# equal, newer, missing tooling, or unparsable → silent (fail-open).
plugin_root=$(cd "$(dirname "$0")/.." 2>/dev/null && pwd) || plugin_root=""
plugin_ver=""
[ -n "$plugin_root" ] && [ -f "$plugin_root/.claude-plugin/plugin.json" ] && \
  plugin_ver=$(jq -r '.version // empty' "$plugin_root/.claude-plugin/plugin.json" 2>/dev/null)
if [ -n "$plugin_ver" ]; then
  if [ -f docs/.contract-version ]; then
    stamp=$(head -1 docs/.contract-version 2>/dev/null | tr -d '[:space:]')
    if [ -n "$stamp" ] && [ "$stamp" != "$plugin_ver" ] && \
       [ "$(printf '%s\n%s\n' "$stamp" "$plugin_ver" | sort -V 2>/dev/null | tail -1)" = "$plugin_ver" ]; then
      echo "- contract stamp v$stamp < plugin v$plugin_ver — run bootstrap-project to review contract upgrades"
    fi
  else
    echo "- no contract version stamp (docs/.contract-version) — run bootstrap-project to review contract upgrades; it writes the stamp"
  fi
fi
exit 0
