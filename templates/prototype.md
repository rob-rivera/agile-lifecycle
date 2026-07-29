# PROTOTYPE — <name>

> **This code is a prototype: no contract, no tests, no safety net.** The lifecycle's
> invariants (story-driven production, TDD) do not govern it because it is not production —
> and it becomes production only through the graduation gate below. Extending it requires the
> re-entry checkpoint (`bootstrap-prototype` phase 0): *still exploring, or becoming real?*

## Prompt (verbatim)

<!-- The prompt that started this, unedited, dated. -->

## Critical decisions

<!-- Only the questions asked because the answer changed what got built. -->

| Question | Answer | Why it was critical |
| --- | --- | --- |

## Assumptions ledger

<!-- Every non-critical unknown, named instead of asked — at intake and mid-build alike. Dated. -->

| Assumption | Made | Would change what if wrong |
| --- | --- | --- |

## What it answers

<!-- The question this prototype exists to answer, and what the demo showed. -->

## Graduation (the only paths out)

- **Keep it** → run `bootstrap-legacy`. This file is its highest-trust prior-knowledge source —
  intent recorded at authoring time — though every claim still enters as `observed` until
  ratified.
- **Discard** → run `bootstrap-project` for the real thing. Copy this file's knowledge out
  first; the code dies (the spike rule: knowledge survives, code doesn't).
