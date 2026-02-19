# macOS Dotfiles

This repository houses dotfiles specifically tailored and optimized for an Apple Silicon (M3) macOS environment. It uses a bare git repository approach to manage configuration files without the need for symlinks.

## Quick Installation

To bootstrap a new macOS environment, run the following command in your terminal. This command downloads and executes the installation script, which will install Homebrew, configure prerequisites, and clone the dotfiles.

```bash
curl -fsSL https://raw.githubusercontent.com/Sawaiz/.dotfiles/master/.install.sh | bash
```

**Note:** The script will halt if you do not have Apple Command Line Tools installed. Follow the GUI prompt to install them, then re-run the script.

## Core Features

*   **Ultra Robust Setup:** The installation script contains strict error-checking, verifies dependencies before installing them (like `brew`), and implements a safe conflict resolution system natively. If you have existing dotfiles (e.g., an old `.zshrc`), the script will automatically move them into a timestamped backup directory (e.g., `~/.dotfiles-backup-20231025_143000`) before deploying.
*   **Solarized Dark:** The installation script natively launches and applies the patched Solarized Dark `.terminal` profile to your macOS Terminal.app.
*   **Zsh & Zimfw:** Fast and modular Zsh framework, optimized for typing speed.
*   **Atuin:** Syncs, encrypts, and backs up your shell history securely using a local SQLite database. Access the powerful interactive search via `Ctrl+R`.
*   **Tmux:** Configured with modern keybindings (Alt+Arrows for pane switching) and native macOS clipboard integration.
*   **Nano:** Enhanced syntax highlighting for editing files.
*   **Homebrew Integration:** Automatically sets up the brew environment and integrates GNU coreutils (for vibrant `dircolors`).

## Manual Setup Steps (Post-Install)

After the automated script finishes, there is one manual step required:

### SSH Keys
You must manually add your private SSH key to securely authenticate with GitHub and other services.

```bash
nano ~/.ssh/id_rsa
# Paste your private key here, save and exit
chmod 600 ~/.ssh/id_rsa
```

## Bare Git Workflow

Since this is a bare repository, we use a special Git alias to interact with it safely without affecting other git repositories in your home directory. The alias is already configured in your `.zshrc`.

```bash
# The alias acts exactly like the standard 'git' command
dotfiles status
dotfiles add .zshrc
dotfiles commit -m "Update zsh config"
dotfiles push
```
