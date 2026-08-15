# The Pattern Catalog — canonical, language-neutral

The other half of the ladder: smells name what to move away from; patterns name what to move
toward. Sources:

- **Design patterns** — Gamma, Helm, Johnson, Vlissides (GoF), *Design Patterns* (1994).
- **Refactoring to them** — Joshua Kerievsky, *Refactoring to Patterns* (2004); Martin Fowler,
  *Refactoring* (2nd ed., 2018).
- **Enterprise/domain patterns** — Martin Fowler, *Patterns of Enterprise Application
  Architecture* (2002); Eric Evans, *Domain-Driven Design* (2003).
- **Architecture patterns** — Buschmann et al., *POSA vol. 1* (1996); Alistair Cockburn,
  "Hexagonal Architecture" (2005).
- **Test patterns** — already seeded: Meszaros's cures in the smell catalog *are* his patterns.

This file is **plugin knowledge, not a project artifact**. At bootstrap the patterns section of
`docs/guardrails.md` is seeded **thin** (a few entries the stack will visibly need, selection
approved); the catalog grows through the candidates gate as the code earns entries.

## The iron rule — destinations, not starting points

**A pattern is where a refactor arrives, never where a design begins** (Kerievsky's thesis).
Stories pin behavior; Green is minimal; the pattern gets named at the **Refactor** step — when
the third duplication or the growing conditional makes the shape visible — or at story close
when a candidate is captured. A story or Red that prescribes a pattern has pre-written the
Green in prose. The industry name for patterns-first design is over-design; this catalog does
not change that.

## The naming discipline — canonical first, coinage declared

When a candidate is promoted into a project's patterns section:

1. **Match the literature first.** If the shape has a canonical name, use it and cite the
   source. A canonical name is maximum-compression steering: one word loads the whole pattern —
   intent, tradeoffs, variants — into any reader, human or agent. A house name carries zero
   prior.
2. **Half-fit names are worse than none.** "Observer" applied to something that isn't one
   imports wrong expectations. If the canonical name doesn't genuinely fit, don't force it.
3. **House names are permitted only when the literature has no name — and the entry says so.**
   The declaration doubles as a revisit signal: "no canonical name" sometimes means "not found
   yet."

## Architecture patterns (named in `tech-design.md`, chosen at bootstrap)

| Pattern | The problem it answers | Source |
| --- | --- | --- |
| Layers | Isolate policy from mechanism; dependencies point one way | POSA |
| Ports & Adapters (Hexagonal) | Domain logic testable without its I/O; swap edges freely | Cockburn |
| Pipes & Filters | A processing chain whose stages compose and reorder | POSA |
| Event / Publish–Subscribe | Producers must not know consumers | POSA |
| Repository | Domain code asks for objects, not queries | Fowler EAA |
| Model–View–X (MVC/MVU/…) | Rendering, state, and intent change at different rates | Fowler EAA |

## Design patterns (the GoF core that earns its keep)

| Pattern | The problem it answers | Typical refactor that arrives here |
| --- | --- | --- |
| Strategy | The same decision re-made by switch/if across sites | Replace Conditional with Strategy |
| State | Behavior that changes with a lifecycle phase; flags breeding | Replace State-Altering Conditionals with State |
| Observer | Something must react without the subject knowing to whom | Extract the notification seam |
| Adapter | A needed interface and an owned interface disagree | Wrap, don't fork |
| Facade | Callers marshal a subsystem's internals in the same order everywhere | Extract the one entry point |
| Decorator | Optional behavior stacking multiplies subclasses/flags | Move Embellishment to Decorator |
| Composite | Trees where leaves and groups should answer the same calls | Unify leaf/group interface |
| Factory Method / Builder | Construction logic outgrowing constructors; telescoping args | Encapsulate construction |
| Command | An action that must be queued, undone, logged, or replayed | Reify the action |
| Null Object / Special Case | The same nil-check repeated at every call site | Introduce Special Case (Fowler) |
| Value Object | Domain quantities as bare primitives, compared by the wrong identity | Cure for Primitive Obsession |

## Paradigm notes (selection is judgment, as with smells)

- **First-class functions dissolve patterns.** Strategy, Command, and Template Method largely
  collapse into "pass a function" (Norvig's observation, 1998: most GoF patterns are invisible
  or simpler under dynamic/functional languages). Seed the *problem* names only where the stack
  would otherwise re-derive the shape; don't seed class diagrams into a functional codebase.
- **Iterator is a language feature** everywhere that matters now. Don't seed it.
- **Singleton is Global Data wearing a costume** — it lives in the smell catalog, not here.
- **Ownership languages (Rust)** express many patterns as types: RAII/scope-bound resource,
  typestate for State, newtype for Value Object. Name the canonical pattern; show the type-level
  idiom as the stack's expression of it.
- **Concurrency shapes** (actor, message-passing over shared state, guarded/monitor state) are
  patterns too — seed from the stack's idiom when the project is concurrent, citing POSA2 or
  the language's own canon.
