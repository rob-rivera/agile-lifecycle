---
name: write-stories
description: >-
  Author implementation-ready user stories in the project's standard format (As-a/I-want/so-that,
  Given/When/Then, INVEST) with agent-native sizing. Use when turning a slice, a freeform change
  prompt, or test-cycle feedback into one or more stories. Runs the design-contradiction gate first,
  and recommends (never executes) splits — with human checkpoints for precedence, breakdown, and
  decomposition.
---

# Write Stories

Turn a change request — from **any** origin — into one or more implementation-ready stories.

## Authority (read first)

`docs/story-format.md` is the **source of truth** for the story format, the INVEST reinterpretation,
and the sizing rubric (§3 thresholds are calibration-pending and may change). **Read it at the start
of every run** so you use the current format and thresholds. This skill is the *procedure and the
guardrails*; the doc is the *specification*. Where they seem to differ, the doc wins on format/rubric;
this skill wins on process and checkpoints.

*(New project without a `docs/story-format.md`? Seed it from this plugin's
`templates/story-format.md`, then proceed.)*

## Origins (no slice required)

A story does not require a slice. The origin may be:
- **a slice** (`docs/slice-plan.md`),
- **a freeform change prompt**, or
- **test-cycle feedback** (a failure/gap/defect from Red → Green → Refactor).

Identify the origin, **record it in the story's notes**, and load **only the design surface the
origin implicates** — a slice's context, a prompt's target area, or a failing test and its governing
`LAW-*`. Never load the whole spec; bounding context is the point of a story.

## Procedure

Run these in order. Three checkpoints **hand the decision to the human** — stop and wait at each.

### 0 — Intake
Read `docs/story-format.md`. Identify the origin and load the implicated design surface only.

### 1 — 🛑 Design-contradiction gate (`story-format.md` §7)
Before any breakdown or drafting, compare the ask to the settled rules in the project's **domain
design doc** (product/system rules) and `docs/tech-design.md` (architecture/build). Classify:
- **Extension** — fills an open gap, does not conflict → proceed (may note a later design addition).
  Do **not** cry wolf on every new feature.
- **Contradiction** — conflicts with a stated rule or `LAW-*` → **STOP. Flag it**: name the exact
  rule / section / `LAW-*` and how the ask conflicts. **Ask the user which takes precedence: the
  design or the story.**
  *(Excavated projects: only `ratified` entries contradict. Conflict with an `observed` entry is a
  **ratification prompt** — "the code does X; you're asking for Y — is X intended?" — and the
  answer is recorded either way: ratify X and gate, or the story proceeds and X is corrected.)*
  - **Design wins** → revise or reject the ask to conform. No design-doc changes.
  - **Story wins** → this is a design change. Update the source of truth **before proceeding** —
    the relevant section **+ a dated Change Log entry with one-line rationale**:
    - domain rules → the domain design doc. **Never edit a doc the project marks frozen** (e.g. a
      design-history file).
    - architecture/build → `docs/tech-design.md`. Roadmap/process → `docs/slice-plan.md` or
      `docs/story-format.md`.
  - No story may enter the pipeline while it silently contradicts the design.

### 2 — 🛑 Candidate breakdown
Propose the candidate story set as **titles + one-line value each** (not full drafts). **Stop and let
the user confirm the breakdown** before drafting.

### 3 — Draft
Write each confirmed story in the standard format (`story-format.md` §1):
- **Summary** — `As a <role>, I want <capability>, so that <outcome>.` Apply the "and" test.
- **Acceptance criteria** — `Given/When/Then`, each **independently verifiable**, each citing the
  `AC-*` (if from a slice) and any `LAW-*` IDs its tests satisfy.
- **INVEST** — agent-reinterpreted: pin ambiguity (N inverts); enumerating the RGR cycles is what
  makes it Estimable/Small/Testable.
- **Background / Notes** — the bounded context, **including the origin**. Apply the one-card test.

### 4 — 🛑 Sizing check + split recommendation (`story-format.md` §3–§4)
For each story, fill the sizing vector (enumerate the RGR cycles; count new contracts, layers whose
contracts change, unknowns; check AC independence and the one-card test). If **any** signal trips:
**recommend** a split or spike — name the tripped signal, its count, and the proposed cut — and **STOP
for the human to decide.** Frame the split with the **SPIDR lenses** (`story-format.md` §4) and **name
the lens**; every slice must stay vertical, valuable, and testable. **Never split unprompted.**
Decomposition is a business-value judgment the user owns.

### 5 — Finalize
On the user's decisions, write the story files to `docs/stories/` (one file per story; suggested name
`STORY-<nnnn>-<kebab-title>.md`) and **add a `docs/ledger.md` row per story (*drafted*)**. A story is
done-for-authoring when it is on-format, its sizing vector is recorded, and any recommendation is
resolved. Definition of done for *implementation* is in
`story-format.md` §5.

## Guardrails — what this skill never does

- **Never decides scope for the human.** It authors, flags, and recommends. The human owns
  precedence (§1), breakdown (§2), and splits (§4).
- **Never lets a story silently override the design.** Contradictions are resolved and recorded first.
- **Never edits a doc the project marks frozen.**
- **Never hardcodes sizing thresholds** — always reads them live from `docs/story-format.md`.
- **Never loads the whole spec** — only the surface the origin implicates.
- **Never auto-splits** — a tripped sizing signal is a recommendation, not an action.
