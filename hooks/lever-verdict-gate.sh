#!/usr/bin/env bash
# SubagentStop (implementer | implementer-heavy): the lever verdict gate. An
# implementer may not return while its report claims green without evidence:
# for every verdict-bearing lever the project records (test, lint — non-null
# in levers.json), the LAST `LEVER <name> VERDICT=…` line the wrapper printed
# INTO A TOOL RESULT in this sub-agent's own transcript must be PASS. Tool
# results are the harness's record, not the model's prose — a pasted verdict
# line in the report proves nothing and is not consulted when the transcript
# is available.
#
# The honest way out is not a PASS: a report whose `outcome:` field is
# anything but green (`failed`, `blocked`, `lever-hang`, `mis-specified`)
# passes the gate — the orchestrator routes those. What the gate refuses is
# the third thing: silence, or a green claim the transcript does not back.
#
# Blocks once (stop_hook_active guard). Fail-open everywhere; requires jq.
command -v jq >/dev/null 2>&1 || exit 0
input=$(cat) || exit 0

active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null) || exit 0
[ "$active" = "true" ] && exit 0

agent_type=$(printf '%s' "$input" | jq -r '.agent_type // empty' 2>/dev/null) || exit 0
[ -n "$agent_type" ] || exit 0
printf '%s' "$agent_type" | grep -qE '(^|:)implementer(-heavy)?$' || exit 0

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
[ -n "$cwd" ] && [ -f "$cwd/levers.json" ] || exit 0
levers="$cwd/levers.json"

required=""
for n in test lint; do
  c=$(jq -r --arg n "$n" '.[$n] | if type=="string" then . else (.command // empty) end' "$levers" 2>/dev/null)
  [ -n "$c" ] && required="$required $n"
done
[ -n "$required" ] || exit 0

last=$(printf '%s' "$input" | jq -r '.last_assistant_message // empty' 2>/dev/null)

# Honest non-green outcome → let it through; the orchestrator routes it.
if printf '%s' "$last" | grep -qiE '(^|[[:space:]*`_-])outcome`?[[:space:]]*[:=][[:space:]]*[*`_]*(failed|blocked|lever-hang|mis-?specified|not-green)'; then
  exit 0
fi

# Locate this sub-agent's transcript: <project-dir>/<session_id>/subagents/agent-<agent_id>.jsonl
# (transcript_path is the parent session's file; if it already IS an agent file, use it).
tp=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
sid=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null)
aid=$(printf '%s' "$input" | jq -r '.agent_id // empty' 2>/dev/null)
sub=""
case "$(basename "${tp:-x}")" in agent-*.jsonl) sub="$tp";; esac
[ -z "$sub" ] && [ -n "$tp" ] && [ -n "$sid" ] && [ -n "$aid" ] && sub="$(dirname "$tp")/$sid/subagents/agent-$aid.jsonl"
[ -n "$sub" ] && [ -f "$sub" ] || sub=""

# No transcript and no final message → nothing to judge; fail open.
[ -n "$sub" ] || [ -n "$last" ] || exit 0

missing=""
for n in $required; do
  if [ -n "$sub" ]; then
    v=$(grep -F '"tool_result"' "$sub" 2>/dev/null | grep -oE "LEVER $n VERDICT=[A-Z]+" | tail -1 | sed 's/.*=//')
    src="transcript"
  else
    v=$(printf '%s' "$last" | grep -oE "LEVER $n VERDICT=[A-Z]+" | tail -1 | sed 's/.*=//')
    src="report"
  fi
  [ "$v" = "PASS" ] && continue
  missing="${missing}
- $n: ${v:-no verdict found} (${src})"
done
[ -z "$missing" ] && exit 0

reason="[agile-lifecycle] Lever verdict gate — your report cannot close as green yet:${missing}
Green means \`scripts/lever <name>\` printed VERDICT=PASS for each required lever in THIS session (run it in the foreground with a Bash timeout above its cap; the verdict line must appear in a tool result, not just in your prose). If the lever did not pass, do not retry it unchanged and do not background it: report honestly — set \`outcome:\` to \`failed\` (your Green is wrong), \`lever-hang\` (VERDICT=HANG/CAP — quote the state dump), \`blocked\`, or \`mis-specified\` — and the orchestrator will route it."
jq -n --arg r "$reason" '{"decision":"block","reason":$r}' 2>/dev/null || exit 0
exit 0
