# Decision: the comment standard (v0.25.0)

**Date:** 2026-09-06 · **Status:** shipped, under observation · **PR:** #11

## The observation

Implementers on a running project (story-dev) were writing paragraph comments on single
lines, narrating code that explained itself, and recording provenance in source: which story,
AC, bug, and cycle produced each line, plus `Act:` / `Assert:` / `Witnessed:` labels in test
bodies. Human readability suffered. The write-time token cost is trivial; the read-time cost
compounds, paid by every later implementer, diagnostician, and refactor pass that loads the
file, and the citations go stale the moment the story closes.

## Root cause

The implementer contract asks for evidence and for refactoring "by reference" to the catalog,
and nothing said where traceability belongs. The implementer put it in both the report and the
source. The catalog's *Comments (as deodorant)* row named only narration of *how*, so
provenance and ritual labels matched no smell.

## Options weighed

- **A rule list** (no story ids, no AC ids, ≤2 lines). Rejected: the failure is a judgment
  failure about what is self-evident, and a prohibition list does not teach judgment; a model
  denied one way to over-explain finds another.
- **A positive standard in the author's words** — a comment says how to use a function
  (inputs, outputs, effects) and explains what is not evident from the code; terse; repeating
  nothing the code says. Chosen: it gives the writer a target to check a draft against.
- **Bare `LAW-*` tags in source** as an exception. Rejected: code does not reference requirement
  documents; the tech design already maps doc → code, and a test protects an invariant better
  than a comment.

## What shipped

- The catalog row rewritten to carry the standard, plus a **keep-in-sync** clause: changing code
  a comment describes means rewriting the comment to the same standard — never a changelog.
- A **fixed** *Comments* entry in the guardrails template — not part of smell selection, since
  it is universal and involves no judgment.
- A standing bullet in both implementer templates (the per-cycle seed only carries the entries a
  planner names; a standard for every cycle must ride in the agent file).
- A **Code comments** pointer in the CLAUDE.md contract pointers of both bootstraps — the one
  surface every writer of code loads, dispatched or inline.
- An upgrader **drift check** that scans every project-owned code-steering surface for the
  standard and reports each as covered or patched. A drift, not an offer: coverage must be
  complete, and no seeding judgment is involved.

## Deferred

- Trimming existing comments is project work (a `refactor-pass`, green-to-green), not plugin
  work.
- A lint that counts comment lines per statement. Not built: the standard is judgment, and a
  count would recreate the rule list that was rejected.

## Would reopen

- Implementers still writing provenance after the standard is in their agent file — that would
  mean the report format itself invites duplication, and the fix moves to the report schema.
