# Decision: the lever runner (v0.24.0)

**Date:** 2026-09-05 · **Status:** shipped, under observation · **PR:** #10

The record of a design conversation, kept so the next revisit starts from the conclusions
instead of re-deriving them. Sections: the incident, the root cause, every option weighed
(with the argument that won or lost), what shipped, what was deliberately deferred (with the
designs sketched far enough to build), known gaps, and what would reopen each deferral.

## The incident

The `implementer` sub-agent, dispatched per cycle by `implement-story`, was kicking off the full
test suite, **backgrounding** it, and returning a green report to the orchestrator before the run
had finished. Separately observed: closing a cycle on a **layer-scoped** test run (one crate /
package) instead of the full suite.

## Root cause

The Bash tool's default timeout is 120 s. A suite that outruns it gets killed once; the model
learns that `run_in_background` avoids the kill. Once backgrounded there is nothing to wait on:
a sub-agent ends its turn when it emits its report, so the completion notification never
reaches it. The report goes out with an unwitnessed green.

Nothing in the plugin addressed it. The templates said "run both levers before reporting green"
but never said foreground, never mentioned timeouts, and the orchestrator had no rule for
rejecting a report whose green field carried no captured output.

**A timeout is not proof the suite is slow.** Other reasons a lever call never returns, each of
which a longer timeout only delays: watch mode (jest/vitest under a TTY, or a script with the
watch flag), a tool waiting on stdin (first-run prompts, pdb), an integration test that starts a
server and awaits a signal, a stale process from the `run` lever holding a port, a reporter
trying to open a browser. In each the sub-agent's backgrounding is rational and wrong.

## Options weighed

| # | Option | Verdict | Why |
| --- | --- | --- | --- |
| 1 | Raise the timeout (`BASH_DEFAULT_TIMEOUT_MS` / `BASH_MAX_TIMEOUT_MS` in project settings; instruct an explicit `timeout`) | **kept as a knob**, not the fix | Removes the reason to background — but presupposes the suite is healthy and slow. A process that never exits just times out later, and a foreground timeout destroys the evidence (the process is killed; only partial output survives). |
| 2 | PreToolUse hook denying `run_in_background` / `&` for lever commands | rejected | Backgrounding is not the problem; returning before the result is. Keyed on lever commands it also presupposes the backgrounded thing was the lever. A universal deny would block the one legitimate background case (`run`). |
| 3 | Prose rule: "a timeout is a finding, not an obstacle" — diagnose, don't retry unchanged, don't background, report failure with evidence | **kept in spirit**, reframed | Prose alone drifts (the sweep-guard precedent). As first phrased it leaked scope: "fix the invocation" had the implementer editing the lever; the lever is orchestrator/bootstrap property. Reframed as: implementer *reports* `lever-hang` with evidence; orchestrator fixes `levers.json`. |
| 4 | Orchestrator rejection rule: a `green` field without the lever's terminal output + exit code is a failure | **kept**, strengthened | Cheap early rejection, but a pasted summary line looks like a real one. Became the `outcome` field + the verdict gate reading tool results, not prose. |
| 5 | SubagentStop hook scanning the transcript for raw runner output (test-runner summary lines) | superseded | Fragile against runner output formats. Once the plugin owns the verdict format (option 7) the same gate becomes a stable string match. |
| 6 | PostToolUse/PreToolUse pair with a state file to deny an unchanged retry after a timeout | rejected | Two hooks sharing state keyed on a session id whose sub-agent semantics were uncertain. The stop gate catches the same case one turn later. |
| 7 | **Deterministic wrapper** (`scripts/lever`) that runs the lever in the foreground under a watchdog and emits one verdict line; hooks only route to it and gate on it | **shipped** | Polling belongs in a script, not a hook (hooks fire around calls; they cannot sit in a loop). The wrapper makes "hung vs. slow" a mechanical distinction and gives hooks a format the plugin controls. |
| 8 | Implementer runs only related tests; orchestrator runs the full suite and routes regressions back | **deferred** — user chose the safer full-run requirement | Details under *Deferred*. |
| 9 | Tree fingerprint + `scripts/lever --verify` so the orchestrator stops re-running the suite per cycle | **deferred** as over-complicated until observed need | Details under *Deferred*. |

### Hung vs. slow — what can actually be told apart

After a **foreground** timeout nothing can be inspected: the tool killed the process; only the
partial output remains (usually enough for a chatty test runner, but tea leaves). A **live**
process gives reliable tells: is the output still growing; is cumulative CPU time still rising;
process state (stopped-on-tty = waiting on stdin, definitively hung for a background job;
sleeping with flat CPU = blocked on a socket/lock/child); open sockets (a port held by a stale
server); two stack samples (same frames = spin). The only ambiguous case is silent output with
CPU burning — long computation vs. infinite loop — which the wrapper reports as `CAP`
(still working at the ceiling) rather than `HANG` (stopped working). This is why the wrapper
watches **output growth and process-group CPU** and why its two non-pass, non-fail verdicts are
different findings.

## What shipped

- **`templates/scripts/lever`** → seeded as `scripts/lever`. Foreground, own process group,
  stdin from `/dev/null`, output to a log; every 2 s compares log size and process-group CPU.
  `stall` s of neither → `HANG` (kills the group, prints a state dump); `cap` s total → `CAP`;
  else `PASS`/`FAIL` with the exit code. `GAP` for a `null` command. Extra args after `--` make
  a **scoped** run labelled `<name>[scoped]` — evidence for a red or a quick green, never the
  lever. Exit codes 0/1/3/4/5, usage 2. bash 3.2 + Linux; needs `jq`.
- **`hooks/lever-guard.sh`** (PreToolUse Bash; active only where `levers.json` exists). Denies
  the **bare** full-suite `test`/`lint`/`bench` command — exact command segment after splitting
  on `&& || ; |`, whitespace-normalized, redirections dropped — and points at the runner.
  Scoped runs (`cargo test foo::bar`, `-p crate`, one file) pass untouched: a witnessed red
  needs them. Denies a runner call whose Bash `timeout` is below `(cap + 30) s`, stating the
  number; skipped for background runs.
- **`hooks/lever-verdict-gate.sh`** (SubagentStop, matcher `implementer|implementer-heavy`).
  Blocks a return unless the sub-agent's **own transcript**
  (`<project-dir>/<session_id>/subagents/agent-<agent_id>.jsonl`) holds a
  `LEVER <name> VERDICT=PASS` **tool result** for each required lever (`test`, `lint` when
  non-null), latest verdict winning. Prose is not consulted when the transcript exists — a pasted
  verdict line proves nothing. Escape: a report whose `outcome:` is `failed` / `blocked` /
  `lever-hang` / `mis-specified` passes for routing. Fail-open; `stop_hook_active` guarded.
- **Contract.** Implementer templates: run levers through the runner, foreground, timeout above
  the cap; `HANG`/`CAP` is a finding — report `outcome: lever-hang`, never retry unchanged or
  raise the cap; `outcome` is the first report field. `implement-story` step 2 validates through
  the runner; step 4: `lever-hang` never counts against retries and never escalates — fix
  `levers.json` (its own commit), re-dispatch the **same** cycle. `fix-bug` step 6 likewise.
  Bootstraps seed the runner; the upgrader lists it as a missing piece with the implementer
  patch. `levers.json` gains per-lever `stall`/`cap`/`tail`.

**Design principle that decided it:** prose asks, hooks enforce — but each hook has to earn its
complexity. Judgment-free determinism goes in a script; hooks stay thin (route, gate); the
model keeps the only part hooks cannot do (diagnose), and once the shortcuts are closed
diagnosis is in its own interest.

## Deferred (designs sketched so they need not be re-derived)

### Related-tests lever for implementers (option 8)

**Premise accepted:** in a well-constructed codebase a refactor's blast radius is bounded; a
regression far from the diff is evidence of hidden coupling, not noise.

**Blast-radius sources, cheapest first:** naming convention (sibling test files — covers only
the module); the runner's own module graph (`jest --findRelatedTests`, `vitest --changed` /
`related`, pytest `testmon`, Go reverse-import packages, cargo per-crate, `nx`/Bazel `affected`)
— **the recommended seed**; export-surface diff (no exported symbol changed → module's own
tests; a public signature change inside a cycle is arguably not a refactor); recorded
architecture boundaries; per-test coverage maps (most rigorous, rarely worth it).

**Where the premise fails, and should be surfaced:** dynamic dispatch / reflection / string-keyed
registries / DI containers; tests elsewhere that mock the refactored module's internals (a
smell in the *mocking* test); shared fixtures, global state, schema, config; test-order
dependence.

**The contract it would take:** a `test-related` lever whose command takes the diff's files
(`scripts/lever test-related -- <files>`; `null` = gap → implementer falls back to the full
suite); the implementer runs the pinned test + related set + lint and reports which set and how
derived; the verdict gate accepts `test-related` PASS in place of `test` for implementers;
`implement-story` step 2 keeps the full suite; step 4 gains: a regression **inside** the related
set is an ordinary rejection, **outside** it goes back for the fix *and* is recorded — debt if
hidden coupling in code, a guardrails candidate if an over-mocking / order-dependent test; the
orchestrator re-runs a failing test once before dispatching (flakes); the implementer gets a
"not reproducible" verdict. Brownfield (`bootstrap-legacy`) projects keep the full suite until
characterization coverage earns the switch. Costs: refactor loses its full safety net until the
orchestrator's run; a regression is a fresh-dispatch round trip.

**Why deferred:** the user judged requiring the full run before a green return the safer
contract even though the orchestrator repeats it; the runner's `--` args and `[scoped]` label
were built so this is additive.

### Tree fingerprint + `--verify` (option 9)

**Question:** with a deterministic proof that the implementer's full levers passed, must the
orchestrator re-run them every cycle, or only at story close?

**What the gate proves:** the levers ran and their latest verdicts were PASS. **What it does
not:** ordering (an edit *after* the last PASS passes the gate with a stale verdict) and its own
fail-open modes (no `jq`, transcript layout moved, matcher not firing) — the orchestrator's
re-run was the belt behind those braces.

**The design:** at the end of a run the runner fingerprints the working tree (HEAD + diff
against it + contents of untracked files) and records it beside the verdict and on the verdict
line; `scripts/lever --verify <name>` recomputes and prints CURRENT or STALE. Step 2 becomes:
`--verify` both levers (STALE = rejection with a specific reason) → diff read for the judgment
items (scope, red for the right reason, citations, **and no touches to `levers.json`,
`scripts/lever`, or test skip markers**) → commit. The full suite runs where it already lives:
§5 story close, pre-merge, and inline gate cycles. Keep a clause: the orchestrator may run the
full lever on suspicion.

**Why deferred:** judged over-complicated before the shipped design has been observed. It stays
the answer if the per-cycle double run proves expensive (especially a `HANG` landing in the
long-lived orchestrator context).

## Known gaps in what shipped

- **Ordering.** The gate checks the latest verdict, not whether an Edit/Write came after it. A
  cheap tightening exists (block if any Edit/Write tool_use follows the last PASS in the
  transcript); Bash-driven edits would still slip. Option 9 closes it properly.
- **Fail-open.** All hooks exit 0 on any surprise; a silent gate is no gate. The orchestrator's
  per-cycle re-run is the current backstop — which is the argument for keeping it for now.
- **Transcript layout assumption.** Verified on disk on 2026-09-05 (Claude Code stores sub-agent
  transcripts at `<session>/subagents/agent-<id>.jsonl` beside the parent transcript; the hook
  also accepts a `transcript_path` that already names an `agent-*.jsonl`). If it moves, the gate
  falls back to the report text, then fails open.
- **SIGKILL orphans.** The wrapper traps INT/TERM/HUP and kills its group; a SIGKILL from the
  tool leaves the group running. Mitigated by keeping `cap` under the tool timeout (the guard
  enforces the margin).
- **Not yet exercised by a live implementer dispatch** — the gate was tested against crafted
  inputs and a hand-built transcript only.
- **Existing projects** need the implementer patch (via the upgrader) and a Bash timeout above
  the cap (per-call `timeout`, or `BASH_DEFAULT_TIMEOUT_MS` in project settings).

## What would reopen which deferral

- Implementers still closing on stale or partial runs despite the gate → tighten ordering
  (Edit/Write-after-PASS check), then option 9.
- The per-cycle double suite run measurably dominating cycle time, or a `HANG` hitting the
  orchestrator → option 9.
- Full-suite time making the implementer's per-cycle run the bottleneck in a codebase whose
  far-away regressions are rare → option 8.
- The gate blocking or passing wrongly on a real dispatch → check the transcript path
  assumption first (the block reason names which source it read).
