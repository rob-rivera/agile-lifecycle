# <Project> — Technical Design

> Architecture and build rules the stories respect. Drafted at bootstrap **under the project's
> chosen design sensibility** (see `bootstrap-project`); evolves only through the
> design-contradiction gate (`story-format.md` §7) — settled decision → update section + Change Log.

*(Template note: the skills cite this doc's **test-layers section** by role — keep that section
present whatever else changes.)*

## 1. Overview & goals

<!-- What this system is; the two or three qualities the architecture optimizes for (from the
sensibility conversation); explicit non-goals. -->

## 2. Architecture — layers & boundaries

<!-- The layers/modules, what each owns, and the dependency rules between them. Name the
boundaries a cycle must respect. Keep it as thin as the sensibility allows. -->

## 3. Contracts

<!-- The load-bearing interfaces/types/schemas. New contracts are the heaviest sizing axis
(story-format.md §3) — name the existing ones so stories can count against them. -->

## 4. Determinism & state policy

<!-- What the project promises about reproducibility: seeded RNG, injected clock, isolation of
side effects. fix-bug's cheap-reproduction guarantee depends on what's declared here. -->

## 5. Design laws (`LAW-*` registry)

<!-- Numbered, citable invariants (LAW-<AREA>-<NAME>). Acceptance criteria and tests cite these.
Laws move only through the design-contradiction gate. -->

## 6. Test layers

<!-- REQUIRED SECTION — skills cite it. The project's test taxonomy and when each applies, e.g.:
- property tests — recurring truths over generated inputs
- example/regression tests — specific behaviors and specific past defects
- end-to-end/thread tests — whole-flow proof through the real artifact
Name the tools that implement each layer in this stack. -->

## 7. Toolchain & levers

<!-- The stack (languages, frameworks, build). The levers — the project's test and lint commands —
are recorded machine-readably in `levers.json` at the repo root; this section explains them.
Optional: thin `scripts/test.sh` / `scripts/lint.sh` wrappers for CLI convenience. -->

## Change Log

<!-- Dated entries, one-line rationale each. -->
