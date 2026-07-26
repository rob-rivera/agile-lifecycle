---
name: bootstrap-legacy
description: >-
  Adopt the agile-lifecycle contract in an existing codebase with no contract: reconnaissance,
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
- Otherwise proceed. Enumerate **prior-knowledge sources** in rough trust order: `CLAUDE.md` ≈ CI
  configs (operationally honest) > README > code comments > `docs/` prose (rots fastest). All of
  it enters as *observed*-grade evidence.

### 1 — Reconnaissance (mechanical)
Stack and manifests; repo size and shape; existing tests and how they're run; lint/format configs;
CI pipelines (lever candidates); git-history hotspots (frequently-changed files mark where work
actually happens); the prior-knowledge sources above. Produce a one-screen inventory. No judgment
yet, no code reading beyond skimming entry points.

### 2 — 🛑 Survey → thin descriptive map (`docs/tech-design.md`)
Fan out **parallel read-only sub-agents**, one per subsystem/area (this is the fan-out job the
story format reserves workflows for). Each returns: what the area owns, its entry points, its
load-bearing contracts, what it actually depends on, and any obvious hazards. Synthesize into a
**thin map**, not an encyclopedia — `tech-design.md` drafted **descriptively** (the architecture
as it *is*, warts included, everything tagged `observed`). The map says where things are; stories
earn the detail later (**lazy excavation** — depth happens per-story, when an area is implicated).
**Stop for review.**

### 3 — 🛑 Intent interview (`docs/design.md`)
Grounded in the survey, interview the human — they usually know this domain deeply. What is this
system for, what must never happen, which observed behaviors are load-bearing intent vs. accident?
Draft the domain doc; **ratify the first batch of rules live in the interview** (these become the
first `LAW-*` candidates), leave the rest `observed`. Park unknowns in Open Questions. **Stop for
approval.**

### 4 — 🛑 Evolution sensibility
The architecture exists; the choice is what taste governs where it *goes*. Present **3–5 options**
from `references/sensibilities.md` (recommendation + reasoning; generic discouraged), record the
choice as a **Direction** note in `tech-design.md` — descriptive sections say what is; Direction
says what new code aims at. **Stop for the user's choice.**

### 5 — Levers & the honest baseline
Discover the real test/lint/run commands (recon usually found them); write `levers.json`. **Run
the levers and record what actually happens** — failing tests, lint violations, flaky suites — as
the documented baseline (in `tech-design.md` §7). **Bootstrap never fixes the baseline**; fixing
is stories. A red baseline is information, not an emergency.

### 6 — Mechanical contract (no persona)
- `docs/story-format.md` — from the template, unchanged in structure.
- `docs/guardrails.md` — from the template; seed smells from `references/code-smells.md` per the
  stack (🛑 approve the selection), **plus the legacy-safety patterns** (seams, sprout/wrap,
  characterization) into §2, plus any project anti-patterns the survey observed — as dated
  *candidates*, not settled entries.
- `.claude/agents/` — the model policy, exactly as in `bootstrap-project` (same templates, same
  🛑 mapping approval, same session-restart caveat).
- `CLAUDE.md` — **merge** contract pointers into whatever exists.

### 7 — 🛑 Slice plan — the safety net, not a skeleton
The app already walks; the brownfield promise is "we can prove we didn't break what already
works." Propose:
- **Slice 0 — safety net where you'll work:** levers proven (witnessed failing, then green — or
  witnessed *matching the recorded baseline*), plus **characterization tests pinning current
  behavior in the first target area only.** Characterize what you're about to change — never a
  coverage campaign across the codebase.
- **Slice 1 — the actual goal:** the change the user came here to make (there almost always is
  one; ask).
**Stop for approval.**

### 8 — 🛑 Handoff
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
- **Never overwrites existing `CLAUDE.md`, settings, hooks, or skills** — merge only.
- **Never scaffolds or refactors code** — same as greenfield: the contract, then handoff.
