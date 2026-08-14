# JavaScript and TypeScript

Use this reference before a JS/TS design choice adds a public surface, shared
utility, configuration object, or class.

## Functions, data, and types

Prefer plain functions and data. Use a class where the repository already models
the same lifecycle or role with classes, or where identity and encapsulated mutable
state are essential.

Use narrow literal unions and inline object types close to their only consumer.
Extract a named type when it communicates a domain concept, crosses a public
boundary, or has multiple meaningful users. Do not export a constant merely to
avoid repeating a string literal.

```ts
function setStatus(user: User, status: 'active' | 'banned') {}
```

## Placement and exports

Keep small pure helpers near their callers. Move one to a shared location only when
an unrelated caller establishes reuse. Treat every export as an API surface: export
only what consumers need, and do not expose private logic solely for a test.

Test behavior through the public entry point. If logic genuinely needs independent
ownership, move it to the feature-level module where that ownership is natural,
then test that module's public contract.

Follow the repository formatter, linter, module system, import ordering, quoting,
and semicolon conventions. Do not introduce a second style within a file.
