# agile-lifecycle

A Claude Code plugin: an agile, TDD-disciplined development lifecycle for agent-driven projects.

```
                     ┌──────────────────────────────────────────────┐
                     │              designed behavior               │
  change request →   │  write-stories → plan-cycles → implement-story  │
                     └──────────────────────────────────────────────┘
                                        ▲
  observed behavior →  fix-bug ─────────┘ (working-as-designed routes to write-stories)
```

## Skills

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
  fix, or a durable `BUG-nnnn` record when deferred.

The through-line: **skills are the procedure; the project supplies the specification.** Every skill
reads the project's authority docs live and never hardcodes their content.

## The project contract

An adopting project provides these (defaults shown; a project may rename them — its CLAUDE.md should
say so):

| Role | Default path | Required by |
| --- | --- | --- |
| Story format & sizing spec | `docs/story-format.md` | all four skills (§-references must hold — seed from `templates/story-format.md`) |
| Guardrails catalog (test/code/smell patterns + *Candidates* inbox + canonical-TDD rules) | `docs/guardrails.md` | plan-cycles, implement-story, fix-bug |
| Tech design (architecture boundaries + test-layers section) | `docs/tech-design.md` | all four |
| Domain design doc (settled product/system rules) | project-named | write-stories, fix-bug |
| Roadmap / slice plan | `docs/slice-plan.md` | write-stories (optional origin) |
| Levers | `scripts/test.sh`, `scripts/lint.sh` | implement-story, fix-bug (raw toolchain gates until they exist) |
| Artifacts | `docs/stories/STORY-nnnn-*.md`, `docs/bugs/BUG-nnnn-*.md` | written by the skills |

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
