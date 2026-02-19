#
# Executes commands at the start of an interactive session.
#


# Change Term
export TERM=tmux-256color

# Set title as the location
precmd () {print -Pn "\e]0;$(whoami)@$(hostname):${PWD/#${HOME}/~}\a"}


# Start a tmux session if installed
if command -v tmux>/dev/null; then
  [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
fi

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

# Use this history file
HISTFILE=~/.zhistory

# Set the dircolors
eval `dircolors ~/.dircolors`

# Set the prompts
# %B%(?..[%?] )%b - Bold error return value
# %D{%H:%M}       - Time, 24h with leading zeros
# %B%(!.#.>)%b    - Bold, has if privlaged, > otherwise
PROMPT='%B%(?..[%?] )%b%F{96}%D{%H:%M}%f%F{136}%B%(!.#.>)%b%f '
RPROMPT='%F{103}%~%f'

# Alias: 'git' command for working with the dotfiles bare repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Autocomplete
source ~/.zim/modules/autosuggestions/external/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=TRUE
ZSH_AUTOSUGGEST_MANUAL_REBIND=TRUE
bindkey '^\n' autosuggest-execute

# Atuin Shell History (Cross-mac sync and sqlight database)
eval "$(atuin init zsh)"

