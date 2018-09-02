# Single Install script, built for WSL.

#Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#Update/upgrade
apt-get update && apt-get -y upgrade

# Pull configuration from git
sudo apt-get install -y build-essential checkinstall git zsh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
sudo -u $SUDO_USER git clone --bare https://github.com/Sawaiz/.dotfiles.git $HOME/.dotfiles
cd $HOME
dotfiles checkout
dotfiles submodule update --init --recursive
dotfiles remote set-url origin git@github.com:Sawaiz/.dotfiles.git

# Request user to paste RSA Key
echo "Paste id_rsa" > $HOME/.ssh/id_rsa
$EDITOR ~/.ssh/id_rsa
sudo -u $SUDO_USER chmod 600 ~/.ssh/*

# Install tmux
sudo apt-get install -y libevent-dev ncurses-dev autoconf
cd /tmp
wget https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz
tar -xf tmux-2.6.tar.gz
cd tmux-2.6
./configure
make -j
make install

# Install NPM and some global node modules
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g browser-sync
sudo npm install -g browser-sync

# Install ROOT
sudo apt-get install -y build-essential checkinstall
sudo apt-get install -y dpkg-dev g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev
sudo apt-get install -y xorg
sudo apt-get install -y git
sudo apt-get install -y python-dev

## Install CMAKE
cd /tmp
wget http://www.cmake.org/files/v3.9/cmake-3.9.0.tar.gz
tar xf cmake-3.9.0.tar.gz
cd cmake-3.9.0
./configure
make -j
make install
cd ..
rm -r cmake-3.9.0.tar.gz cmake-3.9.0

## Create Install location
mkdir /usr/local/root
cd /usr/local/root

## Clone and build
git clone http://root.cern.ch/git/root.git
cmake ./root
cmake --build . -- -j
