---
name: implement-story
description: >-
  Orchestrate the TDD implementation of a sized, planned story — one fresh sub-agent per cycle,
  sequential, with mechanical (tool-run) validation, a git commit per validated cycle for durable
  resume, and calibratable user checkpoints. Use after plan-cycles, to build a story cycle by cycle.
---

# Implement Story

Drive a story's cycles to green **in plan order.** This skill is the **orchestrator** — it dispatches a
fresh implementer sub-agent per *behavioral* cycle and *independently validates* every cycle. It may
run *trivial gate cycles* inline (see **Core model**) — validation stays mechanical, so it never simply
trusts its own work.

## Authority (read first)

- The story's **plan** (`docs/stories/STORY-nnnn-plan.md`, or the inline cycles in the story) — the
  cycle spine and verification lane per cycle.
- `docs/guardrails.md` — patterns/smells the implementer references (passed to each sub-agent).
- `story-format.md` §5 — the story-close **gate** (incl. the candidates affirmation).
- `docs/tech-design.md` — its test-layers section.

## Core model

- **Sequential, never parallel.** Cycles are a dependency chain (cycle N's code is N+1's input).
- **Execution is calibrated by lane** (context load drives the choice):
  - **Behavioral cycles → always a fresh sub-agent.** Authoring a real test + implementation is
    high-context, and validation is a *judgment* (was red witnessed for the right reason? does the test
    assert the right behavior?) — so the **implementer ≠ verifier** separation must hold.
  - **Gate cycles → the orchestrator MAY run inline** when low-context (stub / scaffold / manifest /
    script-line, near-empty Green): validation is a *mechanical* gate it cannot fool, so independence
    isn't lost. **Escalate to a sub-agent** if a gate cycle carries real logic (non-trivial build
    script, codegen) or the story's cumulative context is bloating the orchestrator.
  - **Per-cycle commits hold either way** — durable checkpoints don't depend on how a cycle ran. A
    fresh sub-agent is re-seeded from repo state + the thin cycle spec, so its context is cheap.
- **Implementer ≠ verifier (for judgment).** On behavioral cycles the sub-agent implements and
  *reports evidence*; the orchestrator **independently validates by running the levers** — never by
  trusting the report. On inline gate cycles the separation relaxes because validation is a mechanical
  build/lint gate.
- **The orchestrator stays lean.** It retains only the **ledger, candidates, and validation results** —
  never full diffs. Diffs live in git and die with the sub-agent. This is what keeps it resumable
  across a whole story without its own context bloating.
- **Two lanes** (from the cycle's verification mode):
  - **Behavioral** — a real test at one of the project's test layers (property / snapshot / example —
    `tech-design.md`); canonical Red→Green→Refactor with **witnessed red**.
  - **Gate (infra)** — build/script/linter-bite; near-empty Green, the manifest/script *is* the
    deliverable (`story-format.md` §5).

## Setup (once per story)

Work on a **story branch** (branch from `main` first — never commit the run to `main`). The per-cycle
commit cadence below is the resume mechanism; using this skill is the standing request to commit.

## Per-cycle loop

For each cycle, in plan order:

### 1 — Dispatch a fresh implementer sub-agent
Dispatch the project's **`implementer` agent** (`.claude/agents/implementer.md` — its model is the
project's model policy, set at bootstrap; if the project defines no implementer agent, use a
general-purpose sub-agent inheriting the session model). Seed it with: the cycle's
**Red / Green / Refactor** spec, its **lane**, the relevant `guardrails.md` refs, and the
instruction to follow **canonical Red→Green→Refactor** and return a **structured report**:
- `summary` — one line.
- `red` — evidence the test/gate **failed first** (the failing output).
- `green` — evidence it now passes, **and that the full lint + test levers pass** — not just the new
  test. ("Green" = both levers green; running one and eyeballing the other is not a pass.)
- `scope` — attestation that it implemented **only** what the pinned Red requires; any behavior it
  consciously left for a later cycle is named here.
- `files` — files touched.
- `candidates` — novel guardrail cases, or **"none"** (the `guardrails.md` candidate loop).

**Pin the Red; leave Green latitude — but latitude is *how*, not *what*.** The sub-agent chooses the
implementation; it does **not** choose the scope. It implements **only what the pinned Red requires** —
behavior no current test pins is a defect, not initiative: it ships untested *and* it steals the next
cycle's witnessed red (the guardrails doc's canonical-TDD rule: "Green satisfies the pinned Red — no
more"). Say this in the seed explicitly. For a **behavioral** cycle, witnessed red is mandatory — you
don't take the worker's word for it. For a **gate** cycle, the "red" is the failing gate.

### 2 — 🛑 Independently validate (mechanical, not a re-read)
Run the gates the sub-agent does not control (the levers — the `test` and `lint` commands recorded
in `levers.json` at the repo root):
- [ ] The **test lever** — **full** suite, from clean (catches regressions, not just the new test).
      *(Gate lane: the relevant build/script gate.)*
- [ ] The **lint lever** — passes (format + lint + any architecture checks).
- [ ] **Scope & restraint check** — the diff touches only this cycle's expected files/layers (no
      cross-cycle creep) **and implements only what the pinned Red requires**. Behavior no test in
      *this* cycle pins is untested code or a stolen future red — reject it, even if it looks correct.
      Read the diff for logic the pinned Red does not exercise.
- [ ] **Red was witnessed** — evidence present (behavioral lane). If a later cycle's Red cannot be made
      to fail because an earlier cycle already built its behavior, that earlier cycle over-reached —
      flag it; don't paper over the missing red.
- [ ] The cycle's test cites its `AC-*`/`LAW-*` (behavioral), or the correct gate fired (infra).

The read is a spot-check on top; the tool runs are the gate.

**Bootstrap fallback.** Until the levers are defined (`levers.json`) and proven, substitute the raw
toolchain gates they will name — full build with warnings as errors, formatter check, linter with
warnings denied, and any architecture-boundary check done manually. Switch to the manifest's
commands the moment they exist.

### 3 — On pass: checkpoint durably
- **Commit** — message cites the cycle + `AC-*`/`LAW-*` id; end with the project's required commit
  trailer, if any (see the project's CLAUDE.md).
- **Update the plan ledger** — mark the cycle done (this is what resume reads).
- **Accumulate** the cycle's candidates.

### 4 — On failure: bounded retry, escalate once, then re-plan
Reject → feed back the **specific** failure → re-dispatch (fresh sub-agent), **bounded retries**.
When retries are exhausted, **escalate once to the project's `implementer-heavy` agent** (the
model policy's stronger tier), seeding it with the accumulated failure feedback — it may close the
cycle or return a mis-specification verdict. If it still won't close, **stop and route back to
`plan-cycles`/`write-stories`** — a cycle that won't close is a signal the plan or the sizing was
wrong, not something to grind on. Escalate to the user.

### 5 — 🛑 User checkpoint (calibratable cadence)
Announce briefly what the cycle did, then check whether to proceed. **Cadence is adjustable** —
default **per-cycle**; honor **run-to-end / run-N / prompt-on-failure-only** for trusted stretches.
Note: durable checkpoints (commit + ledger) happen **every** validated cycle regardless of prompt
cadence — resume is never coupled to being asked.

## Resume

On (re)start: read the plan ledger + `git log` to find the first incomplete cycle; resume there. The
repo is the source of truth.

## Story close (after the last cycle)

Satisfy the `story-format.md` §5 gate: every `AC-*` green and cited, both levers pass, and the
**affirmative candidates gate** — present the accumulated candidates, or affirm **"candidates: none."**
Then mark the story done and burn its disposable plan.

## Guardrails — what this skill never does

- **Never runs cycles in parallel** — the dependency chain forbids it.
- **Never accepts a self-report as validation** — it re-runs the levers itself.
- **Never skips witnessed red** on a behavioral cycle — that's the canonical-TDD guarantee.
- **Never lets a sub-agent build past its pinned Red** — minimal green. Over-building ships untested
  behavior and forfeits the next cycle's red; reject it in validation even when it "looks correct."
- **Never absorbs full diffs** — stays lean; git holds the detail.
- **Never grinds a persistently-failing cycle** — routes back to planning/sizing.
- **Never closes a story without the §5 gate**, including the candidates affirmation.
- **Never commits to `main`** — always a story branch.
