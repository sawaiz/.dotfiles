#!/bin/bash
# Single Install script, built for WSL.

#Check if running as root
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run as root"
  exit
fi

#Update/upgrade
apt-get update && apt-get -y upgrade

# Pull configuration from git
sudo apt-get install -y build-essential checkinstall git zsh
sudo -u $SUDO_USER git clone --bare https://github.com/Sawaiz/.dotfiles.git $HOME/.dotfiles
cd $HOME
sudo -u $SUDO_USER /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
sudo -u $SUDO_USER /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME submodule update --init --recursive
sudo -u $SUDO_USER /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME remote set-url origin git@github.com:Sawaiz/.dotfiles.git

# Install tmux
sudo apt-get install -y tmux

# Request user to paste RSA Key
sudo -u $SUDO_USER mkdir -p $HOME/.ssh
sudo -u $SUDO_USER echo "Replace with id_rsa" > $HOME/.ssh/id_rsa
sudo -u $SUDO_USER chmod 600 $HOME/.ssh/*

# Finished and instrucitons
echo "Installation finsihed, add your RSA key in ~/.ssh/id_rsa"
