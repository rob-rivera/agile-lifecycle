---
name: bootstrap-project
description: >-
  Take a greenfield (empty or near-empty) project from bare folder to the agile-lifecycle contract:
  domain design, tech design under a chosen design sensibility, story format, seeded guardrails,
  lever manifest, and a slice plan whose Slice 0 is the walking skeleton. Ends by handing off to
  write-stories — it builds the contract, never the project. Use when opening a new project that
  has no docs/story-format.md. Refuses brownfield codebases.
---

# Bootstrap Project

Take a bare folder to the point where the lifecycle can take over. **Bootstrap builds the contract,
not the project** — the moment the authority docs exist, `write-stories` → `plan-cycles` →
`implement-story` build everything else, starting with Slice 0. This skill never scaffolds code.

## Invariants (non-negotiable)

Two things are settled before any conversation starts, and no sensibility, stack, or preference
negotiates them:

- **Story-driven production.** All work enters as stories through `write-stories`.
- **Test-driven development.** Canonical Red→Green→Refactor with witnessed red, per the plugin's
  skills and the guardrails' canonical rules.

## Authority (read first)

- This plugin's `templates/` — `story-format.md`, `design.md`, `tech-design.md`, `guardrails.md`.
- This plugin's `references/` — `code-smells.md` (the smell catalog + per-language notes),
  `sensibilities.md` (the persona roster and its rules of use).
- **Greenfield only.** A folder with an existing codebase is brownfield; the adoption process for
  that is not yet defined — stop and say so rather than improvise.

## Procedure

Four conversations, each ending in a human-approved artifact, then a mechanical instantiation and a
handoff. **Sensibility applies to phase 3 only** — never to mechanical phases, where personas are
noise (and cost).

### 0 — Detect state

**Check for the contract first.** If `docs/story-format.md` exists, this is already a lifecycle
project — code presence is *expected* (it was built through the discipline) and is never grounds
for a brownfield stop. Take the **resume/upgrade path**, delegated to the plugin's **`upgrader`
agent** (mid-tier by design — checks and file mechanics don't need the orchestrator's model):
dispatch it in **diff mode** to compare the project against the current contract (this doc's
phase 4 list) and report missing pieces, pending decisions, and ledger backfill candidates; 🛑
present that report with the decisions framed for the human; then dispatch **execute mode** with
the approved plan. Fill only what's missing — a project bootstrapped under an older plugin
version picks up new contract pieces (a missing lever, the model policy, the registries) this
way, each through its normal checkpoint. Never overwrite an approved artifact. Spot-check the
written files before declaring the upgrade done, and end with the session-restart reminder if any
agents were created.

**Prior-iteration projects** (an earlier dialect of this framework: local skill copies, renamed
authority docs, older schemas) get the upgrader's **migration report** in the same diff —
`shadows`, `equivalents`, `drift` — and a 🛑 **migration checkpoint** where every retirement,
rename, and patch is the human's call. The governing rule to state plainly at that checkpoint:
**a project is governed by its local skill copies or by the plugin — never both.** A shadowed
skill name silently runs the old procedure against the new contract, so the checkpoint's real
output is that choice, made explicitly: retire the locals (archived to `.claude/skills.retired/`,
reversible) or declare them deliberate overrides and skip the plugin's contract additions they
don't know about. Divergent content is ratified side-by-side, never silently merged. A skill
retirement or rename takes effect at the next session restart — say so.

Otherwise, **"empty" means empty of *decisions*, not empty of files.** The gate question for
anything found: *would bootstrap have to reverse-engineer intent from it?* Classify what's present:

- **Ignore (still greenfield)** — files embodying no design decisions: VCS scaffolding (`.git`,
  `.gitignore`), license, README/prose, editor and tool dotfiles, CI stubs. A repo initialized with
  README + license + gitignore is the canonical greenfield project.
- **Evidence (greenfield; disclose and absorb)** — toolchain manifests and untouched starter
  scaffolds (`cargo new`'s hello-world, a bare `npm init` package.json): they carry exactly one
  decision — the stack. Proceed, and open phase 2 with it: "found `Cargo.toml` — treating Rust as
  chosen unless you say otherwise." Prior design prose in `docs/` is likewise not code — offer it
  as phase 1 input.
- **Brownfield → route** — source implementing actual behavior (anything a characterization test
  could meaningfully guard) *without* the contract: real logic, tests, wired-up modules. Name what
  was found and hand off to **`bootstrap-legacy`** — adopting a codebase is excavation, not
  authoring, and it has its own skill.
- No git repo → offer `git init` first (per-cycle commits are the lifecycle's resume mechanism).

### 1 — 🛑 The product conversation → `docs/design.md`
What are we building, for whom, to what outcome? Draft the domain design doc from
`templates/design.md`: vision, core concepts (the ubiquitous language), first rules — flag the
load-bearing ones as `LAW-*` candidates. Park genuine unknowns in Open Questions; they become
spikes, not blockers. **Stop for approval.**

### 2 — 🛑 Stack & sensibility
Settle the stack (languages, frameworks, platform) from the product's needs. Then, from
`references/sensibilities.md`, present **3–5 design sensibilities** filtered by project type and
stack, **with one recommendation and the reason for it**. The generic architect is available on
request but **not recommended** — the centroid produces unfocused, token-expensive documents (the
roster doc explains). **Stop for the user's choice.**

### 3 — 🛑 The architecture conversation → `docs/tech-design.md`
**Channel the chosen sensibility's published principles** (never "you are X") and draft the tech
design from `templates/tech-design.md`: goals and non-goals, layers and boundaries, contracts,
determinism policy, the `LAW-*` registry (promote phase 1's candidates), the **test layers** for
this stack, toolchain and levers. The sensibility shapes taste — what to leave out, what to insist
on; the invariants outrank it everywhere. **Stop for approval.**

### 4 — Mechanical instantiation (no persona; MAY delegate the mechanics to `upgrader`)
- `docs/story-format.md` — from the template; project name and any doc-name adjustments only. The
  §-structure is load-bearing (skills cite it) — do not restructure. Confirm the **§8 craft
  anchors** with the user (defaults ship in the template; swap per project taste — books cited,
  never role personas).
- `docs/guardrails.md` — from the template. **Seed the smells**: select from
  `references/code-smells.md` the entries relevant to the stack, express each in the stack's idiom
  (tell + cure, per the reference's per-language notes), one catalog for code and test smells
  alike. 🛑 **Present the selection for approval** — seeding is a judgment, not a copy.
- `levers.json` (repo root) — the machine-readable lever manifest: the project's `test`, `lint`,
  and `run` commands (`run` launches the app itself — the walking skeleton gives it something to
  launch). Provisional until Slice 0 proves them (a lever nobody has seen fail is an unwitnessed
  red). Optional thin `scripts/` wrappers for CLI convenience.
- `.claude/agents/` — **the model policy**: instantiate every template in `templates/agents/`
  into the project (`implementer`, `implementer-heavy`, `diagnostician`, `researcher`). Two
  knobs, owned by the project, not the plugin:
  - **Sub-agent models** — the `model:` line in each agent file (aliases track tiers:
    haiku/sonnet/opus/fable; `inherit` = the session's model). Routine cycle work usually runs a
    tier below the orchestrator; escalation usually `inherit`s; diagnosis defaults strong
    (judgment-heavy).
  - **Orchestrator model** — *is the session's model*; no skill can set it. Record the
    recommendation per activity in `CLAUDE.md` (e.g. "design/story work: frontier tier;
    implementation orchestration: one tier down") — the user applies it with `/model`.
  🛑 **Present the proposed role→model mapping (with the reasoning) for approval.** Models shift
  over time; changing the policy later is editing one frontmatter line, and re-running bootstrap
  never overwrites an approved policy.
  **Registration caveat — say this at handoff:** agent definitions are read at *session start*.
  Agents created or renamed in the current session are invisible to it — the user must restart the
  session (in a wrapper app: its restart/continue affordance; in a terminal: `claude --continue`)
  before `implement-story` can dispatch them.
- `docs/ledger.md` and `docs/debt.md` — the **work ledger** and **debt registry**, empty from
  their templates (the skills maintain them: ledger rows per STORY/BUG/REF, debt entries at the
  affirmative close gates).
- `docs/slice-plan.md` — Slice 0 proposed as **the walking skeleton**: the app the customer can
  already open, however blank, plus the levers proven (built/wired through stories, including any
  runner affordances the host environment provides). Sketch Slice 1 from the design's highest-value
  thread. This is the plugin's standing proposal; the human approves the plan.
- `CLAUDE.md` — point at the contract: the authority docs, the levers, the lifecycle skills, and
  the project's chosen sensibility (so later sessions know the taste the design was cut to).

### 5 — 🛑 Handoff
Present the contract in one screen: the five docs, the manifest, the proposed Slice 0. Then route:
**"Contract ready — run `write-stories` for Slice 0."** Bootstrap is done. It does not write the
stories, does not scaffold the skeleton, does not run the levers.

## Guardrails — what this skill never does

- **Never proceeds on brownfield** — it stops and names what it found.
- **Never scaffolds code** — the walking skeleton is Slice 0's job, through the discipline.
- **Never uses a persona outside phase 3**, and never frames one as "you are X."
- **Never lets a sensibility negotiate the invariants** — story-driven, test-driven, always.
- **Never overwrites an approved artifact** — re-runs resume; they don't restart.
- **Never skips a checkpoint** — every artifact is human-approved before the next phase.
- **Never comprehensive-seeds the guardrails** — the catalog starts as a floor, not an
  encyclopedia; the candidates gate is the growth mechanism.
