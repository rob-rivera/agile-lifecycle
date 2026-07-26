#!/usr/bin/env bash
# PostToolUse (Write|Edit): when a STORY/BUG/REF file is written and the
# ledger has no row for it, nudge immediately (non-blocking — the Stop gate
# is the backstop). Fail-open everywhere.
command -v jq >/dev/null 2>&1 || exit 0
input=$(cat) || exit 0
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
[ -n "$cwd" ] && [ -f "$cwd/docs/story-format.md" ] || exit 0

file_path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || exit 0
printf '%s' "$file_path" | grep -qE 'docs/(stories|bugs|refactors|spikes)/(STORY|BUG|REF|SPIKE)-[0-9]+' || exit 0
id=$(basename "$file_path" | grep -oE '^(STORY|BUG|REF|SPIKE)-[0-9]+') || exit 0

if [ -f "$cwd/docs/ledger.md" ] && grep -q "$id" "$cwd/docs/ledger.md" 2>/dev/null; then
  exit 0
fi

msg="[agile-lifecycle] $id was just written but docs/ledger.md has no row for it — add the row now (status per the current skill's transition)."
[ -f "$cwd/docs/ledger.md" ] || msg="[agile-lifecycle] $id was just written but docs/ledger.md does not exist — the contract upgrade (bootstrap-project) adds it; until then track $id manually."
jq -n --arg ctx "$msg" \
  '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":$ctx}}' 2>/dev/null || exit 0
exit 0
