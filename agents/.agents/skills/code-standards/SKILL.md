---
name: code-standards
description: Coding standards for writing and reviewing code — comment discipline, layer boundaries, nullability, reuse of existing facilities, naming, scope control, logging, correctness traps, and error-handling taste. Read before implementing a change, before opening a pull request, and when reviewing a diff. Language- and framework-agnostic.
---

# Code standards

Constraints on what you write, not a cleanup pass afterwards. Before opening or reviewing a pull request, work `references/self-review-checklist.md`.

If you cannot say why a line is there, it should not be there.

## 1. Comments must earn their place

A comment is justified only when it records what a reader cannot recover from the code: a hidden constraint, a non-obvious invariant, a workaround for a specific upstream bug, or a non-obvious tradeoff.

Delete on sight:

- **Restatement** of what the name, signature, or types already say.
- **Negative space** — what something does not do, does not handle, or stays free of.
- **Changelog** — what a value used to be, or what you changed it from.
- **Issue keys**, except in a `TODO` pointing at tracked follow-up work.
- **Its own first caller** — a general-purpose unit naming the feature that happens to use it first.
- **Downstream consumers** — the UI, the client, or the caller's motivation.
- **Repeated concepts** — explain a shared mechanism once, at its definition.

Length is a signal, not a defect. A comment past three lines usually has one of the patterns above buried in it — trim to the load-bearing part rather than deleting it.

Do not overcorrect: outside these patterns, leave existing comments alone.

## 2. Respect layer boundaries — in prose and in signatures

Where the architecture separates domain logic from storage, transport, or framework:

- **Comments.** A domain-layer interface must not name the database, query language, broker, or framework implementing it.
- **Signatures.** No storage-shaped parameters through an abstract interface — partition keys, row cursors, filter expressions. The implementation derives those from a domain argument itself.
- **Vocabulary.** Use the words of the layer you're in.

Business rules belong in the service layer; storage stays thin. A storage method deciding *whether* an operation is allowed holds logic that belongs a layer up.

## 3. Don't use nullability or defaults to dodge a decision

- Optional only when absence is a real, meaningful state.
- No default on a parameter the caller should be forced to think about — especially on domain types, where a plausible-but-wrong default silently produces wrong data.
- No default on something always injected or always supplied.
- Where the language already gives optionality a zero value, don't also write the initializer.
- If a value can only be absent in an impossible case, assert instead of threading the optional downstream.

## 4. Use what already exists

Before writing logging, metrics, tracing, serialization, error propagation, config access, clocks, id generation, HTTP/database clients, or test fixtures: search for the concern, then match the nearest sibling that already does it. These are nearly always centralized.

Same for ordinary helpers — check first, and extend a near-miss rather than adding a parallel one. Extract shared constants (table and index names, key prefixes, limits) to one place.

If you cannot find the existing facility, ask rather than hand-rolling one.

Where usage is inconsistent, follow the dominant convention and flag the inconsistency — don't add a third variant.

## 5. Match the surrounding altitude

- **Too little structure.** Repeated branching or near-identical blocks want one function. Writing the same shape a third time means extract it.
- **Too much structure.** No helper wrapping a single call, no interface with one implementation and no seam to justify it, no builder for one construction site, no variable or alias adding no meaning over what it wraps. Don't stack helpers so deep a reader can't tell what runs when.

When the shape isn't obvious yet, stay flat and say what would make you extract it.

## 6. Name things for what they specifically are

- Expand unclear abbreviations.
- A generically-named type must actually be generic. If it serves one feature, name it for that feature and move it beside that feature, or make it genuinely reusable.
- Match the name to how the value travels: returned as a failure value is an `Error`, thrown is an `Exception`.
- Conversion functions get directional names (`toX` / `fromX`), used consistently.
- Strong types over strings — a dedicated id type, an enum over string constants.
- Vague verbs (`handle`, `process`, `close`, `do`, `update`) must say what they actually do.

## 7. Stay inside the ticket

- Found something else worth fixing? Note it and propose it separately.
- Restructuring adjacent code "while we're here" is scope creep.
- If a refactor is genuinely required to make the change work, say so in the pull request description.
- **Never smuggle a behavior change into a refactor.** If a move or rename would alter which error surfaces first, which failure is fatal, or what gets logged, raise it as a decision.

## 8. Recurring correctness traps

- **Concurrency guards.** Every read-modify-write on shared state needs its version or precondition check. The *caller* owns incrementing the version, not the storage layer.
- **Unbounded reads.** Never scan a whole table or collection. Design the access path, or add the index.
- **Pagination.** Follow the continuation token to exhaustion; don't materialize every page to take the first.
- **Persisted identifiers.** Never persist a language-level enum name — use an explicit stable value plus an explicit parse.
- **Caps that don't cap.** Verify a limit bounds in-flight work, not just the dispatch site.
- **Async boundaries.** Cross between synchronous and asynchronous once, at the entry point, never in a leaf.
- **Fire and forget.** Be deliberate about whether work you start is awaited.
- **Time.** Injected clock over an inline now, and be explicit about the timezone a date belongs to.

## 9. Logging

- Every line carries a human-readable message; never bare context.
- Variables as structured fields, not interpolated into the message.
- Log boundaries and the unexpected. Don't narrate normal control flow.
- Error level is for things a human must act on.

## 10. Don't add observability speculatively

Don't add metrics, gauges, or spans because they seem useful or because a ticket lists them — propose them and ask. Timing or counting plumbing at a call site belongs in the shared facility.

## 11. Error-handling taste

- **Errors as values where the language supports it.** Return a result type for recoverable failures; reserve throwing for the unrecoverable. Where the language has no such paradigm, use its idiomatic mechanism.
- **Impossible states assert; possible states return.** Don't invent a recoverable error type nobody will handle.
- **One error channel per boundary.** Don't catch exceptions to convert them into values, or wrap a value-returning call to throw.
- **Narrowest construct that does the job.** No two-sided combinator with an inert side.
- **Errors carry their diagnostics** — the identifier or value that caused the failure.
- **No unreachable code** after a construct that already exits.

## 12. Let the language and compiler work

- Don't hand-write generated members: equality, hashing, string representation, accessors.
- Prefer exhaustive matching over a catch-all, so a new variant fails the build.
- Use the language's idiomatic construct, not one ported from another language.
