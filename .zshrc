#
# Executes commands at the start of an interactive session.
#

# Use this history file
HISTFILE=~/.zhistory

# Try to correct spelling errors
unsetopt correct

# Alias

# 'git' command for working with the dotifles bare repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
