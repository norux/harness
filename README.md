# Harness

Personal agent instructions for Codex and Claude Code.

## Install

```sh
./install.sh
```

The installer creates:

- `~/.agents/docs/personal-coding-style.md`
- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`

The style guide is copied from `docs/personal-coding-style.md` to `~/.agents/docs/`. Both instruction files reference the installed copy.

`CLAUDE.md` uses Claude Code's native file import. `AGENTS.md` instructs Codex to read the same document before starting work.
