---
name: refactor-pass
description: >-
  A deliberate, bounded structure-improvement pass over one module or file: assess against the
  smells catalog, human-selected findings, characterization net first, then small named Fowler
  moves with levers green after every move — explicitly green-to-green (the suite's one deliberate
  exception to RGR). Symptoms route to fix-bug; contract or behavior changes route to
  write-stories. Use when a maintainer wants to pay down entropy in a named area, with no
  observable defect driving it.
---

# Refactor Pass

Pay down entropy in **one named module or file** — deliberately, with a net, one catalog move at a
time. **Process sensibility: Martin Fowler** (*Refactoring*) — the catalog is the book; the shapes
the code moves *toward* answer to the project's chosen evolution **Direction** (`tech-design.md`).

**The honest exception.** Refactoring is behavior-preserving, so this skill has **no Red** — it is
green-to-green by definition, the suite's one deliberate exception to RGR. Its discipline
substitutes and is not negotiable:

- **Net first.** Tests that pin current behavior exist before anything moves.
- **One named move at a time**, levers green after every move.
- **Two hats, never both** (Beck): you are refactoring or changing behavior — never both in one
  motion. Any urge to "fix while you're in there" is a routed item, not a detour.

## Intake — verdict and routing (the gate)

A request lands here only if it is **entropy, not symptom**:

- **Observable symptom** (wrong output, crash, memory/latency/resource problem someone can
  measure) → **route to `fix-bug`** — a measurement is a reproduction, and defects keep a real
  Red. Do not start a pass to chase a symptom.
- **New or changed behavior wanted** → route to `write-stories`.
- **Structural dissatisfaction with no symptom** — "this module fights every change" → proceed.
- Blurry middle → present both readings with a recommendation; **the user classifies.**

## Procedure

### 0 — Scope
The pass targets a **named module or file** — never the codebase. Assign a **`REF-nnnn` id** and
its `docs/ledger.md` row (*in progress*); work on a `refactor/<slug>` branch off `main`. Load the
target plus `docs/guardrails.md`, the plugin's canonical `references/code-smells.md`, the Direction
note, and **the target area's entries in `docs/debt.md`** (they enter the assessment as pre-loaded
findings) — nothing more.

### 1 — Assess
Read the target and compare against **both catalogs**: the project's `guardrails.md` (the
stack-idiomatic, augmented subset) and the plugin's canonical reference (catches smells never
seeded). Produce the findings report: **smell → `file:line` → proposed catalog move → expected
payoff**, ranked by payoff-per-risk. Findings matching no catalog entry are **candidates** — a
pass is a smell harvest; record them regardless of what gets selected.

### 2 — 🛑 Select
Present the findings. **The human selects which findings to act on, and in what order.** Recommend
freely; never execute an unselected finding. Note what selection leaves behind — deferred findings
survive in the pass record (step 5).

### 3 — Net
Where real coverage already pins the behaviors the selected moves could disturb, proceed. Where it
doesn't (the usual legacy case): **characterization tests first**, pinning current behavior in the
blast radius of the selected moves only. In an excavated project these tests pin `observed`
behavior — anything *surprising* they reveal is surfaced for ratification (or a `fix-bug` verdict),
never silently enshrined. The net is a keeper: it merges with the pass as the area's regression
tests.

### 4 — Transform
For each selected finding, in order: apply **one named move** (cite the catalog entry) → run both
levers → commit (message cites the `REF-nnnn`, the smell, and the move; the project's trailer).
Bounded and reversible — a move that won't go green in a step or two gets reverted, not forced.

**Hard boundaries (stop, don't bend):**
- The pass **never changes a public contract, an interface, or ratified behavior.** A move that
  wants to → **stop: that's a story wearing a refactor's clothes** — route to `write-stories`,
  recording the finding in the pass record.
- A behavior change discovered mid-move (a "harmless" difference in output) is **not yours to
  keep** — revert the move, record it, route it (ratification prompt or `fix-bug`).

### 5 — 🛑 Close
- Both levers green; the net retained.
- Write the **pass record** — `docs/refactors/REF-nnnn-<slug>.md`: findings, dispositions
  (**done / deferred / declined / routed**), moves applied, net added. Deferred findings survive
  here the way `BUG-nnnn` records survive — re-discoverable, never re-diagnosed from scratch.
- **Candidates gate** — harvest to `guardrails.md`, or affirm "candidates: none."
- **Update `docs/debt.md`** — entries the pass fixed → *retired* (cite the `REF-nnnn`); entries
  examined and declined stay *open* with the finding noted.
- Present the record; on approval, merge the branch and mark the ledger row *closed*.

## Guardrails — what this skill never does

- **Never chases a symptom** — measurable problems are `fix-bug`'s jurisdiction, routed at intake.
- **Never moves without a net** — characterization first where coverage is missing.
- **Never wears both hats** — behavior changes, however small, are reverted and routed.
- **Never touches public contracts or ratified behavior** — hard stop, route to `write-stories`.
- **Never exceeds the named target** — one module/file per pass; adjacent temptations become
  deferred findings.
- **Never auto-executes findings** — the human selects; the pass record keeps what they declined.
- **Never skips the candidates gate.**
