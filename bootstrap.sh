#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     OS=Linux;;
        Darwin*)    OS=macOS;;
        *)          OS=Unknown;;
    esac
    info "Detected OS: $OS"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install stow
install_stow() {
    if command_exists stow; then
        info "GNU Stow already installed"
        return
    fi

    info "Installing GNU Stow..."
    case "$OS" in
        Linux)
            if command_exists pacman; then
                sudo pacman -S --noconfirm stow
            elif command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y stow
            elif command_exists dnf; then
                sudo dnf install -y stow
            else
                error "Unsupported Linux package manager"
                exit 1
            fi
            ;;
        macOS)
            if ! command_exists brew; then
                error "Homebrew not found. Install from https://brew.sh"
                exit 1
            fi
            brew install stow
            ;;
    esac
}

# Install oh-my-zsh
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        info "oh-my-zsh already installed"
        return
    fi

    info "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

# Install zsh plugins
install_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Powerlevel10k
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    else
        info "Powerlevel10k already installed"
    fi

    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    else
        info "zsh-autosuggestions already installed"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    else
        info "zsh-syntax-highlighting already installed"
    fi
}

# Install fzf
install_fzf() {
    if command_exists fzf; then
        info "fzf already installed"
        return
    fi

    info "Installing fzf..."
    case "$OS" in
        Linux)
            if command_exists pacman; then
                sudo pacman -S --noconfirm fzf
            elif command_exists apt-get; then
                sudo apt-get install -y fzf
            elif command_exists dnf; then
                sudo dnf install -y fzf
            fi
            ;;
        macOS)
            brew install fzf
            ;;
    esac
}

# Backup existing configs
backup_configs() {
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    local files_to_backup=(".zshrc" ".zsh-alias" ".zshrc-mine" ".p10k.zsh" ".tmux.conf" ".gitconfig")
    local needs_backup=false

    for file in "${files_to_backup[@]}"; do
        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            if [ "$needs_backup" = false ]; then
                info "Backing up existing configs to $backup_dir"
                mkdir -p "$backup_dir"
                needs_backup=true
            fi
            warn "Backing up existing $file"
            mv "$HOME/$file" "$backup_dir/"
        fi
    done

    if [ "$needs_backup" = true ]; then
        info "Backup complete at $backup_dir"
    fi
}

# Setup gitconfig.local
setup_gitconfig_local() {
    if [ -f "$HOME/.gitconfig.local" ]; then
        info ".gitconfig.local already exists"
        return
    fi

    info "Creating .gitconfig.local template..."
    cat > "$HOME/.gitconfig.local" << 'EOF'
# Local git configuration
# Add machine-specific settings here

# Example: GPG signing
# [commit]
# 	gpgsign = true
# [user]
# 	signingkey = YOUR_KEY_HERE

# Example: Credential helpers
# [credential]
# 	helper = osxkeychain  # macOS
# 	helper = cache        # Linux
EOF
    info "Edit ~/.gitconfig.local for machine-specific git settings"
}

# Run stow
run_stow() {
    local dotfiles_dir="$(cd "$(dirname "$0")" && pwd)"

    info "Stowing dotfiles from $dotfiles_dir..."
    cd "$dotfiles_dir"

    # Stow all directories
    for dir in */; do
        dir_name="${dir%/}"
        if [ "$dir_name" != ".git" ]; then
            info "Stowing $dir_name..."
            stow --verbose --target="$HOME" --restow "$dir_name"
        fi
    done
}

# Main installation
main() {
    info "Starting dotfiles bootstrap..."
    echo

    detect_os

    if [ "$OS" = "Unknown" ]; then
        error "Unsupported operating system"
        exit 1
    fi

    info "Installing dependencies..."
    install_stow
    install_fzf

    info "Setting up shell environment..."
    install_oh_my_zsh
    install_zsh_plugins

    info "Backing up existing configs..."
    backup_configs

    info "Setting up dotfiles..."
    run_stow

    info "Setting up local configs..."
    setup_gitconfig_local

    echo
    info "Bootstrap complete!"
    info "Please restart your shell or run: exec zsh"
}

main "$@"
