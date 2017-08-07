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
### Windows Subsystem for Linux (WSL) tips
Install mintty/wsltty so mintty settings work.
In the shortcuts, change the config directory command, to point tho the correct config file `-c "%USERPROFILE%\.minttyrc"`

## Applications

### Text Editor
Nano, nice, quick, and simple. This has a submodule with pretty good syntax highlighting, and a lot of languages.

### Shell
ZSH, 
