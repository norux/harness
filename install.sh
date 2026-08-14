#!/usr/bin/env sh

set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
claude_home="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
codex_home="${CODEX_HOME:-$HOME/.codex}"

skill_name=coding-style
core_source="$repo_dir/core/agent-defaults.md"
skill_source="$repo_dir/skills/$skill_name"
core_target="$HOME/.agents/core/agent-defaults.md"
legacy_doc="$HOME/.agents/docs/personal-coding-style.md"

begin_marker="<!-- agent-harness:begin -->"
end_marker="<!-- agent-harness:end -->"

drop_block() {
  awk -v begin="$begin_marker" -v end="$end_marker" '
    $0 == begin { inside = 1; next }
    $0 == end   { inside = 0; next }
    !inside
  ' "$1"
}

replace_block() {
  awk -v begin="$begin_marker" -v end="$end_marker" -v block="$2" '
    $0 == begin {
      while ((getline line < block) > 0) print line
      close(block)
      inside = 1
      next
    }
    $0 == end { inside = 0; next }
    !inside
  ' "$1"
}

# Both parsers above key on whole-line marker matches and assume one well-formed
# block, so a stray marker in the target would silently move or drop content.
assert_one_block() {
  target="$1"

  begins=$(grep -cxF "$begin_marker" "$target" || true)
  ends=$(grep -cxF "$end_marker" "$target" || true)

  if [ "$begins" = 0 ] && [ "$ends" = 0 ]; then
    return
  fi

  if [ "$begins" != 1 ] || [ "$ends" != 1 ]; then
    printf 'refusing to touch %s: expected one managed block, found %s begin and %s end markers\n' \
      "$target" "$begins" "$ends" >&2
    exit 1
  fi

  if [ "$(grep -nxF "$begin_marker" "$target" | cut -d: -f1)" -gt "$(grep -nxF "$end_marker" "$target" | cut -d: -f1)" ]; then
    printf 'refusing to touch %s: the end marker comes before the begin marker\n' "$target" >&2
    exit 1
  fi
}

write_if_changed() {
  target="$1"
  content="$2"

  if [ -f "$target" ] && [ "$(cat "$target")" = "$content" ]; then
    printf 'already current: %s\n' "$target"
    return
  fi

  printf '%s\n' "$content" > "$target"
  printf 'wrote: %s\n' "$target"
}

sync_block() {
  target="$1"
  body="$2"

  mkdir -p "$(dirname -- "$target")"
  [ -f "$target" ] || : > "$target"
  assert_one_block "$target"

  block=$(mktemp)
  printf '%s\n%s\n%s\n' "$begin_marker" "$body" "$end_marker" > "$block"

  if grep -qxF "$begin_marker" "$target"; then
    content=$(replace_block "$target" "$block")
  else
    # First install. Also drops the reference this installer used to write,
    # so migrating from it does not leave a stale line behind.
    kept=$(awk '!index($0, "docs/personal-coding-style.md")' "$target")
    if [ -n "$kept" ]; then
      content="$kept

$(cat "$block")"
    else
      content=$(cat "$block")
    fi
  fi

  rm -f "$block"
  write_if_changed "$target" "$content"
}

sync_file() {
  source="$1"
  target="$2"

  mkdir -p "$(dirname -- "$target")"

  if [ -f "$target" ] && cmp -s "$source" "$target"; then
    printf 'already current: %s\n' "$target"
    return
  fi

  cp "$source" "$target"
  printf 'installed: %s\n' "$target"
}

sync_tree() {
  source="$1"
  target="$2"

  if [ -d "$target" ] && diff -r "$source" "$target" >/dev/null 2>&1; then
    printf 'already current: %s\n' "$target"
    return
  fi

  mkdir -p "$(dirname -- "$target")"
  rm -rf "$target"
  cp -R "$source" "$target"
  printf 'installed: %s\n' "$target"
}

remove_block() {
  target="$1"

  if [ ! -f "$target" ]; then
    return 0
  fi

  assert_one_block "$target"

  if ! grep -qxF "$begin_marker" "$target"; then
    return 0
  fi

  kept=$(drop_block "$target")
  if [ -n "$kept" ]; then
    printf '%s\n' "$kept" > "$target"
  else
    : > "$target"
  fi
  printf 'removed block: %s\n' "$target"
}

remove_path() {
  target="$1"

  if [ ! -e "$target" ]; then
    return 0
  fi

  rm -rf "$target"
  printf 'removed: %s\n' "$target"
}

if [ "${1:-}" = "--uninstall" ]; then
  remove_block "$claude_home/CLAUDE.md"
  remove_block "$codex_home/AGENTS.md"
  remove_path "$claude_home/skills/$skill_name"
  remove_path "$codex_home/skills/$skill_name"
  remove_path "$HOME/.agents/skills/$skill_name"
  remove_path "$core_target"
  exit 0
fi

if [ ! -f "$core_source" ]; then
  printf 'missing source file: %s\n' "$core_source" >&2
  exit 1
fi

if [ ! -f "$skill_source/SKILL.md" ]; then
  printf 'missing source file: %s\n' "$skill_source/SKILL.md" >&2
  exit 1
fi

# The Codex block carries this file inline, so a marker on its own line would
# make the block boundary ambiguous and duplicate content on the next install.
if grep -qxF -e "$begin_marker" -e "$end_marker" "$core_source"; then
  printf 'refusing to install: %s has a managed-block marker on its own line\n' "$core_source" >&2
  exit 1
fi

sync_file "$core_source" "$core_target"
sync_tree "$skill_source" "$HOME/.agents/skills/$skill_name"
sync_tree "$skill_source" "$claude_home/skills/$skill_name"
sync_tree "$skill_source" "$codex_home/skills/$skill_name"

# Claude Code resolves `@` imports at session start, so a reference is enough.
# Codex does not, so its block carries the defaults inline.
sync_block "$claude_home/CLAUDE.md" "@$core_target"
sync_block "$codex_home/AGENTS.md" "$(cat "$core_source")"

if [ -f "$legacy_doc" ]; then
  printf 'note: %s is no longer referenced and can be deleted\n' "$legacy_doc"
fi
