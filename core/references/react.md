# React and React Native

Use this reference when component boundaries, hook placement, or inline JSX logic
are the material design decision.

## Placement

Keep components, hooks, API calls, and utilities beside the feature or screen that
owns them. Two screens in one feature do not establish global reuse. Promote code
only when unrelated features share the same concept and need it to evolve together.

Compose feature plumbing behind a small local interface so the screen states what
it needs rather than how each request and state transition works:

```tsx
const { messages, sendMessage, isSending } = useChatRoom(roomId)
```

## Render structure

Derive filtered, mapped, or reduced data before returning JSX. Avoid nested
ternaries, multi-stage collection pipelines, and substantial event logic inside
attributes. Name the derived value so the returned tree remains scannable.

```tsx
const rows = (data?.items ?? []).filter(item => !item.hidden).map(toRow)
return <List items={rows} />
```

Split a component when the extracted part has a coherent responsibility or makes
the parent materially easier to read. Do not split solely because a file crossed a
line count, and do not add `Container`, `Wrapper`, or `Component` suffixes to explain
an unclear responsibility.
