#!/usr/bin bash

OS=linux
ARCH=amd64

sudo -i

mkdir ~/tmp/
cd ~/tmp/

### primary dependencies

dnf install -y git

### applications

# [install Google Chrome](https://www.if-not-true-then-false.com/2010/install-google-chrome-with-yum-on-fedora-red-hat-rhel/)
dnf install -y fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome
dnf install -y google-chrome-stable

### languages

# [install Golang](https://golang.org/dl/)
GO_VERSION="1.11.1"
GO_ARCHIVE="go$GO_VERSION.$OS-$ARCH.tar.gz"

wget "https://dl.google.com/go/$GO_ARCHIVE"
tar -C /usr/local -xzf "$GO_ARCHIVE"

# [install nodejs using nvm](https://github.com/creationix/nvm#install-script)
#   must
#     nvm install <version>
#     nvm use <version>
#   before node or npm are available
NVM_VERSION="0.33.11"
curl -o- "https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh" | bash

### infrastructural tools

# [install Docker](https://docs.docker.com/install/linux/docker-ce/fedora/#install-docker-ce)
dnf install -y dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce

# [install awscli](https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-bundle.html)
dnf install -y python
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# [install terraform](https://www.terraform.io/downloads.html)
TERRAFORM_VERSION="0.11.10"
TERRAFORM_ARCHIVE="$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_${OS}_${ARCH}.zip"

wget "https://releases.hashicorp.com/terraform/$TERRAFORM_ARCHIVE"
unzip "$TERRAFORM_ARCHIVE"
mv ./terraform /usr/local/bin

# [install virtualbox](https://medium.com/@Joachim8675309/vagrant-and-friends-on-fedora-28-37b8cbc47e47)

  # download virtualbox.repo file for yum
wget -P /etc/yum.repos.d/ https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
dnf update -y
  # install kernel development packages
dnf install -y \
  binutils \
  gcc \
  make \
  patch \
  libgomp \
  glibc-headers \
  glibc-devel \
  kernel-headers \
  kernel-devel \
  dkms
  # install/setup VirtualBox 5.2.x
dnf install -y VirtualBox-5.2
/usr/lib/virtualbox/vboxdrv.sh setup
  # test version
vboxmanage --version
  # enable current user
usermod -a -G vboxusers ${USER}

# [install vagrant](https://medium.com/@Joachim8675309/vagrant-and-friends-on-fedora-28-37b8cbc47e47)
VAGRANT_VERSION="2.2.0"
VAGRANT_ARCHIVE="vagrant_${VAGRANT_VERSION}_${OS}_${ARCH}.zip"
wget "https://releases.hashicorp.com/vagrant/$VAGRANT_VERSION/$VAGRANT_ARCHIVE"
unzip "$VAGRANT_ARCHIVE"
mv ./vagrant /usr/local/bin

### code editor, shell

# [install janus distribution of vim](https://github.com/carlhuda/janus)
dnf install -y ack
dnf install -y ctags
dnf install -y gvim
dnf install -y ruby
gem install rake
curl -L https://bit.ly/janus-bootstrap | bash

# install tmux
dnf install -y tmux

# install [zsh with oh-my-zsh framework](https://github.com/robbyrussell/oh-my-zsh)
dnf install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# [install the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
dnf install -y the_silver_searcher

### download dotfiles

git clone https://github.com/calebgregory/dotfiles ~/.dotfiles

### symlink dotfiles (whitelist-style, to prevent accidents)

ln -s ~/.dotfiles/.{aliases,exports,functions,gitconfig,gvimrc.after,path,tmux.conf,vimrc.after,zshrc} ~
