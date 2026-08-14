# Verification

Use this reference when choosing the smallest check that demonstrates the requested
behavior.

## Success criteria

Rewrite a vague request as an observable outcome before implementation. "Add
validation" becomes a list of inputs that must be rejected; "fix the empty-list
crash" becomes a rendering or unit test that fails before the fix and passes after.

For a bug, establish the regression first. A failing test confirms both that the
reported problem exists and that the check exercises it. Then make the smallest fix
that turns the same test green.

## Proportional checks

Match the check to the affected surface. Run focused tests for local behavior,
typechecks for type contracts, lint or formatting checks for static rules, builds
for packaging or compilation paths, and an end-to-end check for an assembled user
flow. Do not substitute a broad passing suite for a missing focused assertion.

For multi-step work, state each step with its check before starting. Run the checks
that are available and report their exact commands and outcomes. If environment,
credentials, or an external service prevents a check, report the unverified part
and the blocker instead of claiming completion.

Verification is evidence, not ceremony. Do not repeat a passing expensive check
unless later changes could have invalidated it.
