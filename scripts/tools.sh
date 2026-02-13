#!/bin/bash

# ============================================================================
# MyTerminalKit - Prerequisite & Extra Tools
# ============================================================================

install_curl() {
    if cmd_exists curl; then
        success "curl already installed."
        return
    fi
    info "Installing curl..."
    pkg_install curl
}

install_git() {
    if cmd_exists git; then
        success "git already installed."
        return
    fi
    info "Installing git..."
    pkg_install git
}

install_unzip() {
    if cmd_exists unzip; then
        success "unzip already installed."
        return
    fi
    info "Installing unzip..."
    pkg_install unzip
}

install_homebrew() {
    if [ "$OS_TYPE" != "macos" ]; then return; fi

    header "Homebrew"

    if cmd_exists brew; then
        success "Homebrew is already installed."
        return
    fi

    info "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for Apple Silicon Macs
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    success "Homebrew installed."
}

install_colorls() {
    header "colorls"

    if cmd_exists colorls; then
        success "colorls is already installed."
        return
    fi

    # Ruby & gem are required
    if ! cmd_exists ruby || ! cmd_exists gem; then
        info "Ruby is required for colorls. Installing..."
        case "$PKG_MANAGER" in
            apt)    pkg_install ruby-full ;;
            dnf)    pkg_install ruby && pkg_install ruby-devel ;;
            yum)    pkg_install ruby && pkg_install ruby-devel ;;
            pacman) pkg_install ruby ;;
            zypper) pkg_install ruby && pkg_install ruby-devel ;;
            apk)    pkg_install ruby && pkg_install ruby-dev ;;
            brew)   pkg_install ruby ;;
        esac
    fi

    # Dev headers for native gem extensions
    case "$PKG_MANAGER" in
        apt)
            pkg_install ruby-dev 2>/dev/null || true
            pkg_install build-essential 2>/dev/null || true
            ;;
        dnf|yum)
            pkg_install ruby-devel 2>/dev/null || true
            pkg_install gcc 2>/dev/null || true
            pkg_install make 2>/dev/null || true
            ;;
    esac

    info "Installing colorls via gem..."
    if $SUDO gem install colorls 2>/dev/null; then
        success "colorls installed."
    elif gem install colorls --user-install 2>/dev/null; then
        success "colorls installed (user-level)."
    else
        error "Failed to install colorls. You may need to install it manually: gem install colorls"
    fi
}
