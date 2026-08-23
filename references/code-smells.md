# The Smell Catalog — canonical, language-neutral

The ladder we use to get up on the shoulders of giants. Sources:

- **Code smells** — Martin Fowler, *Refactoring: Improving the Design of Existing Code* (2nd ed.,
  2018), ch. 3 "Bad Smells in Code," written with **Kent Beck**.
- **Test smells** — Gerard Meszaros, *xUnit Test Patterns* (2007); Kent Beck, *Test-Driven
  Development: By Example* (2002).

This file is **plugin knowledge, not a project artifact**. At bootstrap, `bootstrap-project` selects
the smells relevant to the project's stack and **expresses each in the stack's idiom** (a concrete
example + the idiomatic cure) into the project's `docs/guardrails.md`. Selection is a judgment step,
not a translation step — some smells invert or vanish per language (see notes). A smell is a smell
whether it lives in `src/` or `tests/` — one catalog, one candidates gate.

## Code smells (Fowler & Beck)

| Smell | The tell | Typical cure |
| --- | --- | --- |
| Mysterious Name | A name that needs the body read to be understood | Rename ruthlessly |
| Duplicated Code | Same shape in ≥2 places; fixes must be repeated | Extract function / pull up |
| Long Function | Scrolling to understand one behavior | Extract function; decompose by intent |
| Long Parameter List | Callers marshal a parade of arguments | Introduce parameter object; preserve whole object |
| Global Data | Anything mutable reachable from anywhere | Encapsulate; pass explicitly |
| Mutable Data | Shared state changed from multiple sites | Immutability; copy-on-write; narrow ownership |
| Divergent Change | One module edited for many unrelated reasons | Split by reason-to-change |
| Shotgun Surgery | One reason-to-change edits many modules | Consolidate; move behavior together |
| Feature Envy | A function that mostly reads another module's data | Move function to the data |
| Data Clumps | The same field-trio traveling together | Extract a type; name the concept |
| Primitive Obsession | Domain concepts as bare strings/ints | Introduce domain types (newtype/value object) |
| Repeated Switches | The same case-analysis duplicated across sites | Polymorphism / single dispatch point |
| Loops | Index-juggling where intent is a transformation | Pipeline (map/filter/fold) |
| Lazy Element | A structure that no longer earns its keep | Inline it |
| Speculative Generality | Hooks for a future that never came | Remove; YAGNI |
| Temporary Field | Fields meaningful only sometimes | Extract the state that needs them |
| Message Chains | `a.b().c().d()` — navigation coupled to structure | Hide delegate; ask, don't navigate |
| Middle Man | A type that only forwards | Remove; talk to the real thing |
| Insider Trading | Modules whispering through back channels | Make the interface explicit |
| Large Class | One type, many responsibilities | Extract class/module |
| Alternative Classes with Different Interfaces | Same job, different signatures | Unify the interface |
| Data Class | Fields with no behavior; logic lives elsewhere | Move behavior to the data |
| Refused Bequest | Inheriting an interface only to ignore it | Replace inheritance with delegation |
| Comments (as deodorant) | Prose explaining code that could explain itself | Refactor until the comment is redundant |

## Test smells (Meszaros; Beck)

| Smell | The tell | Typical cure |
| --- | --- | --- |
| Assertion Roulette | Many unlabeled asserts; a failure doesn't say what broke | One behavior per test; name asserts |
| Eager Test | One test verifying several behaviors | Split by behavior |
| Mystery Guest | Test depends on unseen external state (file, fixture, env) | Inline the setup; make inputs visible |
| Conditional Test Logic | `if`/loops inside a test | Straight-line tests; table/property tests for variation |
| Fragile Test | Breaks on refactors that don't change behavior | Assert on behavior/contract, not structure |
| Erratic Test | Passes/fails nondeterministically | Seed randomness; fake clocks; isolate shared state |
| Slow Test | Suite too slow to run on every cycle | Push logic tests inward; reserve E2E for threads |
| Test Logic in Production | Code branches on "am I under test" | Inject dependencies; seams, not flags |
| Overspecified Test (over-mocking) | Mocks assert every internal call | Mock roles at boundaries, not internals; prefer state verification |
| Obscure Test | Setup noise buries what's being asserted | Extract builders/helpers; arrange-act-assert visible |
| General Fixture | One giant shared fixture for all tests | Minimal fixture per test |

## Complexity smells

**Universal — seed these like any other code smell, gated on nothing.** A single-player game's
frame loop cares about an accidental quadratic exactly as much as a server does; declining the
resource-budgets question never declines these. What makes them a family is *where they hide*:
each is invisible at development scale (complexity errors are data-shape errors — n=200 conceals
what n=50k exposes), so their cures lean on realistic-scale data even where no budget exists.

| Smell | The tell | Typical cure |
| --- | --- | --- |
| Accidental Quadratic | Nested iteration over the same collection; sort/lookup inside a loop | Hoist the sort; precompute an index/set; use the library's n·log n |
| Expensive Call in a Loop (N+1) | One query / IO / spawn per element of a collection | Batch, join, prefetch, or hoist |
| Load-Whole-Then-Filter | Reading a full file/table into memory to use a slice | Stream, paginate, push the predicate down |
| Unbounded Growth | Cache, buffer, or memo with no cap or eviction | Bound it (LRU/TTL/high-water mark); make growth observable |
| Chatty Serialization | The same payload encoded/decoded repeatedly across a boundary | Serialize once at the edge |
| Dev-Shaped Data | Fixtures orders of magnitude below realistic n | Realistic-scale fixtures; scale-proportional synthetic data in CI |

## Resource-budget smells

**Conditional — these exist only where the project declared production resource budgets** (the
bootstrap budgets question). A project that recorded "Resource budgets: none declared" skips
them along with the rest of the budget machinery (`bench` lever, §5 budgeted-surfaces gate) —
but still seeds the complexity smells above.

| Smell | The tell | Typical cure |
| --- | --- | --- |
| Dev-Shaped Environment | Local containers with unlimited memory while prod is capped | Run dev with prod's limits — dev should die the way prod dies |
| Unwitnessed Budget | "Optimized"/"fast enough" as prose, with no executable gate | Ratify the number as a resource `LAW-*`; enforce it via the `bench` lever |

## Legacy-safety patterns (Feathers, *Working Effectively with Legacy Code*)

Seeded into `guardrails.md` §2 (Patterns) by `bootstrap-legacy` — the moves that make changing
untested code safe:

| Pattern | When | The move |
| --- | --- | --- |
| Characterization test | Before changing behavior nobody can vouch for | Pin what the code *does now* (not what it should do); then change with the net up |
| Seam | Logic tangled with dependencies you can't have in a test | Find/create the point where behavior can be swapped without editing the code under test |
| Sprout method/class | Adding behavior to a function you dare not touch | Write the new behavior in a new, tested unit; call it from the old code with a one-line change |
| Wrap method | Behavior must happen before/after untouchable code | New tested wrapper calls the old code; callers move to the wrapper |
| Scratch refactoring | You can't understand the code well enough to test it | Refactor freely to learn it — then *throw the refactor away* and make the real change tested |

## Per-language expression notes (selection guidance, not rules)

- **Repeated Switches** — in languages with exhaustive matching (Rust, ML-family), a single
  exhaustive `match` is the *cure*; the smell is the same match repeated across modules.
- **Refused Bequest** — barely exists without implementation inheritance (Rust, Go); skip it there.
- **Loops** — expresses as iterator pipelines (Rust), comprehensions (Python), array methods (JS/TS).
- **Primitive Obsession** — newtypes (Rust), branded types (TS), value objects (OO languages).
- **Mutable Data / Global Data** — largely enforced by the borrow checker in Rust; keep only the
  interior-mutability and `static mut`-adjacent cases.
- **Comments** — doc comments on public API are not the smell; the smell is narration of *how*.
