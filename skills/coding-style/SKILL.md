---
name: coding-style
description: Worked ❌/✅ examples for the coding-style judgment calls that go wrong most often — speculative configurability, single-call-site abstraction, drive-by refactors, orphan cleanup, silent assumptions, and weak success criteria. Use when unsure whether a change is overcomplicated, over-scoped, or drifting from the request. The rules themselves are already in context via the agent defaults; this skill only illustrates them.
---

# Coding Style Examples

Concrete pairs for the judgment calls that go wrong most often. Each one names the rule it fails.

---

## 1. Speculative configurability

**Request:** "Add a retry to the token refresh call."

**Avoid** — options nobody asked for:

```ts
type RetryOptions = {
  maxAttempts?: number
  backoff?: 'linear' | 'exponential'
  jitter?: boolean
  onRetry?: (attempt: number, error: Error) => void
  retryableStatuses?: number[]
}

async function refreshToken(opts: RetryOptions = {}) {
  const { maxAttempts = 3, backoff = 'exponential', jitter = false } = opts
  // ...30 more lines
}
```

**Prefer** — what was asked:

```ts
async function refreshToken() {
  for (let attempt = 0; attempt < 3; attempt++) {
    try {
      return await requestToken()
    } catch (error) {
      if (attempt === 2) throw error
    }
  }
}
```

Fails: *no options or configurability that wasn't requested*. If a caller later needs exponential backoff, add it then.

---

## 2. Abstraction for a single call site

**Request:** "Show the user's display name in the header."

**Avoid:**

```ts
// formatters/index.ts
export const formatters = {
  displayName: (user: User) => user.nickname ?? user.email.split('@')[0],
}
```

**Prefer** — inline, next to its one caller:

```tsx
function Header({ user }: { user: User }) {
  const displayName = user.nickname ?? user.email.split('@')[0]
  return <h1>{displayName}</h1>
}
```

Fails: *no abstraction for a single call site*, and *keep helpers near the code that uses them*. A `formatters` barrel is a global API surface created for one line.

---

## 3. Drive-by refactor

**Request:** "Fix the timezone bug in `formatDueDate`."

**Avoid** — the diff touches five things:

```diff
-function formatDueDate(date) {
-  // TODO: check timezone
-  return date.toLocaleDateString()
+const formatDueDate = (date: Date, locale = 'en-US'): string => {
+  return date.toLocaleDateString(locale, { timeZone: 'UTC' })
 }
-
-function formatCreatedAt(date) {
-  return date.toLocaleDateString()
-}
+const formatCreatedAt = (date: Date): string => date.toLocaleDateString()
```

Unrequested: converted to arrow functions, added types, added a `locale` parameter, deleted a comment it did not understand, reformatted an unrelated function.

**Prefer:**

```diff
 function formatDueDate(date) {
-  // TODO: check timezone
-  return date.toLocaleDateString()
+  return date.toLocaleDateString(undefined, { timeZone: 'UTC' })
 }
```

Fails: *every changed line traces to something the user asked for*. The arrow-function style and missing types are worth mentioning in the summary — not fixing in this diff.

---

## 4. Orphan cleanup: yours, not theirs

**Request:** "Drop the CSV export path."

```ts
import { toCsv } from './csv'        // orphaned by your change → remove
import { toXlsx } from './xlsx'      // already unused before you arrived → leave, mention it

export function exportUsers(users: User[]) {
  return toJson(users)
}
```

Remove the `toCsv` import because your change orphaned it. Leave `toXlsx` and say so: "`toXlsx` was already unused before this change — left in place."

---

## 5. Silent assumption

**Request:** "Cache the user profile."

**Avoid** — decides everything, states nothing, then implements 200 lines: cache location, TTL, invalidation, whether stale reads are acceptable.

**Prefer** — surface the load-bearing choices first:

> Two readings here. (a) In-memory per session — cheap, gone on reload. (b) Persisted to storage with a TTL — survives reload, needs an invalidation rule for profile edits.
>
> I'll assume (a) unless you need it across reloads. Either way I need one answer: after the user edits their profile, should the cache be dropped immediately, or is a stale read for up to the TTL acceptable?

Fails: *state the assumptions you are acting on*, and *if the request has more than one reasonable reading, present the readings*.

---

## 6. Weak vs strong success criteria

| Request | Weak | Strong |
| --- | --- | --- |
| "Add validation" | make the form validate | `submit()` rejects empty email and password under 8 chars — tests cover both |
| "Fix the crash on empty list" | handle empty list | a test rendering `<List items={[]} />` passes without throwing |
| "Refactor `useChatRoom`" | clean it up | the existing suite passes before and after, with no public API change |
| "Speed up the search" | make it faster | the `search()` benchmark drops below 100ms for 10k items |

State the strong version before starting, then run it. A criterion you cannot run is not a criterion.
