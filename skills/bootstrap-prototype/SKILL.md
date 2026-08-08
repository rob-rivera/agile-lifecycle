---
name: bootstrap-prototype
description: >-
  Turn a prompt and an empty folder into a runnable prototype — an answer in executable form,
  not production. Asks only the questions whose answers change what gets built; everything else
  becomes a named assumption in the PROTOTYPE.md marker, which also prints the price (no
  contract, no tests, no safety net) and the graduation gate: keep it → bootstrap-legacy
  excavates it into the contract; discard it → bootstrap-project starts clean with what was
  learned. Use on an empty/near-empty folder to find out whether an idea is worth building
  right. Refuses projects with a contract and un-marked brownfield code.
---

# Bootstrap Prototype

Build the thing fast so the human can find out whether it's worth building *right*. The
lifecycle's invariants — story-driven production, test-driven development — govern **production**
code; a prototype is not production. It is spike's sibling: where a spike answers a question with
research, a prototype answers "is this worth building?" with a runnable artifact. The same rule
applies at the end: **knowledge survives; code survives only by graduating through a real gate.**

This is the plugin's one fast lane, and it stays legitimate only because the fence is part of the
skill: the `PROTOTYPE.md` marker prints the price on the artifact, and graduation is never
silent.

## Authority (read first)

- This plugin's `templates/prototype.md` — the marker template.
- `bootstrap-project`'s greenfield tiers (what counts as empty) and `bootstrap-legacy` (the
  keep-it graduation gate).

## Procedure

### 0 — Detect state & route (the fences)
- Contract present (`docs/story-format.md`) → **refuse**; work enters through `write-stories`.
- Real code without a `PROTOTYPE.md` marker (brownfield by `bootstrap-project`'s tiers) →
  route to `bootstrap-legacy`; adopting un-marked code is excavation, not prototyping.
- `PROTOTYPE.md` present → 🛑 **re-entry checkpoint**: "still exploring, or is this becoming
  real?" Extend only on an explicit *still exploring*; *becoming real* routes to the graduation
  question (phase 5). This checkpoint is the defense against the prototype that grows one
  feature at a time and never graduates.
- Empty/near-empty → proceed. No git repo → offer `git init` first (cheap rollback and resume,
  prototype or not).

### 1 — 🛑 The critical-question interview (bounded)
From the prompt, ask **only** questions whose answers change what gets built — the core
interaction to demo, the form it takes (CLI, page, desktop, script), whether data persists.
Hard bound: a handful. Tempted past it? That question's answer is an **assumption, not a
question** — name it and move on. Present back one screen: what will be built, the critical
answers, and the assumptions ledger so far. **Stop for approval.**

### 2 — Write `PROTOTYPE.md` first
From `templates/prototype.md`: the prompt verbatim (dated), the critical answers, the
assumptions ledger, the graduation rule. Written **before code** so the marker can never be the
step that got skipped.

### 3 — Build
The smallest artifact that answers the question. Boring stack defaults consistent with the
user's environment unless a critical answer chose otherwise. **If the prototype has a UI, load
the `frontend-design` skill before building** (when installed — check the skill listing; absent,
proceed without and note it in the assumptions ledger): a prototype's look is part of what the
human judges, and the skill's anti-default pressure costs nothing here since there is no TDD
discipline to collide with. No stories, no TDD — speed is the
point and the marker prints the price. **Build inline by default; MAY delegate** (the suite's
delegation pattern) a larger build — several files, a whole page or app — to the plugin's
**`builder` agent** (mid-tier **by its own `model:` line**, like the surveyor and upgrader: a
prototype has no contract and no model policy, and a bare general-purpose dispatch would inherit
the session's full-weight model — the tier must be pinned in the agent, never inherited), seeded
with the marker's critical answers and assumptions ledger; the orchestrator still launches the
result via the `run` lever itself before the demo. Assumptions surfaced mid-build go **into the ledger**
(dated), not into chat narration. Resist gold-plating: a prototype that grows features stops
answering and starts shipping.

### 4 — Levers, minimal
`levers.json` with at least `run` — plus `stop` when `run` is long-running (a server someone
can't kill is as unanswerable as one they can't launch). `test`/`lint` absent **by design**;
their absence is part of the price the marker prints.

### 5 — 🛑 Demo & the graduation question
Launch it via the `run` lever, present what it answers and the final assumptions ledger, then
ask the graduation question explicitly — every path is the human's call:
- **Still exploring** — iterate here; the marker stays.
- **Keep it** — route to **`bootstrap-legacy`**: the prototype is now real code without a
  contract, which is exactly what that skill adopts. `PROTOTYPE.md` is its highest-trust
  prior-knowledge source — intent recorded at authoring time, not excavated — though its claims
  still enter as `observed` until a human ratifies them.
- **Discard** — route to **`bootstrap-project`**: copy the marker's knowledge out first; the
  code dies (the spike rule).

## Guardrails — what this skill never does

- **Never runs where a contract exists** — stories are the only way work enters a lifecycle
  project.
- **Never touches un-marked brownfield code** — that is excavation (`bootstrap-legacy`).
- **Never asks a question an assumption could cover** — the bounded interview is the fence;
  the ledger is the outlet.
- **Never writes code before `PROTOTYPE.md`** — the marker is not optional paperwork; it is
  what keeps the fast lane honest.
- **Never presents prototype code as production** — no tests and no contract is a price,
  printed on the marker, paid at graduation (characterization is `bootstrap-legacy`'s job).
- **Never extends an existing prototype past the re-entry checkpoint** — "one more feature"
  is how prototypes ship untested.
- **Never graduates silently** — keep-it goes through `bootstrap-legacy`'s gate; there is no
  other path from prototype to production.
