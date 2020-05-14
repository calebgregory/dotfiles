#!/usr/bin bash

### symlink dotfiles (whitelist-style, to prevent accidents)

cd $HOME
rm ~/.zshrc # has to be removed for symlink
ln -s ~/.dotfiles/.{aliases,exports,functions,gitconfig,gvimrc.after,path,tmux.conf,vimrc.after,zshrc} ~
