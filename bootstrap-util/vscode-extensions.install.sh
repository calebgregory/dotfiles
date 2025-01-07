#!/bin/bash

while read -r line; do
  code --install-extension "$line"
done < ~/.dotfiles/vscode-extensions.txt
