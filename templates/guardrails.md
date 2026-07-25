# <Project> — Guardrails

> The durable test/code/smell catalog. Skills **reference** entries here (never embed them); the
> catalog **grows** through the candidates gate at every story/bug close. Seeded at bootstrap from
> the plugin's canonical smell catalog (`references/code-smells.md` — Fowler/Beck; Meszaros/Beck),
> expressed in this project's stack idiom. A smell is a smell whether it lives in `src/` or
> `tests/` — one catalog, one gate.

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

*Project-approved shapes worth repeating. Seeded thin; grown via candidates.*

<!-- PATTERN entries: name — when to reach for it — the shape, in this stack's idiom -->

## 3. Smells

*Seeded at bootstrap (selection approved by the human); grown via candidates. Each entry: the
smell, its tell **in this stack**, the idiomatic cure.*

<!-- SMELL entries seeded by bootstrap-project go here -->

## Candidates (inbox)

*Novel test/code/smell calls surfaced during stories and bug fixes land here — the story-close gate
requires either new entries or the explicit affirmation "candidates: none." Promote entries into
§2/§3 when they've earned it; date each candidate.*
