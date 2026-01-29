#!/bin/bash

src_dir="$HOME/.dotfiles/.claude"
target_dir="$HOME/.claude"

files=(
  'settings.json'
  'CLAUDE.md'
)

for file in "${files[@]}"; do
  src="$src_dir/$file"
  target="$target_dir/$file"

  if [[ -L "$target" ]]; then
    echo "'$target' exists and is a symbolic link (note - target might be broken)."
  else
    ln -s "$src" "$target"
    echo "created new link $src -> $target"
  fi
done
