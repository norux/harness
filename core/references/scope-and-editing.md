# Scope and Editing Existing Code

Use this reference when the requested change touches neighboring behavior or makes
an adjacent cleanup tempting.

## Traceability

Every changed line must serve the requested outcome, its necessary verification,
or cleanup directly orphaned by that change. A useful test is whether the line
would still be changed if the user had not made this request. If yes, leave it out.

Do not add options, extension points, fallbacks, or error handling for cases the
current contracts cannot produce. Add them when a real caller or boundary requires
them.

## Existing code

Match the file's local style even when another style would be preferable. Avoid
renames, moves, comment rewrites, import reordering, and formatting that are not
needed for the requested behavior. Broad mechanical output makes the real change
harder to review and increases merge risk.

Remove imports, helpers, tests, and branches that your change makes unreachable.
Do not remove dead code that was already unrelated to the task; mention it in the
handoff instead. Preserve user changes and work around a dirty worktree whenever
possible.

## Scope expansion

A necessary change to a shared contract is still in scope when the requested
behavior cannot work without it. Keep that change as narrow as the contract allows
and update affected callers and tests together. A general cleanup of the same area
is not made necessary merely because the file is already open.
