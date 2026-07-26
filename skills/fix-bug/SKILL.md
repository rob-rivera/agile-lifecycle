---
name: fix-bug
description: >-
  Turn a report of unexpected behavior into a root-caused verdict and, when it is a genuine bug, a
  TDD fix guarded by a reproducing regression test. Reproduces the symptom, root-causes it, and renders
  a verdict — working-as-designed routes to write-stories (with approval); a genuine bug is fixed
  Red→Green→Refactor with a failing-first reproduction and verified end-to-end, or, when the fix is
  deferred, documented as a BUG-nnnn record so it can be addressed later. Use when someone reports the
  app doing something it shouldn't.
---

# Fix Bug

Convert a **report of unexpected behavior** into either a **root-caused verdict** or a **TDD-disciplined
fix**. A bug is not a feature request: it documents behavior that surprised someone. This skill's job is
first to find out *why* the behavior happens; then, if it's genuinely wrong, to fix it the same way a
story is built — so **the defect cannot return the same way** — or, when the fix must wait, to file a
durable record so the diagnosis isn't lost. That fix clause is the whole point: TDD's strength here isn't
anticipating every failure, it's that once a failure is witnessed, a reproducing test stands guard over it
forever.

Sits beside the three build skills, not inside them: `write-stories` → `plan-cycles` → `implement-story`
build *designed* behavior forward; `fix-bug` diagnoses *observed* behavior backward — and hands off to
`write-stories` when the report turns out to be a request for behavior that was never designed, or to
`refactor-pass` when nothing is observably wrong and the reporter wants cleaner structure (entropy is
not a symptom).

**Resource and performance symptoms are bugs.** Excess memory, latency, throughput collapse — a
measurable symptom takes this path, not a refactor pass: **a measurement is a reproduction**, and the
fix keeps a real Red (a failing measurement gate).

## Authority (read first)

- `docs/guardrails.md` — the project's durable test/code/smell catalog the reproducing test
  **references** (never embeds); its **candidate loop** captures the failure mode the bug exposed.
- `story-format.md` §5 (the close gate + candidates affirmation) and §7 (the **design-contradiction
  gate** — a "working as designed" report the user wants changed may contradict the design, and must
  route through `write-stories`, not be quietly "fixed").
- `docs/tech-design.md` — its test-layers section, and the boundaries a fix must respect.
- The project's **run/verify skills**, if it has them — for exercising the real flow end-to-end
  (step 5); otherwise the equivalent manual launch.

Load only the report plus the surface it implicates — never the whole codebase.

## Core model

- **A bug report is a claim, not a spec.** It says "X happened, I expected Y." The claim may be right
  (a real defect), or it may be that the code does exactly what it was built to do and the reporter
  wanted something else. **Root-cause analysis renders the verdict — you do not assume "bug" and start
  patching.**
- **Two decisions, not one — a run ends in one of three outcomes.** First the **verdict** (*is it a
  bug?*); then, for a genuine bug, the **disposition** (*fix now or defer?*). So a run produces exactly
  one of: **a fix landed** (genuine bug, fixed now), **a `BUG-nnnn` record filed** (genuine bug, fix
  deferred — reproduction + root cause preserved for later), or **a story routed** to `write-stories`
  (working as designed, a change is wanted). Deferring is a *scheduling* call, never a downgrade of the
  verdict — a deferred bug is still a bug, with a standing reproduction.
- **The reproducing test is the deliverable's spine.** No bug is "fixed" without a test that **failed
  because of the bug first** (witnessed red on the real defect). A fix landed without a failing-first
  reproduction is a hope, not a fix — and it will regress. This is canonical TDD applied to defects
  (the guardrails doc's rule: a specific past defect → an example/regression test).
- **Minimal green, same as a story.** The fix implements only what the reproduction demands. A bug is
  not license to smuggle in a refactor or a feature — that ships untested behavior and muddies what
  actually fixed the defect.
- **Diagnosis is the hard part, not the patch.** The two phases the build pipeline lacks — *reproduce*
  and *root-cause* — are where a fix-bug goes right or wrong. Test-driving a fix for a symptom you
  haven't localized papers over the cause and leaves the real defect live. Which is why diagnosis
  gets the model policy's strongest sub-agent role (**`diagnostician`**) *and* why the orchestrator
  still verifies its output — see steps 1–2.
- **Usually one cycle.** Most bugs are a single Red→Green→Refactor. The orchestrator MAY run a small,
  single-layer fix inline (validation stays mechanical — levers it doesn't control); a fix touching real
  logic or spanning layers gets a fresh implementer sub-agent (implementer ≠ verifier), like
  `implement-story` — the project's `implementer` agent, with the same one-shot `implementer-heavy`
  escalation after bounded retries. If a "fix" balloons past ~3 cycles or keeps growing scope, **stop — it's probably a
  story wearing a bug's clothes.**

## Setup (once per bug)

Assign a stable **`BUG-nnnn` id** (parallel to `STORY-*` / `LAW-*`) — cited by its regression test and
its commit — and add its `docs/ledger.md` row (*open*). Work on a **`fix/<slug>` branch** off `main`
(never commit the fix to `main`; merge on close). The per-step commit + merge is the durable record.

## Procedure

**Steps 1–2 are delegated by default.** Dispatch the project's **`diagnostician` agent**
(`.claude/agents/diagnostician.md`, model per the project's policy; if absent, a general-purpose
sub-agent inheriting the session model) with the report and the implicated surface. It returns a
compact RCA report: reproduction, cause (`file:line` + mechanism), verdict recommendation,
suggested Red, blast radius. Diagnosis is read-heavy — delegating keeps the orchestrator lean
(it retains the report, not the excavation). **The orchestrator MAY diagnose inline** when the
symptom is trivially localized (tiny codebase, symptom names the file); calibrate like
implement-story's gate cycles.

**Then verify the diagnosis — mechanically, before any verdict.** Re-run the returned reproduction
yourself (witnessed, not trusted) and spot-read the cited cause. A verdict presented to the human
stands on the orchestrator's confirmation, never on the sub-agent's word alone.

### 1 — Reproduce
Turn the report into a **deterministic reproduction**: the exact inputs/state and the observed-vs-expected
behavior. Where the project builds in determinism (seeded RNG, no ambient clock), a repro is usually
cheap — same seed + same inputs; where it doesn't, pin the conditions as tightly as the project allows.
**If you cannot reproduce it, stop and gather more** — a bug you can't reproduce, you can't test-guard.
State the reproduction concretely before touching code.

**Resource/performance symptoms reproduce as measurements**: a fixed scenario (inputs, seed, scale) +
the measured value (peak memory, wall time, allocation count) vs. an acceptable bound. **The bound is
intent** — often nothing recorded says "must stay under X," so classifying the measurement as a bug
*ratifies a threshold*: state it explicitly at the verdict, record it (a natural `LAW-PERF-*` /
`LAW-MEM-*`), and the reproduction asserts against it.

### 2 — Localize & root-cause
Find the **defect, not the symptom**. Read the implicated code, form a hypothesis for *why* the observed
behavior happens, and confirm it against the code. Name the exact cause (file:line + mechanism) and how it
differs from intent. Distinguish where the symptom *shows* from why it *happens* — they're often different
layers.

### 3 — 🛑 Verdict, then disposition (the gate)
RCA renders a **verdict** — **stop for the classification** — and a genuine bug then takes a
**disposition**:
- **Working as designed** — the code does what it was built to do; the report wants *new or changed*
  behavior. Present the finding plainly (cite the story/design that specified the current behavior).
  **Do not fix.** With the user's approval, **route to `write-stories`** — it's a change request, and may
  trip the §7 design-contradiction gate.
- **Working as implemented, intent unrecorded** *(excavated projects)* — the governing behavior is
  only `observed`, never ratified: nobody ever said whether X is design or accident. Present the
  observed behavior and the report side by side; **the user's classification is also a
  ratification** — record it (ratify the behavior, or confirm the defect) so the next verdict on
  this ground stands on a settled rule.
- **On the line** — present both readings with a recommendation; **the user classifies**, then it takes
  the matching path. (Reference rep: an existing quit capability made unreachable by a new input mode —
  recommended *bug*, because "the user can always exit the app" is an invariant no design waives.)
- **Genuine bug** — behavior violates intent: a broken contract, a violated invariant, a regressed
  capability (an existing, tested behavior made unreachable by a new state), or a crash. Then decide the
  **disposition** — usually the human's call:
  - **Fix now** → **step 4.**
  - **Defer** (blocked on a dependency, out of the current slice's scope, needs a design decision,
    lower-priority than the work in flight) → **document it as a `BUG-nnnn` record** (below) so the
    reproduction and root cause aren't lost, then stop. It is picked up by a later `fix-bug` run.

### 3a — Deferred bug — the record
A deferred genuine bug becomes a durable **`docs/bugs/BUG-nnnn-<slug>.md`**, documented like a story so it
can be addressed cold — capture it **while the diagnosis is hot**:
- **Report** — observed vs. expected, and who hit it.
- **Reproduction** — the exact inputs/state (deterministic — seed + intents where available). The
  expensive knowledge; losing it means re-diagnosing from scratch later.
- **Root cause** — file:line + mechanism (already found in step 2), and the verdict reasoning.
- **Defer rationale** — *why* not now, and any unblock condition (the dependency, the slice, the design
  decision it waits on).
- **Definition of done** — the reproducing test that must go **red-then-green** when it's fixed (the
  future step-4 Red, described).

Status stays **Open (deferred)** — mirror it in `docs/ledger.md` — until a later `fix-bug` run
**resumes at step 4 (the Red)** off the documented reproduction. *Optional:* commit the reproduction now as an ignored/skipped test citing the
`BUG-nnnn` — an executable repro that flips to the standing guard when the fix lands; weigh it against
ignored-test rot (the record is the required artifact, the ignored test is a *may*).

### 4 — Fix (TDD — the same discipline as a story cycle)
- **Red — the reproducing test**, at the **innermost layer that would have caught it** (prefer a pure
  decision/unit test over a full end-to-end harness where the logic allows). It asserts the **correct**
  behavior and therefore **fails because of the bug** — a witnessed red on the real defect. Name it
  `bug_*` / cite the `BUG-nnnn`. Choose the layer by tool (the project's test-layers doc): a recurring
  truth → a property test; this specific defect → an example/regression test. **For a
  resource/performance defect, the Red is a failing measurement gate** (benchmark or resource
  assertion against the ratified bound) — witnessed like any other red.
- **Green — minimal.** Only what makes the Red pass; smuggle no feature or refactor. A structural fix
  (streaming instead of buffering, extracting the hot path) may *deploy* refactoring moves — still
  bounded by the failing measurement: only what makes it pass.
- **Refactor** — clean by reference to `guardrails.md`; extract a pure decision if the fix left
  logic inline and testability wants it.

### 5 — Verify the original symptom is gone (end-to-end)
Re-exercise the **reported flow in the real artifact** (the project's run/verify skills, or the
equivalent manual launch), not just the green test — a green unit test that doesn't kill the observed
symptom means the fix is mis-localized. **Rebuild first**: a stale build artifact lies (reference rep: a
pre-fix binary "reproduced" a symptom already fixed in source — burned a verification cycle). For an
interactive app, a pty/scripted-input harness that asserts the corrected behavior (e.g. clean exit vs.
hang) is the honest check.

### 6 — 🛑 Independently validate, then capture
Run the gates the fix's author doesn't control — the project's levers (the `test` and `lint`
commands in `levers.json`; test lever runs the full suite) — and read the diff for scope (fixes the
reproduced defect, nothing more). Then:
- **Commit** — message cites the `BUG-nnnn`, the RCA verdict, the fix, and the end-to-end verification;
  the project's required trailer, if any.
- **Candidate gate** — a bug is *evidence of a real failure mode*, so it very often earns a
  `guardrails.md` candidate (the *class* the defect belongs to). Record it, or affirm
  "candidates: none."
- **Debt observations** — out-of-scope mess seen along the way lands in `docs/debt.md`, or affirm
  "debt: none."
- **Design-doc update** — if the RCA exposed a requirement gap (behavior nobody specified), note it where
  requirements live (the domain design doc / slice plan), or open the follow-up story.
- **Merge** the `fix/<slug>` branch on close; mark the ledger row *fixed*.

## Guardrails — what this skill never does

- **Never patches before reproducing + root-causing** — diagnosis is the deliverable's spine.
- **Never fixes without a failing-first reproducing test** — that regression guarantee is the entire
  reason to use TDD on a bug.
- **Never "fixes" working-as-designed behavior** — it presents the verdict and, with approval, routes to
  `write-stories` (respecting the §7 design-contradiction gate).
- **Never lets a deferred genuine bug evaporate** — a fix put off is captured as a `BUG-nnnn` record
  (reproduction + root cause preserved), never left in a chat log to be re-diagnosed later.
- **Never downgrades the verdict to justify deferring** — "we won't fix it now" is a scheduling call, not
  a reclassification to working-as-designed. A deferred bug is still on the books as a bug.
- **Never exceeds the reproduced defect** — minimal green; no smuggled feature or refactor.
- **Never trusts a green unit test as end-to-end proof** — it re-exercises the real symptom against a
  freshly built artifact.
- **Never skips the candidate gate**, and never commits the fix to `main`.
- **Never grinds a ballooning fix** — a defect that won't close in a cycle or two is a signal the verdict
  was wrong (it's a story), not something to force.
