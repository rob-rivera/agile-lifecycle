#!/usr/bin/env bash
# Stop: the ledger reconciliation gate. Blocks the stop (once) when the
# mechanical books don't balance: work-item files without ledger rows, or
# ledger rows without files. Presence checks only — status semantics are
# judgment and stay in the skills. Fail-open everywhere.
command -v jq >/dev/null 2>&1 || exit 0
input=$(cat) || exit 0

# Never loop: if a previous block already fired this stop, let it through.
active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false' 2>/dev/null) || exit 0
[ "$active" = "true" ] && exit 0

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
[ -n "$cwd" ] && [ -f "$cwd/docs/story-format.md" ] || exit 0
[ -f "$cwd/docs/ledger.md" ] || exit 0
cd "$cwd" 2>/dev/null || exit 0

drift=""

# Files without rows.
for f in docs/stories/STORY-*.md docs/bugs/BUG-*.md docs/refactors/REF-*.md docs/spikes/SPIKE-*.md; do
  [ -e "$f" ] || continue
  id=$(basename "$f" | grep -oE '^(STORY|BUG|REF|SPIKE)-[0-9]+') || continue
  grep -q "$id" docs/ledger.md 2>/dev/null || drift="${drift}
- $id ($f) has no row in docs/ledger.md"
done

# Rows without files.
for id in $(grep -oE '(STORY|BUG|REF|SPIKE)-[0-9]+' docs/ledger.md 2>/dev/null | sort -u); do
  found=0
  for g in docs/stories/"$id"* docs/bugs/"$id"* docs/refactors/"$id"* docs/spikes/"$id"*; do
    [ -e "$g" ] && { found=1; break; }
  done
  [ "$found" = 1 ] || drift="${drift}
- ledger row $id has no matching file under docs/"
done

[ -z "$drift" ] && exit 0

reason="[agile-lifecycle] Ledger drift — reconcile docs/ledger.md before stopping:${drift}
(Dedupe: add missing rows with the correct status, or remove/fix dangling rows.)"
jq -n --arg r "$reason" '{"decision":"block","reason":$r}' 2>/dev/null || exit 0
exit 0
