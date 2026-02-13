#!/bin/bash

# ============================================================================
# MyTerminalKit - Shared Utilities
# ============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
header()  { echo -e "\n${BOLD}${CYAN}━━━ $1 ━━━${NC}\n"; }

# ── OS & Package Manager Detection ──────────────────────────────────────────

detect_os() {
    OS_TYPE="unknown"
    PKG_MANAGER="unknown"

    case "$(uname -s)" in
        Darwin)
            OS_TYPE="macos"
            PKG_MANAGER="brew"
            ;;
        Linux)
            OS_TYPE="linux"
            if command -v apt-get &>/dev/null; then
                PKG_MANAGER="apt"
            elif command -v dnf &>/dev/null; then
                PKG_MANAGER="dnf"
            elif command -v yum &>/dev/null; then
                PKG_MANAGER="yum"
            elif command -v pacman &>/dev/null; then
                PKG_MANAGER="pacman"
            elif command -v zypper &>/dev/null; then
                PKG_MANAGER="zypper"
            elif command -v apk &>/dev/null; then
                PKG_MANAGER="apk"
            else
                error "No supported package manager found (apt, dnf, yum, pacman, zypper, apk)."
                exit 1
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            error "Windows is not supported. Use WSL instead."
            exit 1
            ;;
        *)
            error "Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac

    export OS_TYPE PKG_MANAGER
    success "Detected: OS=${BOLD}$OS_TYPE${NC}, Package manager=${BOLD}$PKG_MANAGER${NC}"
}

# ── Package Manager Abstraction ─────────────────────────────────────────────

pkg_update() {
    info "Updating package index..."
    case "$PKG_MANAGER" in
        apt)    sudo apt-get update -qq ;;
        dnf)    sudo dnf check-update -q 2>/dev/null; true ;;
        yum)    sudo yum check-update -q 2>/dev/null; true ;;
        pacman) sudo pacman -Sy --noconfirm >/dev/null ;;
        zypper) sudo zypper refresh -q ;;
        apk)    sudo apk update -q ;;
        brew)   brew update --quiet ;;
    esac
}

pkg_install() {
    local pkg="$1"
    case "$PKG_MANAGER" in
        apt)    sudo apt-get install -y -qq "$pkg" ;;
        dnf)    sudo dnf install -y -q "$pkg" ;;
        yum)    sudo yum install -y -q "$pkg" ;;
        pacman) sudo pacman -S --noconfirm --needed "$pkg" ;;
        zypper) sudo zypper install -y "$pkg" ;;
        apk)    sudo apk add -q "$pkg" ;;
        brew)   brew install --quiet "$pkg" ;;
    esac
}

# ── Helpers ─────────────────────────────────────────────────────────────────

cmd_exists() {
    command -v "$1" &>/dev/null
}

ask_yes_no() {
    local prompt="$1"
    local response
    echo -en "${BOLD}$prompt${NC} [Y/n] "
    read -r response
    case "$response" in
        [nN][oO]|[nN]) return 1 ;;
        *) return 0 ;;
    esac
}
