#!/usr/bin bash

### symlink dotfiles (whitelist-style, to prevent accidents)

cd $HOME
rm ~/.zshrc # has to be removed for symlink
ln -s ~/.dotfiles/.{aliases,emacs.d,exports,functions,gitconfig,git-credentials,gvimrc.after,path,tmux.conf,vimrc.after,zshrc} ~
