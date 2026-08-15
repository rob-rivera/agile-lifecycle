# <Project> — Story Format & Sizing

> **Working standard (v1).** How stories are written for this project. A story is a
> **context-management unit**: a slice of business value scoped so a single agent can execute it
> holding only the part of the design it touches — not the whole system. Governed by
> `slice-plan.md` (where stories come from) and `tech-design.md` (the rules they respect).

*(Template note: this doc ships with the `agile-lifecycle` plugin. Copy it to
`docs/story-format.md`, replace the placeholders, and adjust names to your project — the plugin's
skills read it live and cite its section numbers, so keep the §-structure intact.)*

---

## Hierarchy — where a story sits

- **Slice** — a vertical thread of value across the architecture (roadmap unit; `slice-plan.md`).
- **Story** — *this document.* One bit of value within a slice, **sized to one agent's context**.
  A slice contains one or more stories; a small slice may be a single story.
- **Cycle** — one **Red → Green → Refactor** loop within a story's implementation plan.

A story decomposes into cycles. The cycle count is the primary sizing signal (see §3).

---

## Story origins

A story does **not** require a slice. Its origin may be:
- **a slice** (`slice-plan.md`) — the planned-roadmap source;
- **a freeform change prompt** — a direct ask outside the roadmap;
- **test-cycle feedback** — a failure, gap, or defect surfaced during Red → Green → Refactor.

A slice *may* be the source, but is never a prerequisite. **Record the origin** in the story's notes
for traceability, and let it drive what design surface to load (§6): a slice's context, a prompt's
target area, or a failing test and the code and `LAW-*` beneath it.

---

## 1. The format

Every story has three load-bearing sections, plus optional notes.

### Summary — the business value
```
As a <role>, I want <capability>, so that <outcome>.
```
One value, one outcome. **The "and" test:** if the outcome needs "and" to be stated
(`…so that X and Y`), it is probably two stories — split it.

### Acceptance criteria — Given / When / Then
```
Given <context>, When <action>, Then <observable result>.
```
- Each scenario is **independently verifiable** — it passes or fails on its own, not only as part
  of a bundle. Interdependent criteria that only make sense together are a sign the story is a
  bundle in disguise (see §3).
- Each scenario **maps to tests** and cites the IDs it satisfies: its own `AC-<slice>.<n>` (from
  the slice plan) and any `LAW-*` design-law IDs from `tech-design.md`.
- Criteria describe **observable behavior**, not implementation.

### INVEST — reinterpreted for agents
INVEST still applies, but three letters mean something different when the executor is an agent, not
a human developer:

| Letter | Agent meaning |
| --- | --- |
| **I**ndependent | Even more important — independent stories can be delegated in parallel and don't share hidden state. |
| **N**egotiable | **Inverts.** Ambiguity is the enemy; an agent story should be *more pinned, less* negotiable. Wiggle room is a defect, not a feature. |
| **V**aluable | Delivers a real slice of value (the summary's outcome). Unchanged. |
| **E**stimable | For an agent, "estimable" = **you can enumerate its RGR cycles.** If you can't list the cycles, it isn't ready. |
| **S**mall | **Reframed as bounded *coherence load*, not magnitude — see §2–3.** This is the axis models get wrong. |
| **T**estable | The load-bearing letter: testability is also the sizing instrument (§3). |

**E, S, and T collapse into one act:** enumerating the failing tests proves the story is
understood (T), yields the estimate (E = cycle count), and reveals the size (S = the count). Size
is *read off a countable artifact*, not judged.

### Background / Notes (optional)
Context the agent needs and nothing more. **The one-card test:** if the notes must explain more
than one subsystem to make the story executable, the story is too big — decompose (§4).

---

## 2. Sizing: the reframe

Traditional sizing (points, t-shirt, "complexity") proxies **human effort × time**. That is the
wrong quantity for an agent, which does not tire over hours but **gets lost over context.**

> **Human size ≈ effort × time. Agent size ≈ state that must be held *coherent at once*.**

What overwhelms an agent is *simultaneous coherence load*: design + code held in attention
together, independent decisions kept straight, and how much must be true at the same instant for
"done." A story with a dozen interdependent criteria is large even if each is trivial. Size by
coherence load, never by imagined effort.

---

## 3. The sizing check (a vector of counts, not a scalar)

A scalar invites the model to anchor on its human prior. Replace it with **countable signals and
hard triggers.** Fill this in while writing the story; if **any** row trips, the agent
**recommends** a split or spike and **stops for the human to decide** (§4) — it does not decompose
on its own.

- [ ] **RGR cycles ≤ ~5**, and every cycle is listed. *(Can't list them → not ready.)*
- [ ] **≤ 1 new load-bearing contract** designed (interface / type / data schema). *(The heaviest
      single axis — ≥ 2 → decompose.)*
- [ ] **≤ 1 layer's contract changes.** Using an existing contract across layers is fine; *changing*
      contracts in more than one layer is not.
- [ ] **≤ ~2 genuine unknowns.** *(≥ 3 open decisions → split off a spike.)*
- [ ] **Each acceptance criterion is independently verifiable** *(bundle-only criteria → decompose)*.
- [ ] **Required context fits one index card** (the one-card test, §1).

> Thresholds (≤5 cycles, etc.) are **v1 and calibration-pending** — tune them against real agent
> runs. What is *not* negotiable is the method: size by counting structural load, not by judging
> magnitude.

---

## 4. When a trigger trips — recommend, don't execute

**The agent recommends; the human decides.** When a trigger trips, surface a split recommendation —
name the tripped signal, its count, and the proposed cut — and **stop.** Decomposition is a
business-value judgment (what is independently shippable, what sequencing serves the slice) that the
human owns; never split unprompted.

**Split with SPIDR — cohesion is the constraint.** Every split must leave each slice **vertical,
valuable, and independently testable** — never a horizontal technical fragment ("build the parser").
SPIDR is five *lenses*: run the story through them, take the one(s) that yield cohesive slices, and
reject any that would break value. **Name the chosen lens in the recommendation.**

- **S — Spike.** Uncertainty is what makes it big → split off a throwaway investigation that answers
  the open decision(s), leaving N now-estimable stories. Spike genuine research, not a call you can
  just make. *(Executed by the `spike` skill: framed question, declared budget, evidence-cited
  answer, code never merged.)*
- **P — Path.** Split by distinct paths/workflows through the story (one path first, then the rest).
  Reject if a path is worthless alone.
- **I — Interface.** Split by interface / channel / input source (one client, format, or source first).
- **D — Data.** Handle one data subset or kind first, add the rest later; **defer a rule whose data
  does not exist yet.**
- **R — Rules.** Implement a simpler rule set first (highest-value rule first), then layer in the rest.

Prefer a narrow thread through all layers over a fat change to one layer (the walking-skeleton
move); fixtures before generators is a **D** split that unblocks a thread.

---

## 5. Definition of done

A story is done only when **every** item holds — treat it as a gate, not a guideline:
- [ ] Every acceptance criterion is green across the applicable test layers (`tech-design.md`).
- [ ] Each `AC-*` / `LAW-*` id is cited by the test(s) that satisfy it.
- [ ] Both levers pass — the `test` and `lint` commands recorded in `levers.json`.
- [ ] **Guardrail candidates recorded.** Any novel test/code/smell/pattern call not covered by
  `guardrails.md` is appended to its *Candidates* inbox — **or the story explicitly affirms
  "candidates: none."** Silence is not a pass; this is a required gate, not optional capture
  (`guardrails.md`, the candidate loop). Pattern-shaped candidates are **named from the
  literature** (the `references/patterns.md` ladder): canonical name + citation, or a declared
  house name only where no canonical name exists.
- [ ] **Debt observations recorded.** Out-of-scope structural debt seen during the story lands in
  `docs/debt.md` as dated `DEBT-nnnn` entries — **or the story affirms "debt: none."** Same
  affirmative rule: silence is not a pass.
- [ ] **`docs/ledger.md` updated** — story marked *done*; slice marked complete in
  `docs/slice-plan.md` if this story closed it.

Implementation plans (the cycle breakdown) are disposable — burned when the story closes.

**Infrastructure/tooling stories verify via gates, not behavioral tests.** For scaffolding, scripts,
and linters, "green" is a passing build, a script exit code, or a proven linter-bite — the
behavioral test layers only have a subject once the core holds domain rules. For such a story a
"cycle" means *make this gate pass*, and Red→Green is *gate failing → gate passing*.

---

## 6. Process & tooling

- **Story writing is triggered by a skill**, not a workflow — it is a consistency-and-judgment task
  with a mandatory human checkpoint, not a background fan-out. The skill is the repeatable spine that
  keeps every invocation on-format.
- **Human checkpoints** are built into the trigger, in order: (1) the **design-contradiction gate** —
  resolve any conflict with the design before proceeding (§7); (2) confirm the candidate story
  breakdown *before* drafting; (3) act on any split/spike recommendation the sizing check raises
  (§3–§4). The agent authors, flags, and recommends; the human decides scope and precedence.
- **Load only the design surface the story touches** — a story exists to bound context, so the skill
  pulls in just the surface its **origin** implicates (a slice's context, a prompt's target area, or
  a failing test and its governing `LAW-*`), never the whole spec.
- **Workflows are the scale tool, held in reserve** — reach for one only for fan-out jobs (e.g.
  auditing the whole backlog for sizing drift) or, optionally, as a power tool the skill *calls* to
  re-run the sizing check adversarially. Even then, the split decision returns to the human.

---

## 7. Design-contradiction gate

A story request may **contradict a settled rule** in the design — and that can be *intentional*.
Design evolves; this gate exists to make the evolution **explicit and recorded**, never silent. Run
it as an **intake step**, on receiving the request, before breakdown or drafting.

*(Excavated projects: "settled" means `ratified`. Conflict with an `observed` entry is not a
contradiction — it is a ratification prompt, and the human's answer is recorded either way.)*

**Detect.** Compare the ask against the settled rules in the domain design doc (product/system
rules) and `tech-design.md` (architecture/build), distinguishing:
- **Contradiction** — the ask conflicts with a stated rule or `LAW-*`. → triggers the gate.
- **Extension** — the ask fills a gap the design leaves open and does not contradict. → a normal
  story; proceed (note it may warrant a later design addition). Do not cry wolf on every new feature.

**Flag & ask.** On a contradiction, **stop and flag it** — name the specific rule / section / `LAW-*`
and exactly how the ask conflicts — then **ask the user which takes precedence: the design or the
story.**

**Resolve.**
- **Design wins** → the ask was out of bounds. Revise or reject the story to conform. **No design
  doc changes.**
- **Story wins** → this is a **design change**, and it must land in the source of truth *before* the
  story enters the pipeline — no story may silently override the design. Update the appropriate doc
  **declaratively, with a dated Change Log entry and one-line rationale**:
  - domain-rules change → the domain design doc (the relevant section + Change Log). **Never edit a
    doc the project marks frozen** (e.g. a design-history file).
  - architecture/build change → `tech-design.md` (the rule + Change Log). Roadmap/process change →
    `slice-plan.md` or this doc, the same way.

The design stays the single source of truth; contradictions become **governed, recorded design
evolution**, not drift.

---

## 8. Craft anchors

Books cited at the generative drafting moments — **the ladder, quoted, never role-played**. An
anchor governs the *craft of the sentences and tests*; this doc governs format and process, and
**on any conflict, this doc wins** (the canonical case: the corpus says stories are negotiable —
here N inverts, and §1 rules). Anchors are project-owned: confirmed at bootstrap, swapped by
editing this table. No role personas ("advanced product owner") — generic roles produce the
centroid, and named authors imported wholesale bring process opinions this format deliberately
overrides.

| Drafting moment | Anchor (default) | The pressure it applies |
| --- | --- | --- |
| Acceptance criteria (`write-stories` §3) | Gojko Adzic, *Specification by Example* | Concrete examples, observable behavior, no implementation language |
| Story summaries & value (`write-stories` §3) | Jeff Patton, *User Story Mapping* | One real outcome per story; value stated from the user's side |
| Pinning the Red (`plan-cycles` §3) | Kent Beck, *TDD by Example*; Freeman & Pryce, *GOOS* | The smallest test that can fail for the right reason; test names that read as the spec |
| Naming refactor destinations (Refactor steps; the §5 candidates gate) | Joshua Kerievsky, *Refactoring to Patterns* | Patterns are destinations refactoring arrives at, never design starting points; canonical names from the literature over coinage |

---

## Change Log

- **v1 — Imported from the originating project via the `agile-lifecycle` plugin.** Three-section
  story format (As-a/I-want/so-that, Given/When/Then, INVEST reinterpreted for agents: **N inverts**,
  **E/S/T collapse** into enumerating RGR cycles). Sizing reframed from human effort×time to **agent
  coherence-load**, measured as a **vector of countable signals + hard triggers** (§3) with SPIDR
  decomposition lenses (§4). Splits are recommended, never executed. Story origins decoupled from
  slices; design-contradiction gate (§7); guardrail-candidate capture as a story-close gate (§5).
