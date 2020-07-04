#!/bin/bash
# Single Install script, built for WSL.

#Check if running as root
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

#Update/upgrade
apt-get update && apt-get -y upgrade

# Install packages
sudo apt-get install -y build-essential checkinstall git zsh tmux

# Run commands as user
sudo -u "$SUDO_USER" -i /bin/bash - <<-'EOF'
  # Pull configuration from git
  git clone --bare https://github.com/Sawaiz/.dotfiles.git $HOME/.dotfiles
  cd $HOME
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME submodule update --init --recursive
  /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote set-url origin git@github.com:Sawaiz/.dotfiles.git
  # Request user to paste RSA Key
  mkdir -p $HOME/.ssh
  echo "Replace with id_rsa" > $HOME/.ssh/id_rsa
  chmod 600 $HOME/.ssh/*
EOF

# Finished and instrucitons
echo "Installation finsihed, add your RSA key in ~/.ssh/id_rsa"
