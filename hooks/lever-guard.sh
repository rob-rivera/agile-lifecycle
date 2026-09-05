#!/usr/bin/env bash
# PreToolUse (Bash): the lever guard. Two checks, both only in projects with a
# levers.json in the cwd; fail-open everywhere, requires jq.
#
# 1. A verdict-bearing lever (test / lint / bench) run BARE — the exact command
#    recorded in levers.json, as its own command segment — is denied and pointed
#    at `scripts/lever <name>`: the wrapper runs it under a watchdog and ends in
#    a verdict line the SubagentStop gate can read. Scoped runs (`cargo test
#    foo::bar`, a single file) are NOT the lever and pass untouched — a
#    witnessed red needs them.
# 2. A wrapper invocation whose Bash-tool timeout is below the lever's cap is
#    denied with the timeout to pass: otherwise the tool kills the wrapper
#    before it can speak, and the verdict is lost. Skipped for background runs.
command -v jq >/dev/null 2>&1 || exit 0
input=$(cat) || exit 0
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
[ -n "$cwd" ] && [ -f "$cwd/levers.json" ] || exit 0
levers="$cwd/levers.json"
jq -e 'type=="object"' "$levers" >/dev/null 2>&1 || exit 0

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
[ -n "$cmd" ] || exit 0

deny() {
  jq -n --arg why "$1" \
    '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":$why}}' 2>/dev/null || exit 0
  exit 0
}

lever_cmd() {
  jq -r --arg n "$1" '.[$n] | if type=="string" then . else (.command // empty) end' "$levers" 2>/dev/null
}
lever_opt() {
  jq -r --arg n "$1" --arg k "$2" '.[$n] | if type=="object" then (.[$k] // empty) else empty end' "$levers" 2>/dev/null
}

# ---- 2. wrapper invocations: enough timeout for the cap -------------------------------
bg=$(printf '%s' "$input" | jq -r '.tool_input.run_in_background // false' 2>/dev/null)
if [ "$bg" != "true" ]; then
  names=$(printf '%s' "$cmd" | grep -oE '(^|[;&|([:space:]])(bash[[:space:]]+|sh[[:space:]]+)?(\./)?scripts/lever[[:space:]]+[A-Za-z0-9_-]+' 2>/dev/null \
    | grep -oE '[A-Za-z0-9_-]+$' | sort -u)
  if [ -n "$names" ]; then
    timeout=$(printf '%s' "$input" | jq -r '.tool_input.timeout // empty' 2>/dev/null)
    [ -n "$timeout" ] || timeout="${BASH_DEFAULT_TIMEOUT_MS:-120000}"
    cap_override=$(printf '%s' "$cmd" | grep -oE -- '--cap[[:space:]]+[0-9]+' | tail -1 | grep -oE '[0-9]+$')
    for n in $names; do
      cap="${cap_override:-$(lever_opt "$n" cap)}"; cap="${cap:-540}"
      need=$(( (cap + 30) * 1000 ))
      if [ "$timeout" -lt "$need" ] 2>/dev/null; then
        deny "[agile-lifecycle] scripts/lever $n has a cap of ${cap}s but this Bash call's timeout is ${timeout}ms — the tool would kill the wrapper before it prints its verdict. Re-run the same command with the Bash tool's timeout parameter set to at least ${need} (ms). If that exceeds the tool's maximum, lower the lever's cap in levers.json (or pass --cap) instead."
      fi
    done
  fi
fi

# ---- 1. bare verdict-lever commands ----------------------------------------------------
# Split the command into segments on && || ; | and newlines; a segment that IS a
# lever's recorded command (whitespace-normalized) is the bare full run.
# Redirections (2>&1, >/dev/null, <file) are dropped before comparing — they don't change the run.
norm() { printf '%s' "$1" | tr '\n' ' ' | sed -E 's/[[:space:]][0-9]*[<>]&?[>]?[[:space:]]*[^[:space:]]*//g; s/[[:space:]]+/ /g; s/^ //; s/ $//'; }
segments=$(printf '%s\n' "$cmd" | awk '{ gsub(/&&|\|\||;|\|/, "\n"); print }')
for n in test lint bench; do
  raw=$(lever_cmd "$n"); [ -n "$raw" ] || continue
  rawn=$(norm "$raw")
  printf '%s\n' "$segments" | while IFS= read -r seg; do
    segn=$(norm "$seg")
    [ "$segn" = "$rawn" ] && echo HIT
  done | grep -q HIT || continue
  deny "[agile-lifecycle] That is the project's bare \`$n\` lever. Run it through the wrapper instead: \`scripts/lever $n\` (Bash timeout ≥ $(( ( $( [ -n "$(lever_opt "$n" cap)" ] && lever_opt "$n" cap || echo 540 ) + 30 ) * 1000 )) ms). The wrapper runs it in the foreground under a watchdog and ends in one verdict line (PASS / FAIL / HANG / CAP) that your report — and the stop gate — can cite; a bare run has no verdict and a hang looks like a slow suite. Scoped runs (one test, one file) are not the lever and need no wrapper."
done
exit 0
