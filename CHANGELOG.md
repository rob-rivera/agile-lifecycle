# Changelog

One entry per released version, newest first. A release is a merge to `main` that bumps
`plugin.json`'s `version`; the `release-tag` workflow mints the `v<version>` tag from that field.
Each entry says what changed and why, and links the PR that carries the full discussion. Design-
level changes also get a record under `docs/decisions/`.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions follow SemVer,
pre-1.0 (minor bumps may change the contract; the upgrader carries projects across).

## [0.26.0] — 2026-09-26 · [#12](https://github.com/rob-rivera/agile-lifecycle/pull/12)

Prototypes inside a contract. A project fresh out of `bootstrap-project` had no lane for a
tracer bullet — stand the design up fast, see how it holds, keep it if it lands — because
`bootstrap-prototype` refused wherever a contract existed and `bootstrap-legacy` would have
re-excavated intent the contract had already recorded. Design record:
`docs/decisions/2026-09-26-prototype-forks.md`.

### Added
- **`prototype` skill forks.** Phase 0 detects project state and reads one of three procedure
  files beside `SKILL.md` — the first skill in the plugin with supporting files. `greenfield.md`
  is the previous procedure, moved verbatim. `design-in-hand.md` (contract present, no code):
  the design replaces the prompt, a demo decision table is pinned before building, every
  deviation from the design is logged as the payload, the build lives on `prototype/<slug>`
  under a ledger row; exits are still exploring / keep / discard (knowledge ratified, record on
  `main`, branch dies). `graduate.md` (a kept tracer bullet): recon, `surveyor` as-built map
  (`tech-design.md §8 As built (observed)`), design reconciliation (design was wrong → Change
  Log; prototype was wrong → story candidate; undecided → Open Question), honest lever baseline,
  legacy-safety patterns and debt seeded, Slice 0 re-baselined from walking skeleton to safety
  net, and the merge to `main` as the graduation gate. Graduation never fixes a defect.
- **`PROTO-nnnn` id family.** `docs/prototypes/PROTO-nnnn-<slug>.md` is the tracer bullet's
  record (the marker itself; a three-line root `PROTOTYPE.md` stub keeps the sentinel routing
  checks look for). Statuses *exploring → graduated | discarded*. Ledger template comment,
  `ledger-nudge` and `stop-gate` hooks, orient, and the README artifact list extended.
- `templates/prototype.md` gains *Design under test*, *Demo decision table*, and *Deviations
  from the design* sections, and a graduation section for each context.
- `builder` agent reports `deviations` alongside `assumptions` when building against a design.

### Changed
- **`bootstrap-prototype` renamed `prototype`** — the first rename in the plugin. Its description
  carries "Formerly bootstrap-prototype" for one release so selection still lands; markers
  written by older versions name the old skill in their re-entry line, which the new one
  honors. All routing lines in `bootstrap-project`, `bootstrap-legacy`, and `orient` updated,
  and both bootstraps now route *contract + marker* to `prototype` instead of the upgrade path.
- `session-start` hook: *answered*, *graduated*, and *discarded* rows no longer count as
  outstanding work (answered spikes had been listed as outstanding since the filter was written).
- This changelog.

## [0.25.0] — 2026-09-06 · [#11](https://github.com/rob-rivera/agile-lifecycle/pull/11)

The comment standard. Implementers were writing paragraph comments on single lines, narrating
self-documenting code, and recording provenance (story/AC/bug ids, `Act:`/`Assert:`/`Witnessed:`
labels) in source; nothing in the contract said where traceability belongs.

### Added
- A fixed **Comments** entry in the guardrails template, shipped in every catalog outside smell
  selection: a comment says how to use a function (inputs, outputs, effects) and explains what is
  not evident from the code — terse, repeating nothing the code says. Includes the keep-in-sync
  clause: changing code a comment describes means rewriting the comment to the same standard,
  never a changelog.
- A standing bullet in both implementer templates (the per-cycle seed only carries the entries a
  planner names; a standard for every cycle rides in the agent file).
- A **Code comments** pointer in the bootstraps' CLAUDE.md contract pointers — the one surface
  every writer of code loads, dispatched or inline.
- Upgrader: a **comment-standard coverage** drift check in every project (never an offer) that
  scans every project-owned code-steering surface and reports each as covered or patched.
- Decision record: `docs/decisions/2026-09-06-comment-standard.md`.
- This changelog.

### Changed
- `references/code-smells.md`: the *Comments (as deodorant)* row now carries the standard.

### Not included
- **No sweep of existing code.** This version corrects the behavior going forward — new and
  touched comments follow the standard — but does not scan or rewrite comments written before
  it. The upgrader's coverage report says so explicitly. Cleaning up the existing stock is a
  `refactor-pass` over the affected area, comment-only moves being green-to-green.

### Recommendation from the maintainer
- After the upgrade review, run a **`spike`** to identify comment-sweep candidates: which files
  and areas carry the pre-standard stock (paragraph comments, provenance, ritual labels, doc
  citations), roughly how much, and in what order it is worth trimming. Record the findings as
  `DEBT-nnnn` entries in `docs/debt.md`, one per area, so `refactor-pass` can pick them up at
  the user's leisure. The spike is read-only and produces a list, not a cleanup — the sweep
  itself stays a refactor-pass decision per area.

## [0.24.0] — 2026-09-05 · [#10](https://github.com/rob-rivera/agile-lifecycle/pull/10)

The lever runner. An implementer whose suite outran the Bash tool timeout learned to background
it and reported green before the run finished; a hung suite and a slow one were indistinguishable
from outside. Decision record: `docs/decisions/2026-09-05-lever-runner.md`.

### Added
- `templates/scripts/lever` — seeded as `scripts/lever`: runs one lever in the foreground, in its
  own process group with stdin closed, watching output growth and CPU; always returns within the
  lever's `cap` and ends in one line, `LEVER <name> VERDICT=PASS|FAIL|HANG|CAP|GAP`. Scoped runs
  (`-- <args>`) are labelled and never count as the lever.
- `hooks/lever-guard.sh` (PreToolUse Bash) — denies the bare full-suite command in favour of the
  runner, and a runner call whose Bash timeout is below the cap.
- `hooks/lever-verdict-gate.sh` (SubagentStop) — blocks a green implementer report unless the
  sub-agent's transcript holds a `VERDICT=PASS` tool result for every required lever.
- `levers.json` template gains per-lever `stall` / `cap` knobs.

### Changed
- Implementer templates: runner rule; `outcome` is the first report field. `implement-story` /
  `fix-bug` validate through the runner; `lever-hang` routes outside the retry budget.
- Bootstraps seed `scripts/lever`; the upgrader reports it as a missing piece with the implementer
  patch. story-format §5, tech-design §7, README updated.

## [0.23.0] — 2026-08-30 · [#9](https://github.com/rob-rivera/agile-lifecycle/pull/9)

### Added
- `hooks/sweep-guard.sh` (PreToolUse `Bash|Read|Glob|Grep`) — denies recursive filesystem walks
  rooted at `/`, `/Users`, a home directory, `/Volumes`, or a Library tree; the deny reason teaches
  the scoped form. Born of a real `find /` incident that swept the disk and billed macOS privacy
  prompts to the embedding app. Deliberately not lifecycle-guarded: safety travels with the plugin.

## [0.22.0] — 2026-08-23 · [#8](https://github.com/rob-rivera/agile-lifecycle/pull/8)

Upgrade-path feedback: a project that legitimately declined the budgets offer silently missed the
complexity seeds.

### Changed
- The *Resource & complexity smells* section splits into **Complexity smells** (universal, gated
  on nothing; N+1 generalised to expensive-call-in-a-loop) and **Resource-budget smells** (ship
  only with the budget machinery).
- `bootstrap-project`: complexity rides ordinary smell seeding; the budgets question governs only
  budget machinery; the seed check covers any missing section floor.
- Upgrader: an independent, unconditional complexity-smells offer.

## [0.21.0] — 2026-08-23 · [#6](https://github.com/rob-rivera/agile-lifecycle/pull/6), [#7](https://github.com/rob-rivera/agile-lifecycle/pull/7)

Resource budgets as first-class definition of done.

### Added
- Catalog: *Resource & complexity smells* — the errors invisible at development scale.
- `bench` lever in the template: the budget gates, `null` until ratified.
- story-format §5 budgeted-surfaces gate: stories touching a surface governed by a resource
  `LAW-*` run `bench` green.
- Bootstraps ask the budgets question at lever instantiation; brownfield treats incidents and
  prod limits as observed budgets pending ratification. Upgrader offers it to projects with a
  production surface, suppressed by any recorded answer.
- README documents `LAW-*` ids ([#5](https://github.com/rob-rivera/agile-lifecycle/pull/5)) and
  the resource-budgets contract feature.

## [0.20.0] — 2026-08-16 · [#2](https://github.com/rob-rivera/agile-lifecycle/pull/2)

### Added
- `feedback` skill — files an issue on this repo from inside a session: route check (project bugs
  go to `fix-bug`), mechanical context only, a checkpoint showing the exact issue before it leaves
  the machine, copy-paste fallback without `gh`.
- Issue forms (bug-report, friction-or-idea) mirroring the skill's fields.

## [0.19.3] — 2026-08-16 · [#1](https://github.com/rob-rivera/agile-lifecycle/pull/1)

The public release. MIT licence; README quickstart and pre-1.0 maturity stance; the originating
private project de-referenced.

### Added
- CI: `release-tag` (tags `v<version>` on merge to main, idempotent) and `pr-checks` (manifests
  parse, `shellcheck` on hooks, version-bump reminder).
- Upgrader respects alternative UI-craft choices (any design skill, or a recorded decline).

Earlier history (0.1 → 0.19.2, developed privately) lives in `git log`.

[0.25.0]: https://github.com/rob-rivera/agile-lifecycle/compare/v0.24.0...v0.25.0
[0.24.0]: https://github.com/rob-rivera/agile-lifecycle/compare/v0.23.0...v0.24.0
[0.23.0]: https://github.com/rob-rivera/agile-lifecycle/compare/v0.22.0...v0.23.0
[0.22.0]: https://github.com/rob-rivera/agile-lifecycle/compare/v0.21.0...v0.22.0
[0.21.0]: https://github.com/rob-rivera/agile-lifecycle/compare/v0.20.0...v0.21.0
[0.20.0]: https://github.com/rob-rivera/agile-lifecycle/compare/v0.19.3...v0.20.0
[0.19.3]: https://github.com/rob-rivera/agile-lifecycle/releases/tag/v0.19.3
