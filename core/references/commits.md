# Commits

Use this reference when a change contains multiple candidate commit boundaries or
the appropriate Conventional Commit type is unclear.

Each commit should represent one reviewable intent. Separate independent changes
that can be understood, reverted, and validated on their own. Keep inseparable code,
tests, and documentation for one behavior in the same commit.

Use a concise Conventional Commit subject in the imperative form:

```text
fix: handle empty session
refactor: simplify github user fetch
docs: document harness loading model
```

Choose the type from the user-visible intent, not the file extension. A behavioral
bug fix with accompanying documentation remains `fix`; a documentation-only change
is `docs`. Do not mix opportunistic cleanup into the same commit merely because it
touches nearby files.
