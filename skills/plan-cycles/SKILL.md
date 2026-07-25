---
name: plan-cycles
description: >-
  Turn a sized story into a thin, per-cycle implementation plan for a TDD implementer. Pins each
  cycle's Red (the failing test = the executable spec) precisely, and constrains Green/Refactor by
  reference into the project's guardrails doc — never by pre-writing code. Use after a story is
  written and sized, before implementation begins.
---

# Plan Cycles

Convert one **sized** story into the thin cycle spine a TDD implementer executes. The story already
enumerated its RGR cycles (its sizing check); this skill **annotates** that list — it does not
regenerate it.

## Authority (read first)

- `docs/guardrails.md` — the project's durable test/code/smell catalog cycles **reference** (never
  embed).
- `story-format.md` §5 — the story-close **gate** (incl. the guardrail-candidates affirmation).
- `docs/tech-design.md` — its **test-layers** section, and the architectural boundaries a cycle must
  respect.

This skill is the *procedure*; those docs are the *spec*. Load only the story plus the design surface
it implicates — never the whole spec.

## Core rules

- **Pin the Red; leave Green latitude.** Each cycle specifies its **failing test precisely** — that
  test *is* the spec. **Never pre-write the Green implementation in prose** (it pays twice and is a
  lossy spec). Green gets a one-line intent; the implementer writes the code.
- **Refactor by reference.** Point at the relevant `guardrails.md` pattern/smell entry; do not
  restate it.
- **Reference, never embed** — this is what keeps the plan thin.

## Procedure

### 0 — Intake
Load the story, `guardrails.md`, and the implicated design surface only.

### 1 — Precondition: the story is sized
Confirm the story passed its sizing check (≤ ~5 enumerated cycles, no tripped trigger unresolved). If
it is **unsized or oversized, stop and route back to `write-stories`** — never plan an oversized story
into cycles (that reproduces the long-document problem).

### 2 — Depth decision (calibrate to uncertainty)
- **Trivial** (≤3 cycles, no new contract, pure pattern-following) → annotate the cycles **inline in
  the story**; no separate document.
- **Has latitude** (new contract, novel test strategy, numerically-sensitive core logic) → a
  disposable plan at `docs/stories/STORY-nnnn-plan.md`, burned when the story closes.

### 3 — Annotate each cycle
For every enumerated cycle, produce a thin entry:
- **Red** — the exact failing test: name it, cite its `AC-*`/`LAW-*`, state what it asserts and at
  which of the project's test layers (a property test, a snapshot test, an example test — per
  `tech-design.md`). **For infra/tooling cycles, the "Red" is a failing gate** (build/script/
  linter-bite), not a test (`story-format.md` §5).
- **Green** — one line of intent. Latitude left to the implementer.
- **Refactor** — the `guardrails.md` pattern/smell to apply or watch for (by reference).

### 4 — 🛑 Checkpoint: approve the plan
Present the annotated spine — **especially the pinned Red tests**, since they are the spec — and
**stop for the human to approve** before implementation begins.

### 5 — Hand off
On approval, hand cycles to the TDD implementer **one at a time**, canonical Red → Green → Refactor.
Remind that the **story-close gate** (`story-format.md` §5) requires the guardrail-candidates
affirmation ("candidates: none" or entries appended to `guardrails.md`).

## Guardrails — what this skill never does

- **Never pre-writes the Green implementation in prose** — the test is the spec; Green is the
  implementer's.
- **Never re-embeds guardrail content** — it references `guardrails.md`.
- **Never plans an unsized/oversized story** — routes it back to `write-stories` first.
- **Never skips the candidates gate** — it reminds the implementer at hand-off.
- **Never loads the whole spec** — only the surface the story implicates.
