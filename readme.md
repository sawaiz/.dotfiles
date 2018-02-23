# Dotfiles
Dotfiles are files, houesed in the users home directory, that are used by programsto configure themselves.

## Setup
This uses a bare git repository. This allows no symlinks and easier configuration and updates. But it comes at a cost, therefore special precaustions must be taken to initailise and 
manage it.

Temporarily assign the dotfiles alias
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
Clone the bare repository
```bash
git clone --bare <git-repo-url> $HOME/.dotfiles
```
And then checkout the files, any errors might be duplicates of files in therepo, they will need to be removed, and then rerun.
```bash
dotfiles checkout
```
And pull any submouldes you have
```bash
dotfiles submodule update --init --recursive
```

### Cygwin Tips
Changing the home directory to the windows profile directory
```bash
mkpasswd -l -d -p "$(cygpath -H)" > /etc/passwd
mkgroup -l -d > /etc/group
```
Change shell (chsh) command doesnt exist, bit this sed script will work to change your defulat shell to zsh
```bash
sed -i "s/$USER\:\/bin\/bash/$USER\:\/bin\/zsh/g" /etc/passwd
```
### Windows Subsystem for Linux (WSL)
If you are running in a windows enviroment, WSL is an option for your linux shell.

#### Installation
Install windows subsytem for linux (WSL). and [wsltty](https://github.com/mintty/wsltty). Then in a bash session, run
```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y build-essential checkinstall git zsh
```
Now we have the prerequsites, begin importing this as a bare repository
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare https://github.com/Sawaiz/.dotfiles.git $HOME/.dotfiles
dotfiles checkout
dotfiles submodule update --init --recursive
dotfiles remote set-url origin git@github.com:Sawaiz/.dotfiles.git
```
Change presmission on ssh folder... after adding your own `id_rsa` file.
```bash
nano ~/.ssh/id_rsa
chmod 600 ~/.ssh/*
```
In the shortcuts, change the config directory command, to point to the correct config file `-c "%LOCALAPPDATA%\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs\home\sawaiz\.minttyrc"` and change the default shell from `/bin/bash` to `/bin/zsh`.

Install Xming as the X-Windows server and copy its shortcut to the `shell:startup` folder.

## Applications
Command for installing all the applicaitons below.
`sudo apt-get install -y git zsh nano tmux`

### Source Control
I dont think this requres an explation, seeing as we this is.

### Text Editor
Nano, nice, quick, and simple. This has a submodule with pretty good syntax highlighting, and a lot of languages.

### Shell
ZSH, 

### tmux
Terminal multiplexer, I use chrome shortcuts as well as alt arrowkeys, those are included in the .tmux.config file. It requires a version 2.1+, here are instruction for compiling 2.5 form source.
```bash
sudo apt-get install -y libevent-dev ncurses-dev autoconf
wget https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5.tar.gz
tar -xf tmux-2.5.tar.gz
cd tmux-2.5
./configure
make -j8
make install
```

### Cern ROOT
Software for nuclear physics data processing. Its built to work with large data sets, and to be fast. Installation is somewhat complex due to some dependencies and no actual instalation, just havinga compiled toolset.
#### Perp work
```bash
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y build-essential checkinstall
sudo apt-get install -y dpkg-dev g++ gcc binutils libx11-dev libxpm-dev libxft-dev libxext-dev
sudo apt-get install -y xorg
sudo apt-get install -y git
```
#### Install CMAKE
```bash
wget http://www.cmake.org/files/v3.9/cmake-3.9.0.tar.gz
tar xf cmake-3.9.0.tar.gz
cd cmake-3.9.0
./configure
make -j8
make install
cd ..
rm -r cmake-3.9.0.tar.gz cmake-3.9.0
```
#### Create install location
```bash
mkdir /usr/local/root
cd /usr/local/root
```
#### Clone source
```bash
git clone http://root.cern.ch/git/root.git
cmake ./root
cmake --build . -- -j8
```
