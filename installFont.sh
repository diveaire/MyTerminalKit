#!/bin/bash

# ============================================================================
#  MyTerminalKit — Nerd Fonts Installer
# ============================================================================
#  Install Nerd Fonts on your LOCAL machine (the one running your terminal
#  emulator). You do NOT need fonts on remote servers you SSH into.
#
#  Usage:  chmod +x installFont.sh && ./installFont.sh
# ============================================================================

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"
source "$SCRIPT_DIR/scripts/tools.sh"

detect_os

# ── Font directory ──────────────────────────────────────────────────────────

FONT_DIR=""
case "$OS_TYPE" in
    macos)
        FONT_DIR="$HOME/Library/Fonts"
        ;;
    linux)
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
        ;;
    *)
        error "Unsupported OS for font installation."
        exit 1
        ;;
esac

# ── Ensure unzip is available ───────────────────────────────────────────────

install_unzip

# Ensure fc-cache is available on Linux
if [ "$OS_TYPE" = "linux" ] && ! cmd_exists fc-cache; then
    info "Installing fontconfig (provides fc-cache)..."
    pkg_install fontconfig
fi

# ── Discover available fonts ────────────────────────────────────────────────

fonts=()
for zip in "$SCRIPT_DIR"/fonts/*.zip; do
    [ -f "$zip" ] && fonts+=("$(basename "$zip" .zip)")
done

if [ ${#fonts[@]} -eq 0 ]; then
    error "No font .zip files found in $SCRIPT_DIR/fonts/"
    exit 1
fi

# ── Menu ────────────────────────────────────────────────────────────────────

header "Nerd Fonts Installer"

echo -e "${YELLOW}Note:${NC} Fonts are only needed on your ${BOLD}local machine${NC}"
echo -e "      (the one running your terminal emulator).\n"
echo -e "${BOLD}Available fonts:${NC}"

for i in "${!fonts[@]}"; do
    echo "  $((i + 1)). ${fonts[$i]}"
done
echo "  A. Install all"
echo "  0. Cancel"
echo ""

read -rp "Your choice: " choice

if [ "$choice" = "0" ]; then
    info "Cancelled."
    exit 0
fi

# ── Install function ────────────────────────────────────────────────────────

do_install_font() {
    local name="$1"
    local zip_path="$SCRIPT_DIR/fonts/${name}.zip"

    if [ ! -f "$zip_path" ]; then
        error "File not found: $zip_path"
        return 1
    fi

    info "Installing ${name}..."

    # Extract only font files (.ttf / .otf), fall back to extracting everything
    unzip -o "$zip_path" '*.ttf' '*.otf' -d "$FONT_DIR" 2>/dev/null \
        || unzip -o "$zip_path" -d "$FONT_DIR" 2>/dev/null

    # Rebuild font cache on Linux
    if [ "$OS_TYPE" = "linux" ] && cmd_exists fc-cache; then
        fc-cache -f "$FONT_DIR" 2>/dev/null
    fi

    success "${name} installed → $FONT_DIR"
}

# ── Execute ─────────────────────────────────────────────────────────────────

if [[ "$choice" =~ ^[aA]$ ]]; then
    for font in "${fonts[@]}"; do
        do_install_font "$font"
    done
else
    idx=$((choice - 1))
    if [ "$idx" -ge 0 ] 2>/dev/null && [ "$idx" -lt "${#fonts[@]}" ] 2>/dev/null; then
        do_install_font "${fonts[$idx]}"
    else
        error "Invalid choice."
        exit 1
    fi
fi

echo ""
success "Font installation complete!"
info "Select the installed font in your terminal emulator's settings."
echo ""
