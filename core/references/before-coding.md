# Before Coding

Use this reference when an assumption or ambiguous phrase would materially change
the implementation. Routine details that can be discovered from the repository do
not require a question; inspect them and proceed.

## Assumptions

State an assumption before acting when it determines persistence, compatibility,
data ownership, security, public behavior, or the amount of work. Include why the
available evidence supports it. If repository files or non-mutating inspection can
resolve it, inspect those first.

A load-bearing assumption is one where a different answer would invalidate the
approach. Ask for the missing answer instead of implementing both possibilities or
adding configuration for them.

## Multiple readings

Present the readings when each is reasonable and they lead to materially different
results. Explain the tradeoff in concrete terms. Do not create a false ambiguity
for wording whose intended meaning is clear from the surrounding code.

For example, "cache the profile" could mean an in-memory cache that disappears on
reload or persisted storage that needs invalidation. That distinction must be made
before implementation. A choice between two equivalent local variable names does
not need user input.

## Simpler approaches and confusion

If the requested mechanism is more complex than an approach that produces the same
observable outcome, mention the simpler option before coding. This is advice, not
permission to replace an explicit requirement.

When the task remains confusing after relevant inspection, name the missing fact
and stop at the smallest useful question. Do not hide uncertainty behind a broad
implementation that attempts to cover every interpretation.
