# prototype — design-in-hand fork (the tracer bullet)

Reached from `SKILL.md` phase 0: contract present, no real code, no marker. The design exists;
what's unknown is whether it holds up when run. Stand it up as fast as possible, log where the
build had to leave the design, and let the demo decide. The router's guardrails apply throughout.
No process sensibility — this is the speed lane.

### 1 — 🛑 Frame from the design
Read `docs/design.md`, `docs/tech-design.md`, and `docs/slice-plan.md`. Present one screen:
- **Design under test** — the sections, `LAW-*` ids, and slices this bullet exercises; the
  thread through the design it will trace end to end.
- **Demo decision table** — pinned before building, spike-style: "demo shows X → design holds;
  shows Y → §N needs revising." A bullet with no table is a feature, not a probe.
- **Critical questions** — only those the design leaves open *and* whose answer changes what
  gets built (form, persistence, the one interaction to demo). Most are pre-answered by the
  design, so this usually collapses to "which thread, in what form." Everything else is a named
  **assumption**, seeded from the design's own gaps.
Assign the **`PROTO-nnnn`** id, add its `docs/ledger.md` row (*exploring*), and create and
check out `prototype/<slug>`. **Stop for approval.**

### 2 — Write the marker first — two files
- `docs/prototypes/PROTO-nnnn-<slug>.md` from `templates/prototype.md` — the record the hooks
  track: *Design under test* (in place of the verbatim prompt), critical decisions, assumptions
  ledger, demo decision table, an empty *Deviations from the design* table, the graduation rule.
- Root `PROTOTYPE.md` — a three-line stub naming the record and the re-entry question. It is the
  sentinel every routing check looks for; the record is where the content lives.
Written **before code**, so the marker can never be the step that got skipped.

### 3 — Build
The design is the spec; the smallest artifact that traces the thread is the deliverable. Stack
per tech-design §7. Same rules as the greenfield fork: **load `frontend-design` before building a
UI** (when installed; absent, note it in the assumptions ledger); build inline by default, **MAY
delegate** a larger build to the plugin's **`builder` agent** (mid-tier by its own `model:` line —
never an inheriting general-purpose dispatch), seeded with the record's design-under-test,
critical decisions, and assumptions; the orchestrator launches the result itself. No stories, no
TDD — the marker prints the price.

Follow tech-design's layers and contracts where they cost nothing; **deviate freely where they
cost speed — and log every deviation** as a dated row in the record's *Deviations from the design*
table: *design says X · built Y · because Z*. Deviations are the tracer bullet's payload — they
are what graduation reconciles and what a discard ratifies. A deviation buried in code is a
finding lost. Assumptions surfaced mid-build go into the ledger, dated. Resist gold-plating: a
bullet that grows features stops tracing and starts shipping.

### 4 — Levers
`levers.json` already exists, provisional from `bootstrap-project`. Make **`run`** real (plus
**`stop`** when `run` is long-running) and verify it launches the artifact. Leave `test`/`lint`
as found — still provisional, still unproven; say so in the record, not in tech-design §7 (the
honest baseline is graduation's job).

### 5 — 🛑 Demo & the graduation question
Launch via the `run` lever, walk the demo decision table row by row, present the final
deviations and assumptions. Then ask — every path is the human's call:
- **Still exploring** — iterate on the branch; marker and *exploring* row stay.
- **Keep it** — read this skill's `graduate.md` and continue there. The prototype is now real
  code inside a contract that predates it; graduation reconciles the two.
- **Discard** — knowledge first, then the code dies:
  1. For each deviation and assumption, the human decides: revise the design section + dated
     Change Log entry, park it as a §4 Open Question, or drop it. Record every answer.
  2. Finalize the record with a *Discarded <date>* section (what the demo showed, what changed
     in the design); ledger row → *discarded*.
  3. Commit **only** `docs/prototypes/PROTO-nnnn-*.md`, `docs/design.md`, `docs/tech-design.md`
     (if touched), and `docs/ledger.md` to `main` — the `main-commit-ask` hook will ask; this is
     the deliberate case. Delete `prototype/<slug>`. The root stub dies with the branch.
