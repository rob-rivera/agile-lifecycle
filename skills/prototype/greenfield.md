# prototype — greenfield fork

Reached from `SKILL.md` phase 0: no contract, empty/near-empty folder. The router's guardrails
apply throughout. Phases continue from the router's phase 0.

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
