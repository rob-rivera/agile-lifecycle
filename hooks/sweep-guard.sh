#!/usr/bin/env bash
# PreToolUse (Bash|Read|Glob|Grep): deny filesystem sweeps rooted outside any
# project — find/du/rg from /, the home dir, /Users, /Volumes, or a Library
# tree. Born from a real incident: an implementer ran `find / -iname ...` for a
# file that lived in ~/.cargo/registry, and macOS attributed the whole walk to
# the embedding app as a burst of privacy prompts (Documents, Desktop, network
# volumes, other apps' data). A sweep from a global root is never the cheapest
# way to anything; the deny message teaches the scoped form.
#
# Deliberately NOT lifecycle-guarded (runs in any project the plugin loads):
# this is safety, not bookkeeping. Fail-open everywhere; requires jq.
# Surgical by design — it denies recursive walks FROM a dangerous root, not
# every absolute path: `git -C /Users/x/proj status`, `cat ~/.zshrc`, and
# `find ~/.cargo/registry/src -maxdepth 1` all pass untouched.
command -v jq >/dev/null 2>&1 || exit 0
input=$(cat) || exit 0
tool=$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null) || exit 0

# A dangerous root, as one shell word: / , /Users , /Users/<name> , /Volumes ,
# /Library , /System/Volumes/Data[/Users[/<name>]] , ~ , $HOME , and the
# Library dir under ~ or an explicit home. Nothing deeper matches.
home_re='(/Users/[A-Za-z0-9._-]+|~|\$HOME|\$\{HOME\})'
root_re="(/|/Users|/Volumes|/Library|/System/Volumes/Data(/Users(/[A-Za-z0-9._-]+)?)?|${home_re}(/Library)?)"
trail="([[:space:]\"']|\$)"
lead="(^|[;&|([:space:]\"'])"

deny() {
  jq -n --arg why "$1" \
    '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":$why}}' 2>/dev/null || exit 0
  exit 0
}

reason="[agile-lifecycle] Blocked: recursive filesystem sweep from a global root (/, home, /Users, /Volumes, a Library tree). These walks trip OS privacy prompts attributed to the embedding app and are never the cheapest path. Scope the search to the project, or to the specific known root that holds what you need (dependency sources live under ~/.cargo/registry/src/<registry>/, Claude data under ~/.claude/) — or ask the user where the file lives."

case "$tool" in
  Bash)
    cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
    [ -n "$cmd" ] || exit 0
    # Verbs that recurse by default, taking a dangerous root as an argument.
    if printf '%s' "$cmd" | grep -qE "${lead}(find|fd|du|tree|rg)([[:space:]]+[^;&|]*)?[[:space:]][\"']?${root_re}${trail}"; then
      deny "$reason"
    fi
    # grep/ls only when explicitly recursive (-r/-R/--recursive) onto a root.
    if printf '%s' "$cmd" | grep -qE "${lead}(grep|ls)[[:space:]][^;&|]*(-[A-Za-z]*[rR][A-Za-z]*|--recursive)[^;&|]*[[:space:]][\"']?${root_re}${trail}"; then
      deny "$reason"
    fi
    ;;
  Read|Glob|Grep)
    path=$(printf '%s' "$input" | jq -r '.tool_input.path // .tool_input.file_path // empty' 2>/dev/null) || exit 0
    [ -n "$path" ] || exit 0
    if printf '%s' "$path" | grep -qE "^${root_re}/?\$"; then
      deny "$reason"
    fi
    ;;
esac
exit 0
