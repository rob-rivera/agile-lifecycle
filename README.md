# agile-lifecycle

A Claude Code plugin: an agile, TDD-disciplined development lifecycle for agent-driven projects.

This project was created with the belief that the literature is the ladder to the shoulders of
giants. LLM Assisted Development has afforded us an opportunity for self expression that hasn't
been witnessed since the internet as we know it unfolded in the 90s. I don't know how it all
shakes out in the end. Even the wisest cannot see all ends. What I do know is that if we're going
to use it, we should use it responsibly. This project provides a framework to systematically
build software that is not just working, it's good.

**Quickstart**

```sh
/plugin marketplace add rob-rivera/agile-lifecycle
/plugin install agile-lifecycle@agile-lifecycle
```

Then, in any project: `agile-lifecycle:bootstrap-project` (fresh folder),
`agile-lifecycle:bootstrap-legacy` (existing codebase), or `agile-lifecycle:bootstrap-prototype`
(throwaway answer-in-code). The hooks require `jq` on PATH (they no-op silently without it).

> **Maturity: pre-1.0, evolving.** The contract changes as it's road-tested; installed copies
> update when the plugin version bumps, so upgrades are deliberate, never surprises. MIT-licensed.
> Issues welcome — from inside a session, `agile-lifecycle:feedback` composes and files one for
> you. PRs by prior discussion, please — the suite's invariants are load-bearing.

> **Status: greenfield and brownfield.** `bootstrap-project` establishes the contract in a fresh
> project; `bootstrap-legacy` adopts it in an existing codebase (thin descriptive map, intent
> interview, `observed`/`ratified` knowledge tags, honest lever baselines, safety-net Slice 0).
> `bootstrap-project` routes brownfield folders to `bootstrap-legacy` automatically.

```
                     ┌──────────────────────────────────────────────┐
                     │              designed behavior               │
  change request →   │  write-stories → plan-cycles → implement-story  │
                     └──────────────────────────────────────────────┘
                          ▲             ▲
  small change  →  change-request ──────┘ (too large / contradiction routes to write-stories)
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
  mechanical recon → **instruction reconciliation** (nested/vendored `CLAUDE.md` and `.claude/`
  trees are live steering, not evidence — conflicts with the contract surface at a checkpoint;
  one project, one instruction authority) → fan-out survey → **thin descriptive map** (lazy
  excavation; depth per story) → intent interview (excavated knowledge tagged **`observed`**,
  human decisions promote to **`ratified`** — only ratified rules trigger the contradiction gate)
  → honest lever baselines (recorded, never fixed) → safety-net Slice 0 (characterize only the
  first area of change). Merges into existing `CLAUDE.md`/settings; never overwrites.
- **bootstrap-prototype** — prompt + empty folder → a runnable prototype: an answer in
  executable form, spike's sibling (the invariants govern *production*; a prototype isn't one,
  and its `PROTOTYPE.md` marker prints the price — no contract, no tests, no safety net).
  Bounded critical-question interview (everything else a named assumption in the marker's
  ledger), minimal `run` lever, re-entry checkpoint against feature creep, and a graduation
  gate: **keep it** → `bootstrap-legacy` excavates it (the marker is pre-written intent);
  **discard** → `bootstrap-project` with the knowledge. Never graduates silently.
- **orient** — greet the user and summarize what's next, one screen: on a lifecycle project,
  from the ledger/slice plan/debt registry, leading with the next actionable item and the skill
  that advances it; on any other repo, from branch/commits/README. Read-only — points at the
  next move, never makes it. The user-facing counterpart of the SessionStart orientation hook.
- **spike** — deep, budgeted research into a decidable question (the heavy-exploration lane):
  🛑 frame (question + budget + modes) → delegated gathering (surveyor for code, `researcher` for
  the outside world, `implementer` for measured probes on a throwaway branch) → 🛑 evidence-cited
  synthesis with stated confidence → dated `SPIKE-nnnn` record, decision ratified into the docs,
  branch deleted. The iron rule: spike code never merges — knowledge survives, code dies.
- **write-stories** — change request (slice, freeform prompt, or test-cycle feedback) →
  implementation-ready stories: INVEST reinterpreted for agents, sizing as a vector of countable
  signals, design-contradiction gate first, human checkpoints for precedence/breakdown/splits.
- **plan-cycles** — sized story → thin TDD cycle spine. Pins each cycle's Red (the failing test *is*
  the spec); Green stays the implementer's latitude; Refactor by reference into the guardrails doc.
- **implement-story** — the orchestrator: fresh sub-agent per behavioral cycle, sequential,
  mechanical independent validation, a git commit per validated cycle (durable resume), calibratable
  user checkpoints.
- **change-request** — the compressed lane for small behavioral changes: one invocation, one
  approval (the change card: summary, ACs, tightened sizing vector — **≤2 cycles, 0 new
  contracts, 0 unknowns** — plus inline cycle annotations), then canonical RGR with execution
  calibrated and the full §5 close gate. Ceremony compresses; sizing and discipline never do.
  A tripped signal, a design contradiction, a failed-retries cycle, or mid-flight scope
  discovery all route to write-stories with the intake work as the story's head start.
  Change-requests are standard `STORY-nnnn` rows — no new id family.
- **fix-bug** — report of unexpected behavior → reproduce → root-cause → verdict (genuine bug /
  working-as-designed / on-the-line). Genuine bugs get a failing-first regression test and a minimal
  fix, or a durable `BUG-nnnn` record when deferred. Resource/performance symptoms are bugs: the
  reproduction is a measurement, the Red a failing gate against a ratified bound.
- **refactor-pass** — entropy paydown for one named module/file, under Fowler's sensibility:
  assess against both smell catalogs → human selects findings → characterization net first →
  small named moves, levers green after each, per-move commits → `REF-nnnn` pass record with
  dispositions. Explicitly green-to-green (the suite's one deliberate exception to RGR). Symptoms
  route to fix-bug; contract/behavior changes route to write-stories.

- **feedback** — plugin feedback from inside any session: a bug in a skill/hook/template,
  friction in the procedure, or an idea, routed to this repo's GitHub issues (`gh issue create`,
  with a copy-paste fallback when `gh` isn't available). One 🛑 checkpoint shows the exact issue
  before anything leaves the machine; project content never rides along unconsented. Project
  bugs route to `fix-bug` — this lane is for the machinery itself.

The through-line: **skills are the procedure; the project supplies the specification.** Every skill
reads the project's authority docs live and never hardcodes their content.

## The project contract

An adopting project provides these (defaults shown; a project may rename them — its CLAUDE.md should
say so):

| Role | Default path | Required by |
| --- | --- | --- |
| Story format & sizing spec, incl. §8 **craft anchors** (books cited at drafting moments — never role personas; the doc wins on conflict) | `docs/story-format.md` | all build/fix skills (§-references must hold — seed from `templates/story-format.md`) |
| Guardrails catalog (two-sided: smells to move away from + patterns to move toward, with *Candidates* inbox + canonical-TDD rules; patterns are refactoring destinations named canonically from the literature, never design starting points) | `docs/guardrails.md` | plan-cycles, implement-story, fix-bug, refactor-pass (seeded by bootstrap from `references/code-smells.md` + thinly from `references/patterns.md`) |
| Tech design (architecture boundaries + test-layers section) | `docs/tech-design.md` | all |
| Domain design doc (settled product/system rules) | `docs/design.md` | write-stories, fix-bug |
| Roadmap / slice plan | `docs/slice-plan.md` | write-stories (optional origin) |
| Lever manifest — one truth for agents, humans, and host-app runner UIs. Canonical shape: `{"<name>": {"command": string\|null, "what": string}}` (bare-string shorthand allowed; `null` = documented gap). `test`/`lint`/`run` are the standard levers, and a long-running `run` pairs with an explicit `stop` (how to kill what `run` started — never implicit process knowledge); projects may add more (seed from `templates/levers.json`) | `levers.json` | implement-story, fix-bug (raw toolchain gates until defined; `scripts/` wrappers optional) |
| Model policy (sub-agent model per role; orchestrator model is the session's, recommended in CLAUDE.md) | `.claude/agents/implementer.md`, `implementer-heavy.md`, `diagnostician.md`, `researcher.md` | implement-story, fix-bug, spike (fallback when absent: general-purpose sub-agent, `inherit`) |
| Work ledger (one row per STORY/BUG/REF; statuses owned by the skills that change them — "what's outstanding?" lives here, the slice plan stays intention) | `docs/ledger.md` | all build/fix/refactor skills |
| Debt registry (observed-but-unfixed structural debt, `DEBT-nnnn`; fed by implementer reports at the affirmative close gate, consumed by refactor-pass at intake, promoted to stories only by human decision) | `docs/debt.md` | implement-story, fix-bug, refactor-pass |
| Artifacts | `docs/stories/STORY-nnnn-*.md`, `docs/bugs/BUG-nnnn-*.md`, `docs/refactors/REF-nnnn-*.md`, `docs/spikes/SPIKE-nnnn-*.md` | written by the skills |
| Contract version stamp (one line: the plugin version the contract was instantiated/last reviewed against; written by the bootstraps and every upgrade review — the SessionStart hook compares it to the loaded plugin and announces drift) | `docs/.contract-version` | SessionStart hook (advisory only) |

The plugin also ships two agents of its own (plugin machinery, deliberately cheaper than the
session model; projects may override by name): **`surveyor`** (haiku) — bootstrap-legacy's
fan-out reader — and **`upgrader`** (sonnet) — the contract mechanic that diffs a project against
the current contract and instantiates approved pieces on the resume/upgrade path, including the
**migration report** for prior-iteration projects (skill shadowing, role-equivalent renames,
schema drift — every retirement/rename/patch a human decision; local-skills-or-plugin, never
both).

`bootstrap-project` creates all of the above in a greenfield project. Plugin references
(`references/code-smells.md`, `references/patterns.md`, `references/sensibilities.md`) are plugin knowledge, not project
artifacts — the ladder to the giants' shoulders (Fowler/Beck, Meszaros, GoF/Kerievsky, and the
sensibility roster's corpus anchors).

Conventions carried across projects: `STORY-nnnn` / `BUG-nnnn` / `AC-*` / `LAW-*` ids; per-cycle
commits on story/fix branches (never `main`); disposable plans burned at story close; the
affirmative candidates gate ("candidates: none" is a required statement, not a default).

## Hooks (ship with the plugin)

Prose asks; hooks enforce. Four ship out of the box, all **lifecycle-guarded** (silent no-op in
any project without `docs/story-format.md`) and **fail-open** (any script surprise → exit 0;
requires `jq`, silently inactive without it):

- **Stop — the ledger reconciliation gate.** A turn cannot end while the books don't balance:
  STORY/BUG/REF files without ledger rows, or rows without files, block the stop once with a
  fix list. Presence checks only — status semantics stay in the skills.
- **SessionStart — orientation.** Injects branch, outstanding ledger rows, and open debt count,
  so no session starts cold — plus **contract-drift detection**: when the project's
  `docs/.contract-version` stamp is older than the loaded plugin (or absent), one advisory line
  points at `bootstrap-project`'s upgrade review. Advisory only; equal-or-newer stays silent.
- **PostToolUse — instant nudge.** Writing a work-item file with no ledger row injects the
  reminder immediately; the Stop gate is the backstop.
- **PreToolUse — the branch invariant.** `git commit` on main surfaces a confirmation (ask, not
  deny — deliberate main commits exist).

Not hooked, deliberately: the candidates/debt affirmations — verifying an affirmation is
judgment, not pattern-matching, and stays skill discipline.

## Install

**Per-session (no install)** — point any session at a checkout or zip:

```sh
claude --plugin-dir /path/to/agile-lifecycle
```

**Via marketplace** — this repo is its own marketplace (`.claude-plugin/marketplace.json` lists
itself). With access to the GitHub repo:

```sh
/plugin marketplace add rob-rivera/agile-lifecycle
/plugin install agile-lifecycle@agile-lifecycle
```

Skills are then invocable as `agile-lifecycle:write-stories`, etc. Updates ship by version bump —
installed copies update when `plugin.json`'s `version` changes. Requires `jq` on PATH for the
hooks (they no-op silently without it); hook scripts assume a POSIX shell with `bash` available.

**Team auto-registration** — a project repo can check this into `.claude/settings.json` so
collaborators who trust the folder get the marketplace registered automatically:

```json
{
  "extraKnownMarketplaces": {
    "agile-lifecycle": {
      "source": { "source": "github", "repo": "rob-rivera/agile-lifecycle" }
    }
  },
  "enabledPlugins": { "agile-lifecycle@agile-lifecycle": true }
}
```

**Embedded** — an app wrapping the Claude Code CLI can bundle this repo and pass `--plugin-dir` at
spawn, shipping the lifecycle with the app (no user installation).

A project-level skill with the same name overrides the plugin's version — that is the intended
per-project customization mechanism.

## Origin

Extracted from an earlier private project where the suite was developed and road-tested; the
project-specific variants there (language-specific guardrails references, toolchain levers) are
instances of this contract. It now governs several projects, including the desktop app that
bundles it.
