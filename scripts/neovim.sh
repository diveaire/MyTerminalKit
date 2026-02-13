#!/bin/bash

# ============================================================================
# MyTerminalKit - Neovim + LazyVim
# ============================================================================

install_neovim() {
    header "Neovim"

    if cmd_exists nvim; then
        local version
        version="$(nvim --version | head -1)"
        success "Neovim is already installed ($version)."
        return
    fi

    info "Installing Neovim..."
    case "$PKG_MANAGER" in
        apt)    pkg_install neovim ;;
        dnf)    pkg_install neovim ;;
        yum)    pkg_install neovim ;;
        pacman) pkg_install neovim ;;
        zypper) pkg_install neovim ;;
        apk)    pkg_install neovim ;;
        brew)   pkg_install neovim ;;
    esac

    if cmd_exists nvim; then
        success "Neovim installed ($(nvim --version | head -1))."
    else
        error "Neovim installation failed."
        return 1
    fi
}

install_lazyvim_deps() {
    header "LazyVim Dependencies"

    # ripgrep — live grep in Telescope
    if cmd_exists rg; then
        success "ripgrep already installed."
    else
        info "Installing ripgrep..."
        pkg_install ripgrep
    fi

    # fd — file finder for Telescope
    if cmd_exists fd || cmd_exists fdfind; then
        success "fd already installed."
    else
        info "Installing fd..."
        case "$PKG_MANAGER" in
            apt)    pkg_install fd-find ;;
            dnf)    pkg_install fd-find ;;
            *)      pkg_install fd ;;
        esac
    fi

    # Node.js — needed by many LSP servers
    if cmd_exists node; then
        success "Node.js already installed."
    else
        info "Installing Node.js..."
        case "$PKG_MANAGER" in
            apt)    pkg_install nodejs && pkg_install npm ;;
            dnf)    pkg_install nodejs ;;
            pacman) pkg_install nodejs && pkg_install npm ;;
            brew)   pkg_install node ;;
            *)      pkg_install nodejs ;;
        esac
    fi

    # Python3 — pynvim & some LSP servers
    if cmd_exists python3; then
        success "Python3 already installed."
    else
        info "Installing Python3..."
        case "$PKG_MANAGER" in
            apt)    pkg_install python3 && pkg_install python3-pip ;;
            dnf)    pkg_install python3 && pkg_install python3-pip ;;
            pacman) pkg_install python && pkg_install python-pip ;;
            brew)   pkg_install python3 ;;
            *)      pkg_install python3 ;;
        esac
    fi

    # C compiler — required by treesitter to compile parsers
    if cmd_exists gcc || cmd_exists cc; then
        success "C compiler already installed."
    else
        info "Installing build tools..."
        case "$PKG_MANAGER" in
            apt)    pkg_install build-essential ;;
            dnf)    pkg_install gcc && pkg_install make ;;
            pacman) pkg_install base-devel ;;
            zypper) pkg_install gcc && pkg_install make ;;
            apk)    pkg_install build-base ;;
            brew)   ;; # Xcode CLI tools expected
        esac
    fi
}

install_lazyvim() {
    header "LazyVim"

    # Check for minimum Neovim version (LazyVim requires >= 0.9.0)
    if cmd_exists nvim; then
        local nvim_ver
        nvim_ver="$(nvim --version | head -1 | sed 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')"
        local nvim_major nvim_minor
        nvim_major="$(echo "$nvim_ver" | cut -d. -f1)"
        nvim_minor="$(echo "$nvim_ver" | cut -d. -f2)"
        if [ "$nvim_major" -eq 0 ] && [ "$nvim_minor" -lt 9 ] 2>/dev/null; then
            warn "Neovim $nvim_ver detected. LazyVim requires >= 0.9.0."
            warn "Consider installing a newer Neovim manually."
            if ! ask_yes_no "Continue anyway?"; then
                return 1
            fi
        fi
    fi

    # If config already exists, ask before overwriting
    if [ -d "$HOME/.config/nvim" ]; then
        warn "Existing Neovim config found at ~/.config/nvim"
        if ! ask_yes_no "Back up existing config and install LazyVim?"; then
            info "Skipping LazyVim installation."
            return
        fi

        local suffix
        suffix="$(date +%Y%m%d%H%M%S)"
        info "Backing up existing Neovim data..."
        if [ -d "$HOME/.config/nvim" ]; then mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$suffix"; fi
        if [ -d "$HOME/.local/share/nvim" ]; then mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak.$suffix"; fi
        if [ -d "$HOME/.local/state/nvim" ]; then mv "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak.$suffix"; fi
        if [ -d "$HOME/.cache/nvim" ]; then mv "$HOME/.cache/nvim" "$HOME/.cache/nvim.bak.$suffix"; fi
    fi

    info "Cloning LazyVim starter template..."
    git clone --depth=1 https://github.com/LazyVim/starter "$HOME/.config/nvim"
    rm -rf "$HOME/.config/nvim/.git"

    info "Running headless plugin sync (this may take a moment)..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

    success "LazyVim installed. Run 'nvim' to finish setup."
}
