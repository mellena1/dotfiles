# Self-review checklist

Run against the diff, not from memory. `BASE=main`, or the parent branch in a stack. Greps are starting points, not verdicts.

## Pass 1 — comments (highest yield)

For each added comment: delete restatement, negative space, changelog, issue keys outside a `TODO`, first-caller naming, downstream-consumer mentions, re-explained mechanisms. Keep hidden constraints, invariants, upstream bugs, non-obvious tradeoffs. Anything past three lines gets trimmed to its load-bearing part, not deleted. Leave existing comments outside those patterns alone.

```sh
git diff "$BASE"...HEAD | grep -nE '^\+.*[A-Z][A-Z0-9]+-[0-9]+'   # issue keys
```

## Pass 2 — layer boundaries

```sh
git diff "$BASE"...HEAD -- '<inner-layer-path>' | grep -niE '\+.*(dynamo|postgres|sql|kafka|pulsar|redis|s3|http|grpc|spring|django|rails)'
```

Any hit inside the inner layer, comment or identifier, is a finding. Then read every new abstract signature: does a parameter only make sense for one implementation? Did a decision about whether an operation is permitted land in the storage layer?

## Pass 3 — nullability and defaults

```sh
git diff "$BASE"...HEAD | grep -nE '^\+.*(\?\s*[:=)]|= *(null|None|nil|undefined)|Optional<|\| *None)'
```

For each: name the real state absence represents, or make it required. For each new default: would a caller passing the wrong thing silently produce wrong data?

## Pass 4 — reuse

For every new helper, utility, constant, or cross-cutting concern:

```sh
grep -rn "<the concept>" .
```

Did you use the project's designated facility, or write your own? Any string literal repeated across files should be one shared constant.

## Pass 5 — altitude

Inline any new helper wrapping a single call. Drop any new interface with one implementation and no seam. Flatten chains three or more helpers deep. Conversely, extract any shape now appearing three or more times.

## Pass 6 — naming

New names: abbreviations expanded, generic names actually generic, failure types matching how they travel (returned `Error` vs thrown `Exception`), conversions directional, ids and fixed vocabularies typed rather than strings.

## Pass 7 — scope

```sh
git diff --stat "$BASE"...HEAD
```

State in one sentence why the ticket required touching each file. Any file you can't justify comes out of the diff. Revert formatting-only churn. Pull out or explicitly call out any behavior change riding inside a refactor.

## Pass 8 — correctness traps

Version check on every read-modify-write, with the caller owning the increment. Every query bounded. Every paged read following its token to exhaustion. Every persisted enum stored by explicit value. Every cap actually bounding in-flight work. Sync/async crossed only at the entry point. Started work deliberately awaited or deliberately not.

## Pass 9 — logging and observability

```sh
git diff "$BASE"...HEAD | grep -nE '^\+.*(log|logger|Log)\.'
```

Each added line: human-readable message, structured fields, not on an ordinary frequent branch, error level only if a human must act. Remove any metric, gauge, or span added without being asked.

## Pass 10 — errors and idiom

Recoverable failures returned as values where the language supports it, throwing reserved for the unrecoverable. Asserts for impossible states rather than unused error types. One error channel per boundary. No inert side on a combinator. No unreachable code. No hand-written generated members. Exhaustive matching over catch-alls.

## Reporting

Group findings by rule, most severe first. For anything you chose not to fix, name the rule and why.
