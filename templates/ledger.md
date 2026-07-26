# <Project> — Work Ledger

> One row per work item, across all id families. **The skill that changes an item's state updates
> its row** — `write-stories` adds (*drafted*), `plan-cycles` marks *planned*, `implement-story`
> marks *in progress* / *done*, `fix-bug` and `refactor-pass` own their rows end-to-end. "What's
> outstanding?" is answered here, nowhere else. The slice plan stays intention; this is execution.

| Id | Title | Slice | Status | Updated |
| --- | --- | --- | --- | --- |

<!-- Statuses — STORY: drafted → planned → in progress → done.
     BUG: open / open (deferred) → fixed.
     REF: in progress → closed.
     SPIKE: in progress → answered. -->
