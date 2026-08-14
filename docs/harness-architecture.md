# Harness Architecture

This document records the facts and design decisions that govern this personal
harness. Re-check the linked product documentation before changing behavior that
depends on a loader, path, limit, or invocation syntax. The external facts below
were verified on 2026-08-14.

## Goals

- Keep rules that must affect every coding task in a small, platform-neutral core.
- Load detailed judgment guidance and repeatable workflows only when relevant.
- Maintain one repository as the source of truth and treat home-directory copies
  as generated installation outputs.
- Preserve the user's unmanaged content in Claude Code and Codex entry files.

## Platform loading facts

### Codex

Codex reads one non-empty global instruction file from its home directory:
`AGENTS.override.md` when present, otherwise `AGENTS.md`. For project instructions,
it walks from the project root to the current working directory, selecting at most
one instruction file per directory. More specific files appear later in the merged
prompt. The documented default combined project-instruction limit is 32 KiB.

Codex does not document a Claude-style `@path` include syntax inside `AGENTS.md`.
A Markdown link is not an automatic include. A file mentioned by an instruction can
still be read with filesystem tools, but that runtime action is not equivalent to
loader expansion and must not be the only place an essential standing order lives.

Source: [OpenAI custom instructions with AGENTS.md](https://developers.openai.com/codex/guides/agents-md).

### Claude Code

Claude Code expands `@path` imports in `CLAUDE.md` at session start. Paths may be
relative to the importing file or absolute, and imports may recurse up to four
hops. Imported content still enters the context window; splitting a large file into
imports improves maintenance but does not by itself reduce prompt size. A path in a
code span is literal and is not imported.

Source: [Claude Code memory and imports](https://code.claude.com/docs/en/memory#import-additional-files).

### Skills

Codex and ChatGPT use progressive disclosure for skills: the initial prompt exposes
each skill's name and description, and the full `SKILL.md` is read after the skill is
selected. A skill may contain `references/`, scripts, and assets. Codex discovers
user skills under `~/.agents/skills`, so that directory is the cross-agent canonical
installation target used by this repository. Do not also install the same skill
under `~/.codex/skills`; duplicate names are not merged and needlessly crowd the
available-skill list.

Use a skill for a repeatable workflow or a specialized decision process. Do not put
an always-required rule only in a skill because implicit selection depends on the
description match.

Source: [OpenAI skills documentation](https://developers.openai.com/codex/skills).

## Local information tiers

### `core/index.md`

The index is the always-loaded routing contract. Each section contains a concise
standing order that is actionable without another read, a trigger for deeper
guidance, and one link to the owning reference. It is intentionally not a prose
summary of every reference.

The installer imports this file from Claude Code and renders it inline for Codex.
Because Codex receives an inline copy outside the installed core directory, the
installer rewrites reference links to absolute installed paths.

### `core/references/`

Each reference owns one decision domain: assumptions, scope, code design, a language
or framework, verification, or commits. A reference contains the detail, exceptions,
and small examples that would dilute the always-loaded prompt. A file should not be
split further unless the resulting subjects have different read triggers.

Every reference must appear exactly once in `core/index.md`. The installer rejects
missing, duplicate, and unlisted reference files so the index cannot silently drift.

### `skills/`

Skills own reusable workflows and extended examples. Their descriptions state the
trigger and boundary; their bodies state the procedure. The `coding-style` skill is
an example: the core owns the rules, while the skill illustrates difficult judgment
calls.

### Repository instructions

Project-specific commands, architecture, and local conventions belong in that
repository's `AGENTS.md` and nested overrides. They do not belong in this personal
global harness. This keeps global guidance portable and lets the documented Codex
precedence model apply naturally.

For this repository, the root `AGENTS.md` owns maintenance instructions and
`CLAUDE.md` imports it with `@AGENTS.md`. The repository is small enough that nested
instruction files would add routing overhead without a distinct subtree contract.

## Lessons adopted from DeepSeek Harness

DeepSeek Harness separates standing orders, subtree instructions, architecture,
subsystem references, decision rationale, cookbooks, and skills. Its documentation
standard assigns one home to each fact and uses machine-checked links and word
budgets to prevent duplication and drift.

This repository adopts the one-home rule, concise standing orders, conditional
references, link validation, and prompt-size awareness. It does not adopt DeepSeek's
full Agent Note lifecycle because a personal harness of this size does not need that
process.

DeepSeek also removed a generated central index for Agent Notes because paths already
encoded lifecycle and classification, while the index created merge conflicts and
maintenance work. That decision applies to large inventories, not to this small
runtime routing contract. Here, `core/index.md` earns its place because the agent must
see read triggers before it knows which reference matters.

Sources:

- [DeepSeek documentation standard](https://github.com/deepseek-ai/deepseek-harness/blob/master/docs/AGENTS.md)
- [DeepSeek decision to remove the generated Agent Note index](https://github.com/deepseek-ai/deepseek-harness/blob/master/.agents/notes/implemented/process/2026-07-19-remove-generated-agent-note-index.md)

## Maintenance rules

- Keep the core lean. OpenAI reports that removing repeated instructions and
  examples improved quality and token efficiency in sample coding-agent evaluations;
  treat that result as directional and validate changes on representative tasks.
- State each standing order once. A reference expands its rationale and boundary but
  does not redefine it.
- Add a new core reference only when it has a distinct read trigger. Add a skill when
  the content is a procedure with ordered steps.
- Re-run `./install.sh` after changes. Its second run must report every managed target
  as already current.
- Verify both entry points after loader changes: Claude Code should import the index,
  and the Codex managed block should contain the same standing orders with absolute
  reference links.

Source for lean-prompt guidance: [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model#favor-leaner-prompts).
