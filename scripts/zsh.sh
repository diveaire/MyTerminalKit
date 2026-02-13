#!/bin/bash

# ============================================================================
# MyTerminalKit - Zsh / Oh My Zsh / Powerlevel10k / Plugins
# ============================================================================

install_zsh() {
    header "Zsh"

    if cmd_exists zsh; then
        success "Zsh is already installed."
        return
    fi

    info "Installing Zsh..."
    pkg_install zsh
    success "Zsh installed."
}

install_ohmyzsh() {
    header "Oh My Zsh"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        success "Oh My Zsh is already installed."
        return
    fi

    if ! cmd_exists curl && ! cmd_exists wget; then
        error "curl or wget is required to install Oh My Zsh."
        return 1
    fi

    info "Installing Oh My Zsh (unattended — no new shell will be spawned)..."

    # RUNZSH=no  → prevents oh-my-zsh from launching a new zsh session
    # CHSH=no    → prevents automatic shell change (we handle it later)
    if cmd_exists curl; then
        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            "" --unattended
    else
        RUNZSH=no CHSH=no sh -c \
            "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            "" --unattended
    fi

    if [ -d "$HOME/.oh-my-zsh" ]; then
        success "Oh My Zsh installed."
    else
        error "Oh My Zsh installation failed."
        return 1
    fi
}

install_powerlevel10k() {
    header "Powerlevel10k Theme"

    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    if [ -d "$p10k_dir" ]; then
        success "Powerlevel10k is already installed."
        return
    fi

    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    success "Powerlevel10k installed."
}

install_zsh_plugins() {
    header "Zsh Plugins"

    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ -d "$custom_dir/plugins/zsh-autosuggestions" ]; then
        success "zsh-autosuggestions already installed."
    else
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$custom_dir/plugins/zsh-autosuggestions"
        success "zsh-autosuggestions installed."
    fi

    # zsh-syntax-highlighting
    if [ -d "$custom_dir/plugins/zsh-syntax-highlighting" ]; then
        success "zsh-syntax-highlighting already installed."
    else
        info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$custom_dir/plugins/zsh-syntax-highlighting"
        success "zsh-syntax-highlighting installed."
    fi
}

deploy_zsh_config() {
    header "Shell Configuration"

    local config_dir="$SCRIPT_DIR/configs"

    # .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        local backup="$HOME/.zshrc.bak.$(date +%Y%m%d%H%M%S)"
        warn "Backing up existing .zshrc → $backup"
        cp "$HOME/.zshrc" "$backup"
    fi
    info "Deploying .zshrc..."
    cp "$config_dir/.zshrc" "$HOME/.zshrc"
    success ".zshrc deployed."

    # .p10k.zsh — only if a default config ships with the project
    if [ -f "$config_dir/.p10k.zsh" ]; then
        if [ -f "$HOME/.p10k.zsh" ]; then
            local backup="$HOME/.p10k.zsh.bak.$(date +%Y%m%d%H%M%S)"
            warn "Backing up existing .p10k.zsh → $backup"
            cp "$HOME/.p10k.zsh" "$backup"
        fi
        info "Deploying .p10k.zsh..."
        cp "$config_dir/.p10k.zsh" "$HOME/.p10k.zsh"
        success ".p10k.zsh deployed."
    else
        info "No default .p10k.zsh shipped. Run 'p10k configure' to generate one."
    fi
}

set_default_shell_zsh() {
    if [ "$(basename "$SHELL")" = "zsh" ]; then
        success "Zsh is already the default shell."
        return
    fi

    if ask_yes_no "Set Zsh as your default shell?"; then
        local zsh_path
        zsh_path="$(which zsh)"
        info "Changing default shell to $zsh_path..."
        if chsh -s "$zsh_path" 2>/dev/null; then
            success "Default shell changed to Zsh."
        else
            warn "Could not change shell automatically. Run manually: chsh -s $zsh_path"
        fi
    fi
}
