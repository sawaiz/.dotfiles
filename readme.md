# Dotfiles
Dotfiles are files, houesed in the users home directory, that are used by programsto configure themselves.

## Setup
This uses a bare git repository. THis allows no symlinks and easier configuration and updates. But it comes at a cost, therefore special precaustions must be taken to initailise and 
manage it.

Temporarily assign the dotfiles alias
```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
# Clone the bare repository
```bash
git clone --bare <git-repo-url> $HOME/.dotfiles
```
And then checkout the files, any errors might be duplicates of files in therepo, they will need to be removed, and then rerun.
```bash
dotfiles checkout
```

## Applications

### Text Editor
Nano, nice, quick, and simple. This has a submodule with pretty good syntax highlighting, and a lot of languages.

### Shell
ZSH, 
