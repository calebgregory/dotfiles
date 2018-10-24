# install git
sudo dnf install -y git

echo "installed git"
which git

# install puppet
  # add to registry https://puppet.com/docs/puppet/6.0/puppet_platform.html
sudo rpm -Uvh https://yum.puppet.com/puppet6/puppet6-release-fedora-27.noarch.rpm
  # install puppet-agent https://puppet.com/docs/puppet/5.4/install_linux.html
sudo dnf install -y puppet-agent

# PATH="/opt/puppetlabs/bin:$PATH"

echo "installed puppet"

ls -la /opt/puppetlabs/bin

echo "starting puppet service"

sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

git clone https://github.com/calebgregory/manifests /etc/puppetlabs/code/environments/production

# ln -sv ~/.dotfiles/.{aliases,exports,functions,gitconfig,path,zshrc,gvimrc.after,vimrc.after,tmux.conf} ~
