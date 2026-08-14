# Agent Defaults

Always-on defaults for coding work.

Repository instructions win over this file. For trivial changes — a typo, an obvious one-liner — use judgment instead of the full rigor below.

## Before Coding

- State the assumptions you are acting on. If one is load-bearing and you cannot verify it, ask instead of guessing.
- If the request has more than one reasonable reading, present the readings. Do not pick one silently.
- If a simpler approach exists, say so before implementing the one that was asked for.
- If you are confused, name what is confusing. Do not code through it.

## Scope

- Build what was asked. No extra features, options, or configurability.
- No abstraction for a single call site.
- No error handling for cases that cannot happen.
- Test: every changed line traces to something the user asked for.

## Editing Existing Code

- Touch only what the task requires. Do not improve adjacent code, comments, or formatting.
- Match the surrounding style even where you would write it differently.
- Remove only what your own change orphaned. Mention pre-existing dead code; do not delete it.
- Do not rename or move things that are outside the task.

## Code Shape

- Prefer short, obvious code over clever abstractions.
- Write code that reads without comments. Add a comment only for non-obvious intent, a tradeoff, or an external constraint.
- Keep functions small and focused. If the name turns into a sentence, the function is doing too much — split it.
- Keep call depth shallow enough that the main behavior is traceable in one pass.
- Prefer a few clear steps over a chain of deeply nested helpers.

## Naming

- Use direct names: `fetchGithubUser`, `parseToken`, `createSession`.
- Avoid over-specific names like `fetchGithubUserInfoByAPI` unless the distinction matters at the call site.
- If a name needs many words to explain its role, suspect too many responsibilities rather than a naming problem.

## Abstraction

- Do not add a shared abstraction before there is clear repeated need.
- Keep abstractions at the feature level before promoting them to global scope.
- Use a facade when it makes the calling code simple: compose small pure functions behind a clean, local API.
- Make the smallest change that preserves the existing architecture.
- Test: would a senior engineer call this overcomplicated? If yes, simplify.

## JavaScript and TypeScript

JS/TS is the default style baseline. Other languages inherit only the rules above.

- Prefer plain functions and data. Use a class only where the codebase already uses classes for the same role.
- Prefer inline literals and narrow inline types over exported constants.
- Do not extract a constant just to avoid a string literal. Extract when it improves meaning, enables reuse, or prevents a mistake.

```ts
// avoid
export const STATUS_ACTIVE = 'active'
function setStatus(user: User, status: string) {}

// prefer
function setStatus(user: User, status: 'active' | 'banned') {}
```

- Keep small pure helpers next to the code that uses them. Move one up a level only when a second unrelated caller appears.
- Keep exports minimal and intentional. An export is an API surface.
- Do not export something only so a test can reach it — test through the public entry point, or move the logic to where it belongs.
- Follow the project's formatter, linter, and existing import style. Do not change quoting, semicolon, or import-ordering conventions mid-file.

## React and React Native

- Keep components, hooks, and utilities next to the feature or screen that uses them.
- Promote to a shared location only when unrelated features use it. Two screens in the same feature is not "unrelated".
- Compose hooks, pure utilities, and API calls behind a small local interface, so the screen reads as intent rather than plumbing.

```tsx
// prefer: the screen states what it needs
const { messages, sendMessage, isSending } = useChatRoom(roomId)
```

- Derive data before the JSX. Keep the returned tree scannable.
- Avoid deep inline logic in JSX — no nested ternaries inside attributes, no inline `.filter().map().reduce()` chains.
- Split a component when it improves readability, not to hit a line count.
- Use descriptive names without role explanations: `ChatRoomScreen`, `useChatRoom` — not `ChatRoomScreenContainerComponent`.

```tsx
// avoid
return <List items={data?.items.filter(i => !i.hidden).map(toRow) ?? []} />

// prefer
const rows = (data?.items ?? []).filter(item => !item.hidden).map(toRow)
return <List items={rows} />
```

## Verification

- Turn the task into a checkable outcome before starting: "add validation" becomes "tests for invalid input pass".
- For a bug, write the failing test first, then fix it.
- For multi-step work, state each step with its check:
  ```
  1. <step> → verify: <check>
  ```
- Run the check. Report what actually happened, including failures.
- Do not report done on an unverified change. If part of the request is unfinished or skipped, say which part and why.

## Commits

- Use Conventional Commits.
- Keep subjects concise: `fix: handle empty session`, `refactor: simplify github user fetch`.
- One intent per commit.

## Examples

The rules above are complete on their own. When a judgment call is genuinely unclear — is this diff overcomplicated, over-scoped, or drifting from the request — read the `coding-style` skill for worked ❌/✅ pairs.
