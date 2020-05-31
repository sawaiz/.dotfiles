#
# Executes commands at the start of an interactive session.
#


#Change Term
export TERM=tmux-256color

# Figure out if the session is ssh or local
if [ -n $SSH_CLIENT ] || [ -n $SSH_TTY ]; then
  SESSION_SSH=TRUE
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_SSH=TRUE;;
  esac
fi


# Set title as the location
precmd () {print -Pn "\e]0;$(whoami)@$(hostname):${PWD/#${HOME}/~}\a"}


# Start a tmux session if installed and not running and in local session
if command -v tmux>/dev/null || [ -z $SESSION_SSH ]; then
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

# Setup ssh-agent, use existing one is it exists, only on local sessions
if [ -z $SSH_AUTH_SOCK ] && [ -n $SESSION_SSH ]; then
    if [ -r ~/.ssh/env ]; then
            source ~/.ssh/env
            if [ `ps -p $SSH_AGENT_PID | wc -l` = 1 ]; then
                    rm ~/.ssh/env
                    unset SSH_AUTH_SOCK
            fi
    fi
fi

if [ -z $SSH_AUTH_SOCK ] && [ -n $SESSION_SSH ]; then
    ssh-agent -s | sed 's/^echo/#echo/'> ~/.ssh/env
    chmod 600 ~/.ssh/env 1> /dev/null
    source ~/.ssh/env > /dev/null 2>&1
fi

# Set the prompts
# %B%(?..[%?] )%b - Bold error return value
# %D{%H:%M}       - Time, 24h with leading zeros
# %B%(!.#.>)%b    - Bold, has if privlaged, > otherwise
PROMPT='%B%(?..[%?] )%b%F{96}%D{%H:%M}%f%F{136}%B%(!.#.>)%b%f '
RPROMPT='%F{103}%~%f'

# Source Root
if [ -f /usr/local/root/bin/thisroot.sh ]; then
    source /usr/local/root/bin/thisroot.sh
fi

# Source Geant4
if [ -f /usr/local/geant4/bin ]; then
    cd /usr/local/geant4/bin
    source geant4.sh
    cd ~
fi

# Connect to xMing
export DISPLAY=:0

# Alias: 'git' command for working with the dotifles bare repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Autocomplete
source ~/.zim/modules/autosuggestions/external/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=TRUE
ZSH_AUTOSUGGEST_MANUAL_REBIND=TRUE
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd
bindkey '^\n' autosuggest-execute
