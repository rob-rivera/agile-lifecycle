# <Project> — Guardrails

> The durable catalog, two-sided: **smells** (what to move away from) and **patterns** (what to
> move toward). Skills **reference** entries here (never embed them); the catalog **grows**
> through the candidates gate at every story/bug close. Seeded at bootstrap from the plugin's
> canonical catalogs (`references/code-smells.md` — Fowler/Beck; Meszaros/Beck — and, thinly,
> `references/patterns.md`), expressed in this project's stack idiom. A smell is a smell whether
> it lives in `src/` or `tests/` — one catalog, one gate.

## 1. Canonical TDD rules

These are the plugin's invariants, restated as this project's law:

- **Witnessed red.** No behavioral cycle counts without evidence the test failed first — for the
  right reason. A gate cycle's "red" is the failing gate.
- **Green satisfies the pinned Red — no more.** Behavior no current test pins is a defect, not
  initiative: it ships untested and steals a later cycle's red.
- **Implementer ≠ verifier.** Validation runs the levers; it never trusts a report.
- **A specific past defect → an example/regression test.** Once a failure is witnessed, a
  reproducing test stands guard over it forever (`fix-bug`).
- **Minimal green, then refactor by reference** — to entries in this catalog.

## 2. Patterns

*Project-approved shapes worth repeating. Seeded thin; grown via candidates. Two rules from
`references/patterns.md` govern every entry:*

- ***Destinations, not starting points.** A pattern is where a refactor arrives, never where a
  design begins — patterns are cited at the Refactor step; a Red or story that prescribes one
  has pre-written the Green.*
- ***Canonical names, coinage declared.** Name entries from the literature and cite the source;
  a half-fit canonical name is worse than none; a house name is allowed only when the
  literature has no name — and the entry must say so.*

<!-- PATTERN entries: canonical name (source cited) — the context/forces line: when this
     applies — the shape, in this stack's idiom -->

## 3. Smells

*Seeded at bootstrap (selection approved by the human); grown via candidates. Each entry: the
smell, its tell **in this stack**, the idiomatic cure.*

<!-- SMELL entries seeded by bootstrap-project go here -->

## Candidates (inbox)

*Novel test/code/smell calls surfaced during stories and bug fixes land here — the story-close gate
requires either new entries or the explicit affirmation "candidates: none." Promote entries into
§2/§3 when they've earned it; date each candidate. **Promotion into §2 runs the naming check
first**: match against `references/patterns.md` and the literature — canonical name + citation,
or a declared house name (§2's rules).*
