# prototype — graduation fork (adopt a kept tracer bullet)

Reached from `SKILL.md` phase 0 or `design-in-hand.md` phase 5: contract present, marker present,
the human said **keep it**. The code is now legacy by every practical measure — untested, built
at speed — but unlike `bootstrap-legacy`'s subject, its intent was recorded *first*. So this fork
does not reconstruct intent; it **reconciles** the design as written with the prototype as built,
and re-baselines the contract around code that exists.

**Process sensibility: Michael Feathers** — characterize before you change; safety net where you
work. The invariants outrank it: story-driven production, test-driven development, from the merge
onward. Every edit below happens on the `prototype/<slug>` branch; the single merge to `main` in
phase 7 **is** the graduation gate. The router's guardrails apply throughout — above all: **never
fix a prototype defect here.** Defects become stories.

### 1 — Reconnaissance (mechanical)
Stack as built vs. tech-design §7's chosen stack; repo shape and entry points; what the levers
actually are; whether the build introduced instruction files (`CLAUDE.md`, `.claude/`, nested or
root). If it did, run `bootstrap-legacy`'s phase-2 reconciliation (keep / subordinate / archive /
absorb — every resolution the human's); otherwise say "no instruction files introduced" and move
on. One screen, no judgment yet.

### 2 — 🛑 As-built map
State the plan — "N areas, N `surveyor` agents (model per the plugin's surveyor definition)" — so
the user can trim it, then fan out the plugin's **`surveyor`** (never general-purpose or
inheriting agents). Synthesize into a new **`## 8. As built (observed)`** section in
`docs/tech-design.md`, placed before `## Change Log`: one delta row per §2/§3 item — *design says*
· *built* · `[observed <date>]`. Thin: the map says where things are and where they left the
design; stories earn the detail later. **The prescriptive sections stay untouched** — they are
what phase 3 reconciles against. **Stop for review.**

### 3 — 🛑 Design reconciliation (the payload)
One table, three sources: the record's *Deviations from the design*, its *Assumptions ledger*,
and phase 2's as-built deltas. Per row the human picks exactly one:
- **Design was wrong** → revise the design/tech-design section + dated Change Log entry (one-line
  rationale). Settled from here on — the contradiction gate enforces it.
- **Prototype is wrong** → a **story candidate**, listed for phase 6. Never fixed here.
- **Undecided** → `docs/design.md` §4 Open Question, dated.
The record's *Critical decisions* enter `docs/design.md` §3 as `[observed <date>]` unless the
human ratifies them live (`[ratified <date>]`). Entries the greenfield bootstrap authored stay
untagged — they already gate as settled; this is not a retagging campaign. **Stop for approval.**

### 4 — Levers & the honest baseline
Discover the real `test` and `lint` commands (often absent — the prototype's price), finish
`levers.json`, and run every lever through `scripts/lever`. Record what actually happens in
tech-design §7 as the baseline: a test lever over zero tests is recorded as exactly that; a
`HANG` verdict gets `stall`/`cap` tuned and is recorded as found. **Never fix the baseline** —
a red baseline is information; repair is stories. Ask the **resource-budgets question** (as in
`bootstrap-project`) 🛑 only if the tech-design Direction note has no `Resource budgets:` line
yet; a recorded answer is respected, not re-asked.

### 5 — Mechanical contract additions (no persona)
- `docs/guardrails.md` §2 — the **legacy-safety patterns** from `references/code-smells.md`
  (characterization test, seam, sprout, wrap, scratch refactoring), as dated candidates — the
  same seeding `bootstrap-legacy` performs, for the same reason.
- `docs/debt.md` — structural hazards the survey observed, as first dated `DEBT-` rows.
- tech-design Direction note — one line: `Prototype graduated: PROTO-nnnn <date>`.
- Unchanged: `docs/story-format.md`, `.claude/agents/`, `CLAUDE.md`, `docs/.contract-version`.
  The contract already exists; if the SessionStart line reports a stale stamp, that is
  `bootstrap-project`'s upgrade path, run separately.

### 6 — 🛑 Slice plan re-baseline
In `docs/slice-plan.md` (or the slice plan section of tech-design):
- **Slice 0** is rewritten from *walking skeleton* to **safety net**: levers proven (witnessed
  failing, then green — or matching the recorded baseline) plus characterization tests pinning
  current behavior **in the first area to change only**. Never a coverage campaign.
- Every existing slice is tagged **covered-untested** / **partial** / **untouched**. Covered
  slices become characterize-and-harden stories rather than greenfield ones; partial slices name
  what remains.
- Phase 3's *prototype is wrong* list lands in the slices it belongs to, as story candidates.
**Stop for approval.**

### 7 — 🛑 Merge = graduation
Finalize the record: a *Graduated <date>* section with the reconciliation summary (counts per
decision, the design sections that changed). Delete the root `PROTOTYPE.md` stub. Ledger row →
*graduated*. Commit on the branch, then merge `prototype/<slug>` into `main` — the
`main-commit-ask` hook will ask; this is the deliberate case — and delete the branch. Handoff:
**"Contract updated — run `write-stories` for Slice 0."** Graduation fixed nothing, and that's
correct.
