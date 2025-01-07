#!/usr/bin/bash

### symlink dotfiles (whitelist-style, to prevent accidents)

cd "$HOME" || exit 1

rm ~/.zshrc # has to be removed for symlink

files_to_symlink=(
  .aliases
  .emacs.d
  .exports
  .extra
  .functions
  .git-credentials
  .gitconfig
  .gitmux.conf
  .gvimrc.after
  .path
  .secrets
  .tmux.conf
  .vimrc.after
  .zshrc
)
for file in "${files_to_symlink[@]}"; do
  ln -s ~/.dotfiles/"${file}" ~
done
