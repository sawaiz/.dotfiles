#!/bin/bash
# macOS M3 Air Dotfiles Bootstrap Script (Ultra Robust)

set -e

# --- UI Helpers ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

echo "========================================================"
info "Starting macOS Dotfiles Installation..."
echo "========================================================"

# --- 1. Apple Command Line Tools ---
if ! xcode-select -p &>/dev/null; then
    warn "macOS Command Line Tools not found. Initiating installation..."
    xcode-select --install
    error "Please complete the GUI installation dialog, then re-run this script."
else
    success "macOS Command Line Tools are installed."
fi

# --- 2. Homebrew ---
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error "Homebrew installation failed."
    
    # Temporarily add brew to path for this script so subsequent commands work
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        error "Could not locate Homebrew binary dynamically."
    fi
else
    success "Homebrew is already installed."
fi

# Ensure brew is updated and working
info "Updating Homebrew..."
brew update || warn "Brew update failed, continuing anyway..."

# --- 3. Packages ---
info "Verifying required Homebrew packages..."
for pkg in git tmux nano coreutils; do
    if brew list -1 | grep -q "^${pkg}\$"; then
        success "$pkg is already installed."
    else
        info "Installing $pkg..."
        brew install "$pkg" || error "Failed to install $pkg via Homebrew."
    fi
done

# --- 4. Bare Git Repository Initialization ---
info "Setting up bare git repository..."

DOTFILES_DIR="$HOME/.dotfiles"
GIT_ALIAS="/usr/bin/git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME"

if [ ! -d "$DOTFILES_DIR" ]; then
    info "Cloning repository..."
    git clone --bare https://github.com/Sawaiz/.dotfiles.git "$DOTFILES_DIR" || error "Failed to clone bare repository."
else
    success "$DOTFILES_DIR already exists."
fi

# --- 5. Checkout & Conflict Resolution ---
info "Checking out dotfiles..."

# Backup existing files if checkout fails due to conflicts
if ! $GIT_ALIAS checkout 2>/dev/null; then
    warn "Conflicts detected with existing files. Backing up..."
    
    # Generate timestamped backup directory
    BACKUP_TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_DIR="$HOME/.dotfiles-backup-$BACKUP_TIMESTAMP"
    mkdir -p "$BACKUP_DIR"
    
    # Parse conflicting files and move them gracefully
    $GIT_ALIAS checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | while read -r file; do
        if [ -f "$HOME/$file" ] || [ -d "$HOME/$file" ]; then
            info "Moving conflicting $file to $BACKUP_DIR"
            # Ensure subdirectory structure exists in backup
            mkdir -p "$BACKUP_DIR/$(dirname "$file")"
            mv "$HOME/$file" "$BACKUP_DIR/$file"
        fi
    done
    
    # Try checkout again
    if $GIT_ALIAS checkout 2>/dev/null; then
        success "Checkout completed successfully after backing up conflicting files."
    else
        error "Git checkout failed even after backing up. Please check the repository state."
    fi
else
    success "Checkout completed cleanly."
fi

# --- 6. Submodules and Config ---
info "Updating submodules..."
$GIT_ALIAS submodule update --init --recursive || warn "Submodule update reported an issue."

info "Applying repository configs..."
$GIT_ALIAS config --local status.showUntrackedFiles no
$GIT_ALIAS remote set-url origin git@github.com:Sawaiz/.dotfiles.git

# --- 7. SSH Key Reminder ---
echo "========================================================"
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    warn "ACTION REQUIRED: SSH Key is missing!"
    echo -e "Please copy your private SSH key to ${BLUE}~/.ssh/id_rsa${NC}"
    echo -e "Then run: ${YELLOW}chmod 600 ~/.ssh/id_rsa${NC}"
else
    success "SSH Key found."
fi

success "Installation finished! Restart your terminal to see the changes."
echo "========================================================"
