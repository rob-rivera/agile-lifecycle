---
name: spike
description: >-
  Deep, budgeted research into a decidable question: the heavy-duty exploration lane for
  feasibility checks, approach selection, external/ecosystem research, codebase archaeology, and
  measured experiments. Pins the question, declares a budget, delegates gathering to cheap
  agents, and synthesizes an evidence-cited recommendation the human decides on. Spike code never
  merges — knowledge survives, code dies. Use when a story trips the unknowns trigger, an Open
  Question blocks work, or the user asks for real research before a decision.
---

# Spike

Answer one **decidable question** with evidence, inside a declared budget. The suite's core move
applies here too: **pin the spec, leave latitude** — stories pin the Red; a spike pins the
*question*. An unpinned spike is open-ended wandering dressed as research; the frame checkpoint
exists to prevent exactly that.

Origins: a `write-stories` sizing check tripping the unknowns trigger (story-format §3–§4, the
SPIDR **S** lens), an Open Question in `docs/design.md` blocking a story, `plan-cycles` hitting a
novel-strategy uncertainty, or a direct request for research before a decision.

## Where deep reasoning goes

Spend the heavy model (and any extended-thinking request) on **framing and synthesis** — the two
places judgment lives. Gathering is delegated to the cheap tiers: `surveyor` for code,
`researcher` for the outside world, `implementer` for probes. Never burn orchestrator-weight
tokens reading documentation.

## Procedure

### 0 — 🛑 Frame (the question is the spec)
Assign a **`SPIKE-nnnn` id** and its `docs/ledger.md` row (*in progress*). Sharpen the question
until it is **decidable**:
- **The decision it unblocks** — name the story, design choice, or Open Question waiting on it.
- **What evidence would settle it** — the acceptance criteria for the *answer*.
- **Out of scope** — the adjacent questions this spike will not chase.
- **Budget** — sub-agent dispatches and experiment cycles, proposed per-spike (a modest opening
  bid: ~10 cheap dispatches, ≤2 experiment cycles) for the human to adjust.
- **Modes** — which investigation lanes apply (below).
**Stop for approval of frame + budget.** A question that mutates mid-spike returns here — a new
question is a new frame, human-approved, never silent drift.

### 1 — Investigate (delegated, budgeted)
By approved mode, cheap tiers doing the gathering:
- **Codebase archaeology** — fan out the plugin's `surveyor` over the implicated areas; bounded,
  observed-only, `file:line`-cited reports.
- **External research** — dispatch the project's **`researcher` agent** per sub-question (model
  per the project's policy): current docs, ecosystem state, prior art — every claim source-cited,
  publication dates noted (external answers rot).
- **Experiment** — on a **`spike/<slug>` branch**: pin each experiment's measurement *first*
  ("result X → decision A; result Y → decision B"), have the `implementer` build the minimal
  probe, run it, record the numbers. Probes are scaffolding for learning — untested by design,
  and treated accordingly (see the iron rule below).
**When the budget is exhausted → 🛑 stop**: report evidence so far and current confidence; the
human extends the budget explicitly or calls the question on what's in hand. Never wander past
the budget silently.

### 2 — 🛑 Synthesize
The answer, decision-ready:
- **Recommendation** — direct answer to the framed question.
- **Confidence** — and specifically *what evidence would change the conclusion*.
- **Evidence chain** — citations: `file:line`, URLs with dates, measurements with the exact
  probe/scenario.
- **Follow-ups** — the stories now estimable, design updates implied, new questions surfaced
  (parked, not chased).
**The spike recommends; the human decides.** Stop for the decision.

### 3 — Capture & route
- Write **`docs/spikes/SPIKE-nnnn-<slug>.md`** — question, decision unblocked, method, evidence,
  answer, confidence, **the human's decision**, follow-ups — **prominently dated** (an ecosystem
  answer from six months ago is a hypothesis, not a fact).
- **Ratify the decision into the docs** through the normal machinery: design/tech-design section
  + dated Change Log entry; if the answer overturns a settled rule, that is the §7
  design-contradiction gate's door, not a bypass.
- Route follow-ups: newly-estimable stories → `write-stories`; observed structural debt →
  `docs/debt.md`; novel test/code/smell cases → the candidates inbox.
- **Delete the `spike/<slug>` branch.** The record quotes what matters; the code dies. A winning
  approach is rebuilt through RGR in stories, with the spike record as its map.
- Mark the ledger row *answered*.

## The iron rule — spike code never merges

Probe code is untested by definition; merging it ships untested behavior and steals future reds —
the same law as "Green satisfies the pinned Red, no more," applied to research. **Knowledge
survives; code dies.** No exceptions, including "the probe is basically fine."

## Guardrails — what this skill never does

- **Never investigates an unframed question** — the frame checkpoint is the spec.
- **Never exceeds the budget silently** — exhaustion is a checkpoint, extension is the human's.
- **Never answers without cited evidence and stated confidence** — vibes are not findings.
- **Never makes the decision** — it recommends; the human decides and the docs record it.
- **Never merges spike code** — the iron rule, no exceptions.
- **Never spends orchestrator-weight tokens on gathering** — surveyor/researcher/implementer do
  the reading and probing; the session model frames and synthesizes.
- **Never chases surfaced side-questions** — they become new Open Questions or new spikes.
