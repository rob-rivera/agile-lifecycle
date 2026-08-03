---
name: bootstrap-legacy
description: >-
  Adopt the agile-lifecycle contract in an existing codebase with no contract: reconnaissance,
  instruction-file reconciliation (nested/vendored CLAUDE.md and .claude trees vs. the contract),
  a fan-out survey producing a thin descriptive map, an intent interview that ratifies excavated
  knowledge, honest lever baselines, and a safety-net Slice 0 scoped to the first area of change.
  Runs under Michael Feathers's sensibility; excavates lazily (map upfront, depth per story).
  Use on a legacy/brownfield project — one with real code but no docs/story-format.md.
---

# Bootstrap Legacy

Adopt the lifecycle in a codebase that already exists. Greenfield bootstrap authors *intent* and
builds code to match; here the code exists and the intent was never recorded — so the product of
this skill is **enough reconstructed intent for the gates to function**, not documentation for its
own sake. The code is the only witness that never lies; everything else — READMEs, comments, an
old CLAUDE.md, memory — is a claim to verify against it.

**Process sensibility: Michael Feathers** (*Working Effectively with Legacy Code*) — seams,
characterization tests, sprout/wrap, "safety net where you work." Channel the published
principles; never "you are X." The invariants outrank everything, here as everywhere:
**story-driven production, test-driven development.**

## The two status tags (load-bearing)

Excavated knowledge is tagged, and the tag is part of the project contract:

- **`observed`** — "the code does X." An agent can produce this; it says nothing about intent.
  Observed entries do **not** trigger the design-contradiction gate — a story conflicting with an
  observed behavior raises a **ratification prompt** instead ("the code does X; you're asking for
  Y — is X intended?").
- **`ratified`** — a human confirmed X is intended. Ratified entries are settled rules: the
  contradiction gate enforces them, `LAW-*` ids cite them, `fix-bug` verdicts stand on them.

Only a human decision promotes observed → ratified (date the promotion). Intent accretes through
use — most ratification happens later, story by story, not during bootstrap.

## Authority (read first)

- This plugin's `templates/` and `references/` (`code-smells.md` incl. the legacy-safety patterns;
  `sensibilities.md`).
- **Merge, never replace:** existing `CLAUDE.md`, `.claude/` settings, hooks, and skills are
  someone's working setup. Bootstrap adds its contract pointers *into* them; it never overwrites.

## Procedure

### 0 — Detect state & route
- Contract present (`docs/story-format.md`) → this is a lifecycle project; route to
  `bootstrap-project`'s resume/upgrade path.
- No real code (greenfield by `bootstrap-project`'s tiers) → route to `bootstrap-project`.
- Otherwise proceed. Enumerate **prior-knowledge sources** in rough trust order: `PROTOTYPE.md`
  (a `bootstrap-prototype` marker — intent recorded at authoring time, the one source that
  outranks the code's own docs) > `CLAUDE.md` ≈ CI configs (operationally honest) > README >
  code comments > `docs/` prose (rots fastest). All of it enters as *observed*-grade evidence —
  the marker included; recorded intent still gets ratified by a human, not grandfathered.

### 1 — Reconnaissance (mechanical)
Stack and manifests; repo size and shape; existing tests and how they're run; lint/format configs;
CI pipelines (lever candidates); git-history hotspots (frequently-changed files mark where work
actually happens); the prior-knowledge sources above. Enumerate the **full instruction surface**:
every `CLAUDE.md` (root *and* nested — vendored/pulled subtrees included), `CLAUDE.local.md`, and
`.claude/` tree (settings, agents, skills, hooks, commands), each classified project-owned vs.
vendored. Produce a one-screen inventory. No judgment yet, no code reading beyond skimming entry
points.

### 2 — 🛑 Instruction reconciliation
Instruction files are not just evidence — they are **live steering**: the harness merges every
in-scope `CLAUDE.md` by directory, so a vendored repo's instructions compete with this project's
contract in every future session (and this one — reconcile *before* the survey fan-out). From the
recon inventory, build a conflict table: each non-root instruction file, its owner, and every
directive that contradicts the root `CLAUDE.md`, the contract docs, or another instruction file
(conflicting commands, conventions, precedence claims; skill/agent name collisions). Present it
and **stop** — every resolution is the human's:
- **keep** — scoped and consistent; record that it was checked.
- **subordinate** — the root `CLAUDE.md` gains a dated precedence note naming the file and the
  conflicts the contract wins. The only durable cure for a vendored file a re-sync would restore —
  edit the root, never the vendored file.
- **archive** — project-owned strays move aside reversibly (never delete).
- **absorb** — true claims about the code enter as `observed` evidence before the file is
  subordinated or archived.
State the governing rule plainly at the checkpoint: **one project, one instruction authority.**
Nested instruction files either serve the root contract or are explicitly subordinated — never
silent coexistence in contradiction. No conflicts → say so explicitly and move on.

### 3 — 🛑 Survey → thin descriptive map (`docs/tech-design.md`)
Fan out **the plugin's `surveyor` agent** in parallel, one per subsystem/area (this is the fan-out
job the story format reserves workflows for). The surveyor is plugin machinery pinned to a cheap
model precisely so a frontier-model session doesn't multiply itself across the fan-out — **never
dispatch general-purpose/inheriting agents for the survey**. Before launching, state the plan —
"N areas, N surveyor agents (model per the plugin's surveyor definition)" — so the user can trim
the area list. Each returns a bounded, observed-only structural summary. Synthesize into a
**thin map**, not an encyclopedia — `tech-design.md` drafted **descriptively** (the architecture
as it *is*, warts included, everything tagged `observed`). The map says where things are; stories
earn the detail later (**lazy excavation** — depth happens per-story, when an area is implicated).
**Stop for review.**

### 4 — 🛑 Intent interview (`docs/design.md`)
Grounded in the survey, interview the human — they usually know this domain deeply. What is this
system for, what must never happen, which observed behaviors are load-bearing intent vs. accident?
Draft the domain doc; **ratify the first batch of rules live in the interview** (these become the
first `LAW-*` candidates), leave the rest `observed`. Park unknowns in Open Questions. **Stop for
approval.**

### 5 — 🛑 Evolution sensibility
The architecture exists; the choice is what taste governs where it *goes*. Present **3–5 options**
from `references/sensibilities.md` (recommendation + reasoning; generic discouraged), record the
choice as a **Direction** note in `tech-design.md` — descriptive sections say what is; Direction
says what new code aims at. **Stop for the user's choice.**

### 6 — Levers & the honest baseline
Discover the real test/lint/run commands (recon usually found them); write `levers.json`. **Run
the levers and record what actually happens** — failing tests, lint violations, flaky suites — as
the documented baseline (in `tech-design.md` §7). **Bootstrap never fixes the baseline**; fixing
is stories. A red baseline is information, not an emergency.

### 7 — Mechanical contract (no persona)
- `docs/story-format.md` — from the template, unchanged in structure.
- `docs/guardrails.md` — from the template; seed smells from `references/code-smells.md` per the
  stack (🛑 approve the selection), **plus the legacy-safety patterns** (seams, sprout/wrap,
  characterization) into §2, plus any project anti-patterns the survey observed — as dated
  *candidates*, not settled entries.
- `.claude/agents/` — the model policy, exactly as in `bootstrap-project` (same templates, same
  🛑 mapping approval, same session-restart caveat, same optional **UI-craft preload** offer for
  projects with a user-facing frontend — verify-installed caveat and the 🛑 **look-and-feel
  definition** offer included; in a brownfield the existing UI is the draft's starting point,
  and recording its *observed* tokens is also how an inherited look becomes a settled rule).
- `docs/ledger.md` and `docs/debt.md` — empty from their templates. The survey's observed
  hazards that are clearly structural debt may seed the registry as its first dated entries.
- `CLAUDE.md` — **merge** contract pointers into whatever exists. Phase 2's precedence notes
  live here — the root records which nested instruction files were subordinated and on what.

### 8 — 🛑 Slice plan — the safety net, not a skeleton
The app already walks; the brownfield promise is "we can prove we didn't break what already
works." Propose:
- **Slice 0 — safety net where you'll work:** levers proven (witnessed failing, then green — or
  witnessed *matching the recorded baseline*), plus **characterization tests pinning current
  behavior in the first target area only.** Characterize what you're about to change — never a
  coverage campaign across the codebase.
- **Slice 1 — the actual goal:** the change the user came here to make (there almost always is
  one; ask).
**Stop for approval.**

### 9 — 🛑 Handoff
One screen: the map, the ratified rules so far, the baseline, the slice plan. Then:
**"Contract ready — run `write-stories` for Slice 0."** Remind about the agent-registration
restart. Bootstrap is done; it fixed nothing, and that's correct.

## Guardrails — what this skill never does

- **Never treats a claim as behavior** — docs, comments, and CLAUDE.md are evidence to verify
  against code, entering as `observed`.
- **Never marks knowledge `ratified` without a human decision**, and never lets an `observed`
  entry trigger the contradiction gate — observed conflicts prompt ratification instead.
- **Never surveys exhaustively** — thin map upfront; depth is earned per-story.
- **Never fixes the baseline** — failing levers are recorded, and repair happens through stories.
- **Never characterizes beyond the first target area** — safety net where you work.
- **Never overwrites existing `CLAUDE.md`, settings, hooks, or skills** — merge only;
  reconciliation archives or subordinates solely through phase 2's approved decisions.
- **Never leaves an instruction-file contradiction unreconciled** — every conflict surfaces at
  the phase-2 checkpoint, and the cure for a vendored file is a precedence note in the root,
  never an edit a re-sync would silently revert.
- **Never scaffolds or refactors code** — same as greenfield: the contract, then handoff.
