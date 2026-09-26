---
name: prototype
description: >-
  Build a runnable prototype — an answer in executable form, not production — and route it out
  honestly. Detects the project's state and loads the matching fork. Empty folder: the greenfield
  prototype (prompt → runnable artifact; the PROTOTYPE.md marker prints the price — no contract,
  no tests, no safety net; keep it → bootstrap-legacy, discard → bootstrap-project). A project that
  has been through bootstrap-project but has no code yet: the design-in-hand tracer bullet (the
  design is the spec, deviations from it are the payload, PROTO-nnnn ledger row) and, if kept, the
  graduation fork that adopts it into the existing contract (as-built map, design reconciliation,
  honest lever baseline, safety-net Slice 0). Use to find out whether an idea — or a design — is
  worth building right. Refuses un-marked brownfield code and lifecycle projects that already have
  real code. Formerly bootstrap-prototype.
---

# Prototype

Build the thing fast so the human can find out whether it's worth building *right*. The
lifecycle's invariants — story-driven production, test-driven development — govern **production**
code; a prototype is not production, with or without a contract around it. It is spike's sibling:
where a spike answers a question with research, a prototype answers "is this worth building?" —
or, once a design exists, "does this design hold up when run?" — with a runnable artifact. The
same rule applies at the end: **knowledge survives; code survives only by graduating through a
real gate.**

This is the plugin's one fast lane, and it stays legitimate only because the fence is part of the
skill: the marker prints the price on the artifact, a branch keeps it off `main`, and graduation
is never silent.

## Authority (read first)

- This plugin's `templates/prototype.md` — the marker template.
- `bootstrap-project`'s greenfield tiers (what counts as empty vs. real code) and
  `bootstrap-legacy` (the keep-it gate when no contract exists).
- This skill's three fork procedures, beside this file: `greenfield.md`, `design-in-hand.md`,
  `graduate.md`. Read **only** the one phase 0 selects.

## Procedure

### 0 — Detect state & route (the fences)

*Contract* = `docs/story-format.md` exists. *Marker* = a root `PROTOTYPE.md` — on its own
(greenfield) or as a stub pointing at a `docs/prototypes/PROTO-*.md` record whose ledger row is
*exploring* (contract). *Real code* per `bootstrap-project`'s tiers.

| State | Route |
| --- | --- |
| No contract, empty/near-empty folder | **`greenfield.md`** |
| No contract, marker present | 🛑 re-entry checkpoint (below); *keep it* → `bootstrap-legacy` |
| No contract, un-marked real code | route to `bootstrap-legacy` — adopting un-marked code is excavation, not prototyping |
| Contract, no real code, no marker | **`design-in-hand.md`** — the tracer bullet |
| Contract, marker present | 🛑 re-entry checkpoint (below); *keep it* → **`graduate.md`**; *discard* → `design-in-hand.md`'s discard path |
| Contract, un-marked real code | **refuse** — work enters through `write-stories` |

🛑 **Re-entry checkpoint** (any marker present): "still exploring, or is this becoming real?"
Extend only on an explicit *still exploring*; *becoming real* routes to the graduation question of
the fork that built it. This checkpoint is the defense against the prototype that grows one
feature at a time and never graduates.

No git repo → offer `git init` first (cheap rollback and resume, prototype or not). Then read the
selected fork's file and continue there; its phases are numbered from 1.

## Guardrails — what this skill never does

- **Never runs where a contract governs real code** — stories are the only way production work
  enters a lifecycle project; a design-in-hand prototype is allowed only while there is no code
  yet, and only on its own branch.
- **Never builds on `main` in a lifecycle project** — the `prototype/<slug>` branch is the fence;
  the merge is the gate.
- **Never touches un-marked brownfield code** — that is excavation (`bootstrap-legacy`).
- **Never asks a question an assumption could cover** — the bounded interview is the fence;
  the ledger is the outlet.
- **Never writes code before the marker** — the marker is not optional paperwork; it is what
  keeps the fast lane honest.
- **Never presents prototype code as production** — no tests and no contract is a price, printed
  on the marker, paid at graduation.
- **Never extends an existing prototype past the re-entry checkpoint** — "one more feature" is
  how prototypes ship untested.
- **Never graduates silently** — keep-it goes through `bootstrap-legacy` (no contract) or this
  skill's graduation fork (contract); there is no other path from prototype to production.
- **Never fixes a prototype defect during graduation** — defects become stories; graduation
  adopts, it does not repair.
