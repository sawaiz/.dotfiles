#
# Executes commands at the start of an interactive session.
#

# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
fi

# Use this history file
HISTFILE=~/.zhistory

# Load the ssh-agent, or use existing one.
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

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
