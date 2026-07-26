#!/usr/bin/env bash
# PreToolUse (Bash): committing on main in a lifecycle project surfaces a
# confirmation — lifecycle work belongs on story/fix/refactor branches, but
# legitimate main commits exist (contract upgrades, doc edits). Ask, not deny.
command -v jq >/dev/null 2>&1 || exit 0
input=$(cat) || exit 0
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
[ -n "$cwd" ] && [ -f "$cwd/docs/story-format.md" ] || exit 0

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
printf '%s' "$cmd" | grep -qE 'git[[:space:]]+commit' || exit 0

branch=$(cd "$cwd" 2>/dev/null && git branch --show-current 2>/dev/null) || exit 0
[ "$branch" = "main" ] || [ "$branch" = "master" ] || exit 0

jq -n '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"[agile-lifecycle] This commit targets '"$branch"' — lifecycle work belongs on story/fix/refactor branches. Confirm this is a deliberate main-branch commit (contract upgrade, docs)."}}' 2>/dev/null || exit 0
exit 0
