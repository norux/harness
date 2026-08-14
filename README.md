# Harness

Personal agent instructions for Claude Code and Codex.

The harness has three information layers, separated by how often an agent needs
them:

- **`core/index.md`** — always in context. Compact standing orders plus explicit
  triggers for deeper references. It is actionable on its own.
- **`core/references/`** — loaded on demand. One file per decision domain with
  boundaries, rationale, and small examples.
- **`skills/`** — loaded on demand through skill matching. Reusable workflows and
  extended judgment examples.

The repository is the source of truth. Files under `~/.agents`, `~/.claude`, and
`~/.codex` are installation outputs; edit this repository and rerun the installer.

Repository maintenance rules live in [`AGENTS.md`](AGENTS.md). Claude Code reads the
same rules through [`CLAUDE.md`](CLAUDE.md), which imports `AGENTS.md` instead of
duplicating it.

## Why the split falls there

A rule that must affect every coding task cannot depend on a skill or a reference
being selected. The index therefore keeps every standing order in a concise form.
References add detail only when a named trigger applies, while skills own repeatable
procedures and worked examples.

Splitting files does not automatically save context. Claude Code expands `@` imports
into the startup prompt, and Codex has no documented equivalent inside `AGENTS.md`.
The Claude entry point imports only the index; the Codex installer inlines the same
index and rewrites its reference links to installed absolute paths. Neither entry
point eagerly loads the references.

See [docs/harness-architecture.md](docs/harness-architecture.md) for the researched
loader behavior, design rationale, DeepSeek Harness lessons, and maintenance rules.

## Core organization

Each reference owns one domain:

| Reference | Read when |
| --- | --- |
| `before-coding.md` | Ambiguity changes scope, persistence, compatibility, or behavior |
| `scope-and-editing.md` | Adjacent cleanup or scope expansion appears necessary |
| `code-design.md` | Extracting, generalizing, splitting, or configuring code |
| `javascript-typescript.md` | A JS/TS choice adds shared or public surface |
| `react.md` | Component, hook, or JSX boundaries are material |
| `verification.md` | Selecting evidence that proves the requested outcome |
| `commits.md` | Commit boundaries or Conventional Commit type are unclear |

`core/index.md` is the authoritative manifest. The installer rejects missing,
duplicate, and unlisted reference files.

## Install

```sh
./install.sh
```

Writes:

| Path | What |
| --- | --- |
| `~/.agents/core/` | Canonical installed index and references |
| `~/.agents/skills/coding-style/` | Canonical cross-agent skill copy |
| `~/.claude/skills/coding-style/` | Claude Code skill |
| `~/.claude/CLAUDE.md` | Managed block importing `core/index.md` |
| `~/.codex/AGENTS.md` | Managed block with the index inline |

The installer honors `CLAUDE_CONFIG_DIR` and `CODEX_HOME`. Re-running it is
idempotent: current targets are reported without being rewritten.

Claude Code and Codex use the same `SKILL.md` format, so one skill source serves
both. Claude Code receives its tool-specific copy; Codex discovers the canonical
user copy under `~/.agents/skills`. The installer removes the legacy duplicate under
`~/.codex/skills` when upgrading an older installation.

Verify Codex picked up the managed block:

```sh
codex --ask-for-approval never "Summarize the current instructions."
```

## Managed blocks

`CLAUDE.md` and `AGENTS.md` may contain unrelated personal rules, so the installer
never overwrites the complete file. It only replaces the region between its markers:

```markdown
# unmanaged personal rules

<!-- agent-harness:begin -->
...
<!-- agent-harness:end -->
```

Malformed or duplicate markers cause installation to stop rather than risk deleting
unmanaged content.

Uninstall removes the managed blocks and installed harness paths while leaving all
other content intact:

```sh
./install.sh --uninstall
```
