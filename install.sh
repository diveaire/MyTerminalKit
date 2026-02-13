#!/bin/bash

# ============================================================================
#  MyTerminalKit — Interactive Terminal Setup
# ============================================================================
#  One script to set up a beautiful, productive terminal environment.
#  Works on macOS and Linux (Debian/Ubuntu, Fedora, Arch, openSUSE, Alpine).
#
#  Usage:
#    git clone https://github.com/diveaire/MyTerminalKit.git
#    cd MyTerminalKit && chmod +x install.sh && ./install.sh
# ============================================================================

set -euo pipefail

# Resolve project root (works even when called via a symlink)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SCRIPT_DIR

# Source modules
source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/scripts/tools.sh"
source "$SCRIPT_DIR/scripts/zsh.sh"
source "$SCRIPT_DIR/scripts/neovim.sh"

# ============================================================================
#  Banner
# ============================================================================

echo ""
echo -e "${BOLD}${CYAN}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║        MyTerminalKit  Installer          ║"
echo "  ║    Beautiful terminal in one command      ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"

# ============================================================================
#  Environment Detection
# ============================================================================

detect_os

# ── Prerequisites ───────────────────────────────────────────────────────────

header "Prerequisites"

if [ "$OS_TYPE" = "macos" ]; then
    install_homebrew
fi

install_curl
install_git
install_unzip
pkg_update

# ============================================================================
#  Component Selection
# ============================================================================

header "What would you like to install?"

INSTALL_ZSH=false
INSTALL_OHMYZSH=false
INSTALL_P10K=false
INSTALL_PLUGINS=false
INSTALL_COLORLS=false
INSTALL_NEOVIM=false
INSTALL_LAZYVIM=false
INSTALL_CONFIG=false

if ask_yes_no "1. Zsh shell"; then
    INSTALL_ZSH=true
fi

if ask_yes_no "2. Oh My Zsh framework"; then
    INSTALL_OHMYZSH=true
fi

if [ "$INSTALL_OHMYZSH" = true ]; then
    if ask_yes_no "   2a. Powerlevel10k theme"; then
        INSTALL_P10K=true
    fi
    if ask_yes_no "   2b. Zsh plugins (autosuggestions + syntax-highlighting)"; then
        INSTALL_PLUGINS=true
    fi
fi

if ask_yes_no "3. colorls (Ruby-based ls with colors & icons)"; then
    INSTALL_COLORLS=true
fi

if ask_yes_no "4. Neovim"; then
    INSTALL_NEOVIM=true
fi

if [ "$INSTALL_NEOVIM" = true ]; then
    if ask_yes_no "   4a. LazyVim (full Neovim IDE layer)"; then
        INSTALL_LAZYVIM=true
    fi
fi

if [ "$INSTALL_OHMYZSH" = true ]; then
    if ask_yes_no "5. Deploy MyTerminalKit .zshrc & .p10k.zsh config files"; then
        INSTALL_CONFIG=true
    fi
fi

# ============================================================================
#  Installation
# ============================================================================

header "Installing selected components"

if [ "$INSTALL_ZSH" = true ]; then install_zsh; fi
if [ "$INSTALL_OHMYZSH" = true ]; then install_ohmyzsh; fi
if [ "$INSTALL_P10K" = true ]; then install_powerlevel10k; fi
if [ "$INSTALL_PLUGINS" = true ]; then install_zsh_plugins; fi
if [ "$INSTALL_COLORLS" = true ]; then install_colorls; fi

if [ "$INSTALL_NEOVIM" = true ]; then
    install_neovim
    if [ "$INSTALL_LAZYVIM" = true ]; then
        install_lazyvim_deps
        install_lazyvim
    fi
fi

if [ "$INSTALL_CONFIG" = true ]; then deploy_zsh_config; fi
if [ "$INSTALL_ZSH" = true ]; then set_default_shell_zsh; fi

# ============================================================================
#  Summary
# ============================================================================

header "Done!"

echo -e "${GREEN}Installed components:${NC}"
if [ "$INSTALL_ZSH" = true ]; then echo -e "  ${GREEN}✓${NC} Zsh"; fi
if [ "$INSTALL_OHMYZSH" = true ]; then echo -e "  ${GREEN}✓${NC} Oh My Zsh"; fi
if [ "$INSTALL_P10K" = true ]; then echo -e "  ${GREEN}✓${NC} Powerlevel10k"; fi
if [ "$INSTALL_PLUGINS" = true ]; then echo -e "  ${GREEN}✓${NC} Zsh plugins (autosuggestions, syntax-highlighting)"; fi
if [ "$INSTALL_COLORLS" = true ]; then echo -e "  ${GREEN}✓${NC} colorls"; fi
if [ "$INSTALL_NEOVIM" = true ]; then echo -e "  ${GREEN}✓${NC} Neovim"; fi
if [ "$INSTALL_LAZYVIM" = true ]; then echo -e "  ${GREEN}✓${NC} LazyVim"; fi
if [ "$INSTALL_CONFIG" = true ]; then echo -e "  ${GREEN}✓${NC} Shell configuration (.zshrc + .p10k.zsh)"; fi

echo ""
info "Restart your terminal or run 'exec zsh' to apply changes."
if [ "$INSTALL_P10K" = true ] && [ "$INSTALL_CONFIG" != true ]; then
    info "Run 'p10k configure' to set up the Powerlevel10k prompt."
fi
echo ""
