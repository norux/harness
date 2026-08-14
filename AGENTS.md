# Repository Instructions

This repository is the source of truth for a personal agent harness shared by
Claude Code and Codex. Read [docs/harness-architecture.md](docs/harness-architecture.md)
before changing how instructions, references, skills, or entry points load.

## Source and installed outputs

- Edit files in this repository. Treat `~/.agents`, `~/.claude`, and `~/.codex`
  as generated installation outputs.
- Run `./install.sh` after changing `core/`, `skills/`, or installation behavior.
- Do not edit installed copies to implement a change; the next installation would
  overwrite it.
- Preserve unmanaged content in `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`.
  The installer owns only its marked blocks.
- Do not delete legacy or unrelated files in a user's home directory merely because
  this harness no longer references them.

## Information ownership

- `core/index.md` owns always-loaded standing orders and the trigger for each deeper
  reference. Keep every standing order actionable without opening another file.
- `core/references/` owns conditional detail, rationale, boundaries, and small
  examples. Each file covers one decision domain and appears exactly once in the
  index.
- `skills/` owns repeatable workflows and extended examples. Do not move a rule that
  must apply to every task exclusively into a skill.
- `docs/harness-architecture.md` owns loader facts and the rationale for this layout.
  Re-check current primary documentation before changing a claim about Claude Code
  or Codex behavior.
- Repository-specific instructions belong here. Personal coding defaults belong in
  `core/`; do not duplicate them in this file.

## Change discipline

- Keep `core/index.md` smaller than the detail it routes to. Splitting files is not
  useful if the installer then eagerly loads every reference.
- Add a reference only when it has a distinct read trigger. Add a skill when the
  content is an ordered procedure or a reusable specialized judgment process.
- When an installed path or managed output changes, update `install.sh`, `README.md`,
  and the architecture document together.
- Keep the installer POSIX `sh`. Preserve its refusal to modify malformed managed
  blocks and its idempotent `already current` behavior.
- Avoid adding generators, manifests, or configuration formats when the current
  explicit index and shell checks can express the requirement.

## Verification

For documentation-only changes, run the relevant subset. For loader, core, skill,
or installer changes, run all checks:

1. `sh -n install.sh`
2. `./install.sh`
3. Run `./install.sh` again and confirm every managed target reports
   `already current`.
4. `diff -r core ~/.agents/core`
5. `git diff --check`
6. When model-visible loading changes, inspect `codex debug prompt-input` and confirm
   the repository and global instruction sources appear as intended.

Report unavailable checks such as `shellcheck`; do not claim they ran.
