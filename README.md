# Harness

Personal agent instructions for Codex and Claude Code.

## Install

```sh
./install.sh
```

The installer creates:

- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`

Both files reference `docs/personal-coding-style.md`; the instructions themselves are never copied.

`CLAUDE.md` uses Claude Code's native file import. `AGENTS.md` instructs Codex to read the same document before starting work.
