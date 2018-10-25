#!/usr/bin bash

sudo -i

OS=linux
ARCH=amd64

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
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

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

### code editor, shell

# [install janus distrobution of vim](https://github.com/carlhuda/janus)
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
