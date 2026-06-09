#!/usr/bin/env sh

set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file="$repo_dir/agents/personal-coding-style.md"

backup_file() {
  path="$1"
  timestamp=$(date +%Y%m%d%H%M%S)
  mv "$path" "$path.backup.$timestamp"
}

link_file() {
  target="$1"

  mkdir -p "$(dirname -- "$target")"

  if [ -L "$target" ]; then
    current=$(readlink "$target")
    if [ "$current" = "$source_file" ]; then
      printf 'already linked: %s\n' "$target"
      return
    fi
    rm "$target"
  elif [ -e "$target" ]; then
    if cmp -s "$source_file" "$target"; then
      rm "$target"
    else
      backup_file "$target"
    fi
  fi

  ln -s "$source_file" "$target"
  printf 'linked: %s -> %s\n' "$target" "$source_file"
}

if [ ! -f "$source_file" ]; then
  printf 'missing source file: %s\n' "$source_file" >&2
  exit 1
fi

link_file "$HOME/.codex/AGENTS.md"
link_file "$HOME/.claude/CLAUDE.md"
