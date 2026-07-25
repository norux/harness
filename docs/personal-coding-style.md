# Personal Coding Style

Apply these preferences by default across projects. If a repository has more specific instructions, follow the repository first.

## Core Style

- Prefer short, obvious code over clever abstractions.
- Write code that is readable without comments.
- Add comments only when they explain non-obvious intent, tradeoffs, or external constraints.
- Keep functions small and focused. If a name becomes sentence-like, split the behavior.
- Prefer direct names: `fetchGithubUser`, `parseToken`, `createSession`.
- Avoid over-specific names like `fetchGithubUserInfoByAPI` unless the distinction matters in the local code.
- Keep call depth shallow enough that the main behavior is easy to trace.
- Use a facade when it makes the calling code simple: compose small pure functions behind a clean, local API.
- Do not add broad shared abstractions before there is clear repeated need.

## JavaScript and TypeScript

- Treat JS/TS as the default style baseline.
- Prefer plain functions and data over classes unless the codebase already uses classes for the same role.
- Prefer TypeScript literals and narrow inline types over unnecessary exported constants.
- Avoid extracting constants just to avoid a string literal. Extract only when it improves meaning, reuse, or correctness.
- Prefer small pure helpers near the code that uses them.
- Keep module exports minimal and intentional.
- Follow the project's formatter, linter, and existing import style.

## React and React Native

- Keep components, hooks, and utilities close to the feature or screen that uses them.
- Avoid global utilities unless they are genuinely shared across unrelated features.
- Prefer local facades for feature behavior: compose hooks, pure utilities, and API calls behind a small interface.
- Keep components easy to scan: derive data before JSX, avoid deep inline logic, and split only when it improves readability.
- Prefer descriptive component and hook names without long role explanations.

## Refactoring

- Make the smallest change that preserves the existing architecture.
- Improve names and boundaries when touching code, but avoid unrelated cleanup.
- Suspect a function has too many responsibilities when its name needs many words.
- Prefer a few clear steps over a chain of deeply nested helpers.
- Keep abstractions at the feature level before moving them to global scope.

## Commits

- Use Conventional Commits.
- Prefer concise commit subjects, for example `fix: handle empty session` or `refactor: simplify github user fetch`.
- Keep commits focused on one intent.
