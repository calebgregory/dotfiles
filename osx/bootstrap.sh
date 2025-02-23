#!/usr/bin/bash

mkdir ~/tmp
cd ~/tmp || exit

# [install homebrew](https://brew.sh/)
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

utils=(
  git

  # for janus vim distro
  ack
  ctags
  gvim
  vim
  rbenv

  # for python version management
  pyenv
  # for ruby version management
  rbenv

  # other utils
  wget
  jq
  tmux
  the_silver_searcher # [](https://github.com/ggreer/the_silver_searcher)
  tree
)
for u in "${utils[@]}"; do
  brew install "$u"
done

# setup python
eval "$(pyenv init --path)"
pyenv install 3.12.2
pyenv global 3.12.2
echo "installed python; current version = $(python -V)"
pip install poetry pre-commit boto3 warrant pytest stacker

# [install lein for clj things](https://leiningen.org/#install), adding it to path and making it executable
curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o ~/.local/bin/lein
chmod 744 ~/.local/bin/lein
lein

# [install nodejs using nvm](https://github.com/nvm-sh/nvm)
NVM_VERSION="0.40.1"
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh" | bash

# [install aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-install-cmd-all-users)
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# setup ruby
eval "$(rbenv init -)"
rbenv install 2.7.5
rbenv global 2.7.5

# [install macvim](https://github.com/carlhuda/janus)
sudo gem install rake # [](https://github.com/carlhuda/janus#pre-requisites)
brew install macvim # needs to be installed AFTER python
curl -L https://bit.ly/janus-bootstrap | bash

# install [zsh with oh-my-zsh framework](https://github.com/robbyrussell/oh-my-zsh)
sudo dnf install -y zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

# [clone this repository]()
git clone git@github.com:calebgregory/dotfiles.git ~/.dotfiles

cd ~/.dotfiles || exit 1
touch .extra .secrets
bash ./bootstrap-util/symlink-dotfiles.sh

# clean up

rm -rf ~/tmp/
