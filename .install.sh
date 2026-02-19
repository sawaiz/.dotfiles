#!/bin/bash
# macOS M3 Air Dotfiles Bootstrap Script

echo "Starting macOS Dotfiles Installation..."

# 1. Install Apple Command Line Tools (required for git and homebrew)
if ! xcode-select -p &>/dev/null; then
    echo "Installing macOS Command Line Tools..."
    xcode-select --install
    echo "Please complete the Command Line Tools installation dialog, then re-run this script."
    exit 1
fi

# 2. Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Temporarily add brew to path for this script so subsequent commands work
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 3. Install required packages
echo "Installing brew packages..."
brew install git tmux nano coreutils

# 4. Initialize Bare Git Repository
echo "Setting up bare git repository..."

DOTFILES_DIR="$HOME/.dotfiles"
GIT_ALIAS="/usr/bin/git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME"

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone --bare https://github.com/Sawaiz/.dotfiles.git "$DOTFILES_DIR"
fi

echo "Checking out files..."
# Backup existing files if checkout fails
if ! $GIT_ALIAS checkout 2>/dev/null; then
    echo "Backing up pre-existing dotfiles..."
    mkdir -p "$HOME/.dotfiles-backup"
    $GIT_ALIAS checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I{} mv "$HOME/{}" "$HOME/.dotfiles-backup/{}"
    $GIT_ALIAS checkout
fi

echo "Checking out submodules..."
$GIT_ALIAS submodule update --init --recursive
$GIT_ALIAS config --local status.showUntrackedFiles no
$GIT_ALIAS remote set-url origin git@github.com:Sawaiz/.dotfiles.git

# 5. SSH Key reminder
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo ""
    echo "========================================================"
    echo "Installation finished!"
    echo "ACTION REQUIRED: Please copy your private SSH key to ~/.ssh/id_rsa"
    echo "Then run: chmod 600 ~/.ssh/id_rsa"
    echo "========================================================"
else
    echo "Installation finished!"
fi
