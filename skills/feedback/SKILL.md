---
name: feedback
description: >-
  Submit feedback about the agile-lifecycle plugin itself — a bug in a skill/hook/template,
  friction in the procedure, or an improvement idea — as a GitHub issue on the plugin repo.
  Use when the user's complaint or suggestion is about the lifecycle machinery, not about
  their own project (project bugs go to fix-bug).
---

# Feedback

File plugin feedback where the maintainer will see it: the GitHub issues list of
`rob-rivera/agile-lifecycle`. One invocation, one issue, one 🛑 checkpoint — the issue leaves
the user's machine, so they see exactly what's sent before anything is sent.

## Route check first

- The **project** misbehaved (the app crashed, a test lies, output is wrong) → **`fix-bug`** —
  that is project work, not plugin feedback.
- A **skill, hook, agent, or template** misbehaved, blocked wrongly, or has a gap; the
  procedure fought the user; an idea would improve the contract → **this skill**.
- Unsure which side of the line: ask one question, then route.

## Procedure

### 1 — Gather (conversational, brief)
What happened, where (which skill/hook/doc), expected vs. actual. Classify: **bug** (machinery
misbehaved), **friction** (worked as designed, cost too much), or **idea** (new capability).
For bugs, get the smallest reproduction the user can describe.

### 2 — Collect context (mechanical, no judgment)
- Plugin version: `.claude-plugin/plugin.json` in the plugin dir, or the project's
  `docs/.contract-version` stamp.
- Claude Code version (`claude --version`), OS, and install channel (marketplace /
  `--plugin-dir` / bundled in a wrapper app) if determinable.
- **Never auto-include project content** — no file contents, paths, project names, or ledger
  entries. The tracker may be public; the project is the user's. Project details enter the
  issue only if the user explicitly puts them there.

### 3 — Compose
Title: `[bug|friction|idea] <one-line summary>`. Body mirrors the repo's issue-form fields:
version + environment, where it happened, what happened, what was expected (bugs) or what it
cost / what it would enable (friction/ideas).

### 4 — 🛑 Checkpoint: show the exact issue
Present the complete title and body verbatim and stop for approval. This is the privacy gate
as much as the quality gate — the user must see everything that leaves the machine.

### 5 — Submit, with a graceful fallback
`gh issue create --repo rob-rivera/agile-lifecycle --title "..." --body "..." --label <class>`
(labels: `bug`, `friction`, `idea`). If `gh` is missing, unauthenticated, or lacks access,
**do not fail**: print the composed issue for copy-paste and point at
`https://github.com/rob-rivera/agile-lifecycle/issues/new/choose`. Report the issue URL (or
the fallback) and stop.

## Guardrails — what this skill never does

- **Never submits without the checkpoint** — the user sees the exact payload first, every time.
- **Never includes project content unconsented** — context is version/environment, not the
  user's code or docs.
- **Never files project bugs upstream** — the route check is the first act.
- **Never files more than one issue per invocation** — a second complaint is a second run.
- **Never edits the project** — this skill only reads context and talks to GitHub.
