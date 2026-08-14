# Harness

Personal agent instructions for Claude Code and Codex.

Two layers, split by one line: **rules are always on, examples are on demand.**

- **`core/agent-defaults.md`** — always in context. Every rule: behavior (assumptions, scope, editing existing code, verification), code shape, naming, abstraction thresholds, JS/TS and React specifics, commits. Complete on its own.
- **`skills/coding-style/`** — loaded on demand. Worked ❌/✅ pairs for the judgment calls that go wrong most often.

## Why the split falls there

No agent can make a skill always-on. Claude Code has no `alwaysApply` for skills, and neither does Codex — loading one is the model's decision, based on matching your request against the skill description. A rule you need every time cannot live there.

The guaranteed channel is `CLAUDE.md` / `AGENTS.md`. Claude Code resolves `@` imports at session start, so the content is literally in the prompt. Every rule therefore sits in `core/agent-defaults.md`.

The examples stay on demand for a different reason than cost. If a rule is not loaded, nothing applies. If an example is not loaded, the rule still applies — it is an aid for resolving a judgment call, not a rule. And it is 150 lines of code samples that would otherwise dilute the rules in every session that has nothing to do with code.

## Install

```sh
./install.sh
```

Writes:

| Path | What |
| --- | --- |
| `~/.agents/core/agent-defaults.md` | The always-on defaults |
| `~/.agents/skills/coding-style/` | Canonical skill copy, shared across agents |
| `~/.claude/skills/coding-style/` | Claude Code skill |
| `~/.codex/skills/coding-style/` | Codex skill |
| `~/.claude/CLAUDE.md` | A managed block importing the defaults |
| `~/.codex/AGENTS.md` | A managed block with the defaults inline |

Honors `CLAUDE_CONFIG_DIR` and `CODEX_HOME`.

Claude Code and Codex use the same `SKILL.md` format — `name` and `description` frontmatter plus a markdown body — so one skill folder serves both.

The entry points differ, and not just cosmetically. Claude Code resolves `@` imports into the prompt, so a one-line reference is enough. Codex includes `AGENTS.md` verbatim but does **not** follow references out of it — pointing at a file there only produces an instruction the model may or may not act on. So the Codex block carries the defaults inline.

Re-run `./install.sh` after editing anything here. It copies, so the repo is the source of truth and the installed copies are outputs.

Verify Codex picked it up:

```sh
codex debug prompt-input | grep -c coding-style
```

## Managed block

`CLAUDE.md` and `AGENTS.md` are files you also keep your own rules in, so the installer never overwrites them. It only replaces the region between its markers and leaves everything else alone:

```markdown
# my own global rules
...

<!-- agent-harness:begin -->
@/Users/you/.agents/core/agent-defaults.md
<!-- agent-harness:end -->
```

Uninstall removes the block and the installed skills, leaving the rest of the file intact:

```sh
./install.sh --uninstall
```
