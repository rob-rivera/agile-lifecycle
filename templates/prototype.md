# PROTOTYPE — <name>

> **This code is a prototype: no contract, no tests, no safety net.** The lifecycle's
> invariants (story-driven production, TDD) do not govern it because it is not production —
> and it becomes production only through the graduation gate below. Extending it requires the
> re-entry checkpoint (`prototype` phase 0): *still exploring, or becoming real?*

<!-- Greenfield: this file is the marker, at the repo root. Contract-present (design-in-hand):
     this file is the record at docs/prototypes/PROTO-nnnn-<slug>.md, and a three-line root
     PROTOTYPE.md stub points here. Fill "Prompt" or "Design under test" — whichever started it. -->

## Prompt (verbatim)

<!-- Greenfield: the prompt that started this, unedited, dated. -->

## Design under test

<!-- Design-in-hand: the design.md / tech-design.md sections, LAW-* ids, and slices this tracer
     bullet exercises, and the thread it traces end to end. Dated. -->

## Critical decisions

<!-- Only the questions asked because the answer changed what got built. -->

| Question | Answer | Why it was critical |
| --- | --- | --- |

## Assumptions ledger

<!-- Every non-critical unknown, named instead of asked — at intake and mid-build alike. Dated. -->

| Assumption | Made | Would change what if wrong |
| --- | --- | --- |

## Demo decision table

<!-- Design-in-hand: pinned before building. What the demo must show, and what each outcome
     decides about the design. -->

| If the demo shows | Then |
| --- | --- |

## Deviations from the design

<!-- Design-in-hand: every place the build left the design, logged as it happened. Graduation
     reconciles each row; a discard ratifies what it taught. -->

| Design says | Built | Because | Date |
| --- | --- | --- | --- |

## What it answers

<!-- The question this prototype exists to answer, and what the demo showed. -->

## Graduation (the only paths out)

**No contract around it (greenfield):**
- **Keep it** → run `bootstrap-legacy`. This file is its highest-trust prior-knowledge source —
  intent recorded at authoring time — though every claim still enters as `observed` until
  ratified.
- **Discard** → run `bootstrap-project` for the real thing. Copy this file's knowledge out
  first; the code dies (the spike rule: knowledge survives, code doesn't).

**Inside a contract (design-in-hand):**
- **Keep it** → `prototype`'s graduation fork: as-built map, design reconciliation, honest
  baseline, safety-net Slice 0; the merge to `main` is the gate. This record gains a
  *Graduated* section.
- **Discard** → deviations and assumptions are ratified into the design or parked as Open
  Questions; this record (with a *Discarded* section) and the doc changes land on `main`; the
  branch and the code die.
