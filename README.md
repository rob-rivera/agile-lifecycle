# agile-lifecycle

A Claude Code plugin: an agile, TDD-disciplined development lifecycle for agent-driven projects.

> **Status: greenfield and brownfield.** `bootstrap-project` establishes the contract in a fresh
> project; `bootstrap-legacy` adopts it in an existing codebase (thin descriptive map, intent
> interview, `observed`/`ratified` knowledge tags, honest lever baselines, safety-net Slice 0).
> `bootstrap-project` routes brownfield folders to `bootstrap-legacy` automatically.

```
                     ┌──────────────────────────────────────────────┐
                     │              designed behavior               │
  change request →   │  write-stories → plan-cycles → implement-story  │
                     └──────────────────────────────────────────────┘
                                        ▲
  observed behavior →  fix-bug ─────────┘ (working-as-designed routes to write-stories)
```

## Skills

- **bootstrap-project** — bare folder → the project contract. Four checkpointed conversations:
  product (domain design doc), stack + **design sensibility** (3–5 curated persona options with a
  recommendation — generic architect available but discouraged), architecture under the chosen
  sensibility (tech design), then mechanical instantiation: story format from template, guardrails
  **seeded from the canonical smell catalog** in the stack's idiom, the `levers.json` manifest, and
  a slice plan whose Slice 0 is the **walking skeleton** (the app the customer can already open).
  Ends by handing off to write-stories; never scaffolds code. Invariants no sensibility can
  negotiate: story-driven production, test-driven development.
- **bootstrap-legacy** — adopt the contract in an existing codebase, under Feathers's sensibility:
  mechanical recon → fan-out survey → **thin descriptive map** (lazy excavation; depth per story)
  → intent interview (excavated knowledge tagged **`observed`**, human decisions promote to
  **`ratified`** — only ratified rules trigger the contradiction gate) → honest lever baselines
  (recorded, never fixed) → safety-net Slice 0 (characterize only the first area of change).
  Merges into existing `CLAUDE.md`/settings; never overwrites.
- **write-stories** — change request (slice, freeform prompt, or test-cycle feedback) →
  implementation-ready stories: INVEST reinterpreted for agents, sizing as a vector of countable
  signals, design-contradiction gate first, human checkpoints for precedence/breakdown/splits.
- **plan-cycles** — sized story → thin TDD cycle spine. Pins each cycle's Red (the failing test *is*
  the spec); Green stays the implementer's latitude; Refactor by reference into the guardrails doc.
- **implement-story** — the orchestrator: fresh sub-agent per behavioral cycle, sequential,
  mechanical independent validation, a git commit per validated cycle (durable resume), calibratable
  user checkpoints.
- **fix-bug** — report of unexpected behavior → reproduce → root-cause → verdict (genuine bug /
  working-as-designed / on-the-line). Genuine bugs get a failing-first regression test and a minimal
  fix, or a durable `BUG-nnnn` record when deferred. Resource/performance symptoms are bugs: the
  reproduction is a measurement, the Red a failing gate against a ratified bound.
- **refactor-pass** — entropy paydown for one named module/file, under Fowler's sensibility:
  assess against both smell catalogs → human selects findings → characterization net first →
  small named moves, levers green after each, per-move commits → `REF-nnnn` pass record with
  dispositions. Explicitly green-to-green (the suite's one deliberate exception to RGR). Symptoms
  route to fix-bug; contract/behavior changes route to write-stories.

The through-line: **skills are the procedure; the project supplies the specification.** Every skill
reads the project's authority docs live and never hardcodes their content.

## The project contract

An adopting project provides these (defaults shown; a project may rename them — its CLAUDE.md should
say so):

| Role | Default path | Required by |
| --- | --- | --- |
| Story format & sizing spec | `docs/story-format.md` | all build/fix skills (§-references must hold — seed from `templates/story-format.md`) |
| Guardrails catalog (one test+code smell catalog + *Candidates* inbox + canonical-TDD rules) | `docs/guardrails.md` | plan-cycles, implement-story, fix-bug (seeded by bootstrap from `references/code-smells.md`) |
| Tech design (architecture boundaries + test-layers section) | `docs/tech-design.md` | all |
| Domain design doc (settled product/system rules) | `docs/design.md` | write-stories, fix-bug |
| Roadmap / slice plan | `docs/slice-plan.md` | write-stories (optional origin) |
| Lever manifest (the `test`, `lint`, and `run` commands — one truth for agents, humans, and host-app runner UIs) | `levers.json` | implement-story, fix-bug (raw toolchain gates until defined; `scripts/` wrappers optional) |
| Model policy (sub-agent model per role; orchestrator model is the session's, recommended in CLAUDE.md) | `.claude/agents/implementer.md`, `implementer-heavy.md`, `diagnostician.md` | implement-story, fix-bug (fallback when absent: general-purpose sub-agent, `inherit`) |
| Artifacts | `docs/stories/STORY-nnnn-*.md`, `docs/bugs/BUG-nnnn-*.md`, `docs/refactors/REF-nnnn-*.md` | written by the skills |

The plugin also ships one agent of its own: **`surveyor`** (`agents/surveyor.md`, pinned to a
cheap model) — bootstrap-legacy's fan-out reader, deliberately not the session's model so wide
surveys stay cheap. Projects may override it with their own `surveyor` definition.

`bootstrap-project` creates all of the above in a greenfield project. Plugin references
(`references/code-smells.md`, `references/sensibilities.md`) are plugin knowledge, not project
artifacts — the ladder to the giants' shoulders (Fowler/Beck, Meszaros, and the sensibility roster's
corpus anchors).

Conventions carried across projects: `STORY-nnnn` / `BUG-nnnn` / `AC-*` / `LAW-*` ids; per-cycle
commits on story/fix branches (never `main`); disposable plans burned at story close; the
affirmative candidates gate ("candidates: none" is a required statement, not a default).

## Install

**Per-session (no install)** — point any session at a checkout or zip:

```sh
claude --plugin-dir /path/to/agile-lifecycle
```

**Via marketplace** — add this repo to a marketplace and `/plugin install agile-lifecycle`, or use
the `claude plugin` CLI. Skills are then invocable as `agile-lifecycle:write-stories`, etc.

**Embedded** — an app wrapping the Claude Code CLI can bundle this repo and pass `--plugin-dir` at
spawn, shipping the lifecycle with the app (no user installation).

A project-level skill with the same name overrides the plugin's version — that is the intended
per-project customization mechanism.

## Origin

Extracted from the territory-manager project, where the suite was developed and road-tested. The
project-specific variants there (e.g. `rust-guardrails.md` references, Rust toolchain levers) are
instances of this contract.
