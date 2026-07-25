#!/usr/bin/env sh

set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file="$repo_dir/docs/personal-coding-style.md"
installed_file="$HOME/.agents/docs/personal-coding-style.md"

backup_file() {
  path="$1"
  timestamp=$(date +%Y%m%d%H%M%S)
  mv "$path" "$path.backup.$timestamp"
}

write_file() {
  target="$1"
  content="$2"

  mkdir -p "$(dirname -- "$target")"

  if [ -f "$target" ] && [ "$(cat "$target")" = "$content" ]; then
    printf 'already configured: %s\n' "$target"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup_file "$target"
  fi

  printf '%s\n' "$content" > "$target"
  printf 'configured: %s\n' "$target"
}

copy_file() {
  source="$1"
  target="$2"

  mkdir -p "$(dirname -- "$target")"

  if [ -f "$target" ] && cmp -s "$source" "$target"; then
    printf 'already configured: %s\n' "$target"
    return
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup_file "$target"
  fi

  cp "$source" "$target"
  printf 'configured: %s\n' "$target"
}

if [ ! -f "$source_file" ]; then
  printf 'missing source file: %s\n' "$source_file" >&2
  exit 1
fi

copy_file "$source_file" "$installed_file"
write_file "$HOME/.codex/AGENTS.md" "Read and follow the instructions in $installed_file before doing any work."
write_file "$HOME/.claude/CLAUDE.md" "@$installed_file"
