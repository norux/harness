# Code Design

Use this reference when choosing whether to extract, generalize, split, configure,
or introduce a shared API.

## Shape

Prefer a few explicit steps over clever expressions or a deep helper chain. Keep a
function focused on one responsibility and keep the main behavior traceable in one
pass. Split code when the resulting names expose meaningful responsibilities, not
to satisfy an arbitrary line count.

Comments should preserve intent, a tradeoff, or an external constraint that the
code cannot express. Do not narrate syntax or restate control flow.

## Naming

Name the action or value directly: `fetchGithubUser`, `parseToken`, `createSession`.
Avoid role suffixes and implementation details unless they distinguish competing
concepts at the call site. If a precise name becomes a long sentence, first check
whether the code owns too many responsibilities.

## Abstraction threshold

One call site is not repeated need. Keep a helper or facade beside its feature until
an unrelated caller demonstrates a stable shared concept. Similar-looking code is
not automatically the same abstraction; it must change for the same reasons.

Prefer a local facade when it makes feature code read as intent while hiding several
small operations. Do not promote the facade to global scope without unrelated use.

Configuration is justified by an actual variation required by callers or deployment,
not by a possibility that might appear later. Defaults, hooks, and option objects all
increase the supported surface and require evidence that the surface is needed.
