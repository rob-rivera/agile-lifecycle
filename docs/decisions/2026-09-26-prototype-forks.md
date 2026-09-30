# Decision: prototypes inside a contract — the `prototype` skill and its forks (v0.26.0)

**Date:** 2026-09-26 · **Status:** shipped, under observation · **PR:** #12

The record of a design conversation, kept so the next revisit starts from the conclusions
instead of re-deriving them.

## The scenario

A project has been through `bootstrap-project`: design, tech design, story format, guardrails,
levers, slice plan — and no code. The maintainer wants a **tracer bullet**: stand the design up
as fast as possible to see how it holds, and, if it lands close to the vision, **keep it** and
continue through stories. The plugin had no lane for this:

- `bootstrap-prototype` refused wherever `docs/story-format.md` existed — "stories are the only
  way work enters a lifecycle project."
- `bootstrap-legacy` sent a contract-present project to the upgrade path, and six of its nine
  phases reconstruct intent that here was recorded *first*.
- `spike` allows in-contract experiments, but its code never merges and it has no marker, no
  demo, no graduation.

## Options weighed

1. **Run it as a spike** (no plugin change). Workable today: frame "does the design's core loop
   hold up when run?", raise the budget, build on `spike/<slug>`, ratify, delete. Lost: the
   keep-it path the maintainer actually wants, and the marker/demo machinery. Rejected as the
   design; recorded as the workaround available on older plugin versions.
2. **Sibling empty folder + bootstrap-prototype** fed the design as its prompt. Rejected: keep-it
   makes no sense with a contract elsewhere, nothing lands in the ledger, knowledge is carried
   back by hand.
3. **A new skill (or two) for the contract-present case.** Rejected for disambiguation: three
   prototype-shaped skills whose descriptions compete at selection time.
4. **One skill, renamed `prototype`, with state-detected forks** — shipped. Phase 0 detects
   contract / marker / real code and reads the matching procedure file. Greenfield is unchanged.

## What shipped

- `skills/prototype/` — `SKILL.md` is a router (state table, shared guardrails); `greenfield.md`
  (today's procedure, moved verbatim), `design-in-hand.md`, `graduate.md` are read on demand.
  First skill in the plugin with supporting files.
- **Design-in-hand fork**: the design replaces the prompt; a demo decision table is pinned before
  building; every deviation from the design is logged as the payload; the build lives on
  `prototype/<slug>` under a `PROTO-nnnn` ledger row; three exits — still exploring, keep,
  discard (knowledge ratified, record lands on `main`, branch dies).
- **Graduation fork**: recon → `surveyor` as-built map (`tech-design.md §8 As built (observed)`)
  → design reconciliation (design was wrong → Change Log; prototype was wrong → story candidate;
  undecided → Open Question) → honest lever baseline → legacy-safety patterns + debt seeding →
  Slice 0 re-baselined from walking skeleton to safety net → merge to `main` **is** the gate.
- **`PROTO-nnnn` id family**: `docs/prototypes/PROTO-nnnn-<slug>.md` is the record (the marker
  itself, in the contract case; a three-line root `PROTOTYPE.md` stub keeps the sentinel every
  routing check looks for). Statuses *exploring → graduated | discarded*. Hooks, ledger template,
  SessionStart filter, orient, and the README roster extended.

## Arguments that settled it

- **Keep-it was always allowed for prototypes.** The greenfield fork has had a keep-it door
  since v0.12.0 (via `bootstrap-legacy`). Spike's iron rule ("code never merges") governs
  spikes; prototypes have always graduated through a gate instead. The contract-present case
  lacked an *adopter*, not permission.
- **Graduation reconciles; legacy reconstructs.** The valuable product of a kept tracer bullet is
  the diff between the design as written and the prototype as built. That is the existing
  `observed`/`ratified` machinery run in reverse — prototype behaviors enter as `observed`, and
  each conflict with the design is a ratification prompt whose answer is either a design
  revision or a story. `bootstrap-legacy`'s interview and descriptive tech-design would have
  overwritten exactly the artifact the bullet was fired to test.
- **Greenfield entries stay untagged.** They already gate as settled (the tag guidance is scoped
  to excavated projects). Graduation adds tagged entries beside them; it does not retag.
- **Why no stories for this change.** Prose skills have no Red to pin; the maintainer chose the
  harness's plan mode as the planning artifact, and this record as the durable one.

## Deferred, with the reopen condition

- **Hook allowance for prototypes on `main`** — not needed: the branch is the fence, and
  `main-commit-ask` firing on the discard commit and the graduation merge is the deliberate case.
  Reopen if a real graduation finds the ask noisy.
- **Orient's marker awareness** is one clause. Reopen if in-flight prototypes keep getting lost.
- **Old markers in the wild** say `bootstrap-prototype` in their re-entry line. The router's
  description carries "Formerly bootstrap-prototype" for one release so selection still lands;
  drop it at 0.27.0.
