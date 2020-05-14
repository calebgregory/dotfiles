#!/usr/bin bash

mkdir ~/tmp
cd ~/tmp

# [install homebrew](https://brew.sh/)
# curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

utils=(
  git

  # for janus vim distro
  ack
  ctags
  gvim
  vim
  ruby

  # other utils
  wget
  jq
  tmux
  the_silver_searcher # [](https://github.com/ggreer/the_silver_searcher)
)
for u in $utils; do
  brew install "$u"
done

# [install python, use miniconda to manage python versions](https://docs.conda.io/en/latest/miniconda.html)
# [installation instructions](https://conda.io/projects/conda/en/latest/user-guide/install/macos.html)
# echo "!!! Answer no to question about running 'conda init' !!!"
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O ~/miniconda.sh
# bash ~/miniconda.sh -p $HOME/miniconda
# source ~/miniconda/bin/activate; conda init zsh

# [install nodejs using nvm](https://github.com/nvm-sh/nvm)
NVM_VERSION="0.35.3"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh" | bash

# [install aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-install-cmd-all-users)
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# [install macvim](https://github.com/carlhuda/janus)
sudo gem install rake # [](https://github.com/carlhuda/janus#pre-requisites)
brew install macvim # needs to be installed AFTER python
curl -L https://bit.ly/janus-bootstrap | bash

# install [zsh with oh-my-zsh framework](https://github.com/robbyrussell/oh-my-zsh)
sudo dnf install -y zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

# [clone this repository]()
git clone git@github.com:calebgregory/dotfiles.git ~/.dotfiles

cd ~/.dotfiles
bash ./bootstrap-util/symlink-dotfiles.sh

# clean up

rm -rf ~/tmp/
