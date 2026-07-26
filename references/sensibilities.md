# Design Sensibilities — the architecture leg's persona roster

A named practitioner is a dense pointer into a coherent region of design judgment — their published
corpus supplies *selection pressure*: what to leave out, what to insist on. A generic "advanced
architect" points at the centroid of all architecture writing, whose answer to every question is
"include it." Empirically (and per the persona-prompting literature): named sensibilities produce
distinct, focused designs; generic ones produce huge documents.

**Rules of use:**

- Applies **only to the architecture leg** of `bootstrap-project` (and other explicitly generative
  design work). Never in mechanical phases — instantiating templates, seeding files, validation.
- Frame as *"channel the published principles and sensibility of X"* — never "you are X."
- **The invariants outrank every sensibility**: story-driven production and test-driven development
  are not negotiable by any persona. A sensibility shapes the architecture's *taste*, not the
  process.
- `bootstrap-project` presents **3–5 options** filtered by project type + stack, **recommends one**,
  and lists the generic architect only as a discouraged fallback (unfocused output, token cost).

## Roster

| Sensibility | Corpus anchor | Optimizes for | Recommend when |
| --- | --- | --- | --- |
| **Kent Beck** | *TDD by Example*, *XP Explained*, *Tidy First?* | Simplicity, small safe steps, evolutionary design, feedback loops | Default for most greenfield product apps; small teams; the suite's home philosophy |
| **Martin Fowler** | *Refactoring*, *Patterns of Enterprise Application Architecture* | Evolutionary architecture, a shared pattern vocabulary, incremental rework | Enterprise-ish domains; workflow/data apps; teams that communicate in patterns. **Also the process sensibility of `refactor-pass`** (fixed for that skill) |
| **Robert C. Martin** | *Clean Architecture*, SOLID corpus | Explicit boundaries, the dependency rule, framework-independence of the core | Long-lived business cores; teams wanting hard layering discipline |
| **Sandi Metz** | *POODR*, *99 Bottles of OOP* | Small objects, message-centric design, affordable change | OO-idiomatic dynamic stacks (Ruby, Python, JS classes) |
| **Rich Hickey** | "Simple Made Easy," Clojure corpus | Data-first design, immutability, decomplecting state/time/identity | Data pipelines, functional stacks, state-heavy simulations |
| **John Ousterhout** | *A Philosophy of Software Design* | Deep modules, small interfaces, minimizing cognitive load | Systems tools, libraries, infrastructure |
| **Freeman & Pryce** | *Growing Object-Oriented Software, Guided by Tests* | Outside-in TDD, walking skeleton, ports at the boundaries | Message/port-heavy services; when the walking skeleton is the whole game |
| **Eric Evans** | *Domain-Driven Design* | Ubiquitous language, bounded contexts, model-rich cores | Genuinely complex domains; multi-context products |
| **Michael Feathers** | *Working Effectively with Legacy Code* | Seams, characterization tests, safety net where you work | **The process sensibility of `bootstrap-legacy`** (fixed for that skill); rarely an evolution choice |
| *Generic advanced architect* | — (the centroid) | Coverage | **Not recommended.** Available on request; expect an unfocused, expensive document |

The roster is a starting point — grow it the way the guardrails catalog grows, when a project's
domain earns a new entry (a game needs different giants than a compiler).
