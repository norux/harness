# Agent Core

Always-on defaults for coding work. Repository instructions override this file.
For a trivial change such as a typo or an obvious one-liner, use judgment instead
of applying the full process mechanically.

The standing orders below are complete enough to follow without opening another
file. Read a linked reference only when its trigger applies and more detail would
change the decision.

## Before coding

- State the assumptions you are acting on. Ask instead of guessing when an
  unverified assumption would materially change the result.
- Present materially different readings of an ambiguous request instead of
  choosing one silently.
- Mention a simpler approach before implementing a more complex requested one.
- If you are confused, name what is confusing. Do not code through it.

Read [before-coding](references/before-coding.md) when ambiguity affects scope,
persistence, compatibility, or user-visible behavior.

## Scope and existing code

- Build only what was asked. Add no speculative features, options, abstractions,
  or impossible-case handling.
- Every changed line must trace to the request. Do not improve adjacent code,
  comments, naming, or formatting.
- Match the surrounding style. Remove only code your own change orphaned; leave
  pre-existing dead code in place and mention it.

Read [scope and editing](references/scope-and-editing.md) when a change appears to
require adjacent cleanup, broad refactoring, or behavior beyond the request.

## Code design

- Prefer short, obvious functions and shallow control flow. Add comments only
  for non-obvious intent, tradeoffs, or external constraints.
- Use direct names. If a name needs a sentence, split the responsibility.
- Do not create a shared abstraction for one call site. Keep helpers local until
  unrelated callers establish a repeated need.
- Preserve the existing architecture with the smallest change that fits it.

Read [code design](references/code-design.md) when deciding whether to extract,
generalize, split, configure, or introduce a shared API.

## JavaScript and TypeScript

- Prefer plain functions and data; use classes only where the repository uses
  them for the same role.
- Prefer narrow inline types and literals. Extract constants only for meaning,
  reuse, or mistake prevention.
- Keep exports minimal, helpers near their callers, and the repository's existing
  formatter, quoting, semicolon, and import style.
- Do not export implementation details solely so tests can reach them.

Read [JavaScript and TypeScript](references/javascript-typescript.md) before a
JS/TS design choice would add a new public surface or shared utility.

## React and React Native

- Keep components, hooks, and utilities with their feature. Promote them only
  when unrelated features share them.
- Derive data before JSX and keep the returned tree scannable. Split components
  when it improves readability, not to meet a line count.
- Compose feature plumbing behind a small local interface so screens state intent.

Read [React](references/react.md) when component boundaries, hook placement, or
inline JSX logic are the material design decision.

## Verification

- Translate the request into an observable success criterion before changing code.
- For a bug, establish the failing regression check first, then fix it.
- For multi-step work, pair every step with its verification and run the checks.
- Report what actually ran and failed. Never call an unverified change complete.

Read [verification](references/verification.md) when choosing the smallest check
that demonstrates the requested behavior.

## Commits

- Use Conventional Commits with a concise subject and one intent per commit.

Read [commits](references/commits.md) when a change contains multiple candidate
commit boundaries or the appropriate Conventional Commit type is unclear.

## Judgment examples

When a coding-style decision is genuinely unclear, use the `coding-style` skill
for worked avoid/prefer examples. The references above own the rules; the skill
only illustrates common failure modes.
