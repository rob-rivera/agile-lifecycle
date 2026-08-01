---
name: orient
description: >-
  Greet the user and summarize what's next in this project, in one screen. On a lifecycle
  project, read the ledger, slice plan, and debt registry and lead with the next actionable
  item and the skill that advances it. On any other project, orient from the repo itself
  (branch, recent commits, working-tree state, README). Read-only — never starts the work it
  points at. Use at session start, after opening a project, or whenever the user asks "where
  was I?" / "what's next?".
---

# Orient

Greet the user and tell them what's next — one screen, leading with the answer. This skill is
the user-facing counterpart of the SessionStart orientation context: the hook injects the facts;
this turns them into a briefing. It is **read-only**: it points at the next move, it never makes
it.

## Procedure

### 1 — Read the state (lifecycle project)
If `docs/ledger.md` exists, this is a lifecycle project. Read, in order:
- `docs/ledger.md` — the outstanding rows (anything not *done*/*fixed*/*closed*/*answered*),
  and the most recently updated ones.
- `docs/slice-plan.md` or the slice plan section of `docs/tech-design.md` — the current slice
  and what remains in it.
- `docs/debt.md` — open entries (count them; name one or two only if they're the natural next
  work).
- `git log --oneline` (a handful) and current branch — where work physically stands (an open
  story branch means a story is mid-flight).

### 2 — Read the state (any other project)
No ledger → orient from the repo: current branch and working-tree state, the last few commits,
README/`CLAUDE.md` for what the project is, and anything obviously in flight (uncommitted
changes, TODO markers in recently touched files). Say plainly that the project has no lifecycle
contract — and that `bootstrap-project` / `bootstrap-legacy` adopt one, `bootstrap-prototype`
skips one on purpose — but only as a pointer, never as a push.

### 3 — Brief
One screen, in this order:
1. **Greeting + where you are** — project name, branch, one line on the state of play.
2. **What's next** — the single most actionable item (the first non-done ledger row in slice
   order; or mid-flight work on the current branch; or, contract-less, whatever the repo says
   is unfinished), and **the skill that advances it** (`plan-cycles` for a drafted story,
   `implement-story` for a planned one, resume for one in progress, `write-stories` when the
   ledger is empty).
3. **Also on the board** — the remaining outstanding items and the open-debt count, compressed
   to a line or two.

Then stop.

## Guardrails — what this skill never does

- **Never starts the work** — no skill invocation, no edits, no commits; it recommends the
  skill, the human invokes it.
- **Never dumps documents** — it summarizes; one screen is the bound.
- **Never guesses state** — everything it asserts comes from the ledger, the plan docs, or git;
  a project with no contract is oriented from the repo and said to be contract-less, plainly.
