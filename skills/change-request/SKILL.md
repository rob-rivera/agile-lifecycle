---
name: change-request
description: >-
  The compressed lane for small behavioral changes: one invocation, one approval, full TDD
  discipline. Runs the design-contradiction gate and a tightened sizing check at intake — a
  change that is really a story (>2 cycles, a new contract, an unknown) routes to write-stories
  instead of being ground through here. Use when the user asks for a change that feels too small
  for the full write-stories → plan-cycles → implement-story ceremony.
---

# Change Request

Make one **small behavioral change** with the whole discipline and a fraction of the ceremony:
the story card, cycle plan, and go-ahead collapse into **one checkpoint**; the invariants —
design gate, witnessed red, levers, close gate, ledger — are untouched. **This lane compresses
ceremony, never sizing and never discipline.** Its defining move is knowing when to refuse:
a change that doesn't fit routes to `write-stories`, with the intake work handed over as the
story's head start.

## Authority (read first)

- `docs/story-format.md` — §3 (sizing vector; this lane tightens it), §5 (the close gate),
  §7 (the design-contradiction gate), §8 (craft anchors).
- `docs/guardrails.md` — canonical TDD rules; refactor references.
- `docs/tech-design.md` — test layers, and the design surface the change implicates (load only
  that surface).

## Procedure

### 0 — Intake: route by nature, then gate, then size

**Nature check** — this lane is for *small new/changed behavior* only:
- Observable symptom (wrong output, crash, measurable problem) → **`fix-bug`**.
- Structure-only, no observable change → **`refactor-pass`**.
- A decidable open question → **`spike`**.

**Design-contradiction gate** (`story-format.md` §7) — same gate as `write-stories`:
- Extension → proceed.
- Conflict with an `observed` entry → the ratification prompt may resolve inline (the human's
  answer recorded either way, dated).
- **Contradiction with a settled rule / `LAW-*` → route to `write-stories`.** A change that
  needs the design renegotiated is not small, whatever its diff size.

**Tightened sizing** — fill the §3 vector as usual, with three rows pinned stricter:
- **RGR cycles ≤ 2**, each enumerable now.
- **New load-bearing contracts: 0.**
- **Genuine unknowns: 0.**
The remaining rows (≤1 layer's contract changes, AC independence, one-card) hold as written.
**Any trip → STOP: recommend `write-stories`** and hand over the filled vector, the gate
result, and the drafted ACs — the intake work *is* the story's head start, never wasted.

### 1 — 🛑 The change card (one approval)

Present one screen — this single checkpoint approves the story, the plan, and the go-ahead:
- **Summary** — `As a <role>, I want <capability>, so that <outcome>` (§8 anchors apply).
- **Acceptance criteria** — Given/When/Then, independently verifiable, citing `LAW-*` ids.
- **The filled sizing vector** — showing the tightened rows green.
- **Inline cycle annotations** (per `plan-cycles`' rules: pin the Red precisely — the failing
  test, its layer, its citations; Green one line; Refactor by `guardrails.md` reference).

On approval: write the card to `docs/stories/STORY-nnnn-<slug>.md` (**standard STORY id and
file** — a change-request is a story driven through the compressed lane; the ledger, hooks, and
registries need no new id family), add the ledger row (*in progress*), branch `story/<nnnn>-<slug>`.

### 2 — Implement (canonical RGR, execution calibrated)

Per cycle, in order: witnessed Red → minimal Green → Refactor by reference. The delegation
pattern applies:
- **Inline** for low-context cycles — validation stays mechanical (the levers, which the
  executor cannot fool).
- **Dispatch the project's `implementer`** when a cycle carries real context load — and prefer
  dispatching for **UI-facing cycles**: the UI-craft preload (and the recorded Look & feel
  requirements it works within) lives in the implementer's context, not the orchestrator's.
- **No escalation tier in this lane.** A cycle that fails its bounded retries is evidence the
  change was not small — stop, route to `write-stories`/`plan-cycles`, work so far preserved
  on the branch.

Commit per validated cycle (message cites the STORY id + `AC-*`/`LAW-*`; project trailer).
**Scope discovery mid-flight** (a third cycle, a hidden contract, an unknown) is the same
signal: stop and route — never grow the change in place.

### 3 — Close (the full §5 gate, nothing waived)

- Every AC green and cited; both levers pass — run by the orchestrator, never trusted from a
  report.
- **Candidates** appended to `guardrails.md` or "candidates: none"; **debt** recorded or
  "debt: none" — affirmative, never silent.
- Where an AC needs a real-app witness, 🛑 stop for it; when validation is fully mechanical,
  present the evidence and merge. Ledger row → *done*.

## Guardrails — what this skill never does

- **Never absorbs a story.** Tripped sizing, a design contradiction, a failed-retries cycle, or
  mid-flight scope discovery all route to `write-stories` — the intake/branch work rides along.
- **Never relaxes discipline.** Witnessed red, minimal green, levers, the §5 close gate, and
  the ledger row are identical to the full lane.
- **Never adds a new id family** — change-requests are STORY rows; the machinery stays whole.
- **Never skips the design-contradiction gate** — small is a size, not an exemption.
- **Never merges on a self-report** — the orchestrator runs the levers itself.
- **Never ships a ghost change** — no diff lands without its story card and ledger row.
