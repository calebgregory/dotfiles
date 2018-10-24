sudo -i

OS=linux
ARCH=amd64

# install git
dnf install -y git

echo "installed git"
which git

# applications

# [install Google Chrome](https://www.if-not-true-then-false.com/2010/install-google-chrome-with-yum-on-fedora-red-hat-rhel/)
dnf install -y fedora-workstation-repositories
dnf config-manager --set-enabled google-chrome
dnf install -y google-chrome-stable

# software development

# [install Golang](https://golang.org/dl/)
GO_VERSION="1.11.1"
GO_ARCHIVE="go$GO_VERSION.$OS-$ARCH.tar.gz"

wget https://dl.google.com/go/$GO_ARCHIVE
tar -C /usr/local -xzf $GO_ARCHIVE

# # install puppet
#   # add to registry https://puppet.com/docs/puppet/6.0/puppet_platform.html
# sudo rpm -Uvh https://yum.puppet.com/puppet6/puppet6-release-fedora-27.noarch.rpm
#   # install puppet-agent https://puppet.com/docs/puppet/5.4/install_linux.html
# sudo dnf install -y puppet-agent
#
# # PATH="/opt/puppetlabs/bin:$PATH"
#
# echo "installed puppet"
#
# ls -la /opt/puppetlabs/bin
#
# echo "starting puppet service"
#
# sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
#
# git clone https://github.com/calebgregory/manifests /etc/puppetlabs/code/environments/production
#
# sudo /opt/puppetlabs/bin/puppet puppet apply

# ln -sv ~/.dotfiles/.{aliases,exports,functions,gitconfig,path,zshrc,gvimrc.after,vimrc.after,tmux.conf} ~
