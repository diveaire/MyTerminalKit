#!/bin/bash

# Fonction pour détecter le système d'exploitation
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux) echo "linux" ;;
        *) echo "unknown" ;;
    esac
}

# Installer Homebrew sous macOS
install_homebrew() {
    if [ "$1" = "macos" ]; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "Installation de Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi
    fi
}

# Installer Zsh
install_zsh() {
    if ! command -v zsh >/dev/null 2>&1; then
        echo "Installation de Zsh..."
        if [ "$1" = "macos" ]; then
            brew install zsh
        elif [ "$1" = "linux" ]; then
            sudo apt update && sudo apt install zsh
        else
            echo "Système d'exploitation non pris en charge."
            exit 1
        fi
    fi
}

# Installer la police MesloLGS NF
install_font() {
    if [ "$1" = "macos" ]; then
        brew tap homebrew/cask-fonts
        brew install --cask font-meslo-lg-nerd-font
    elif [ "$1" = "linux" ]; then
        # Pour Linux, le processus peut varier selon la distribution.
        # Voici un exemple général pour télécharger et installer la police.
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
        mkdir -p ~/.local/share/fonts
        mv "MesloLGS NF Regular.ttf" ~/.local/share/fonts
        fc-cache -f -v
    fi
}

# OS principal
os=$(detect_os)

# Installer Homebrew (pour macOS)
install_homebrew $os

# Installer Zsh
install_zsh $os

# Installer Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Copier les fichiers de configuration
cp path/to/your/.zshrc ~/
cp path/to/your/.p10k.zsh ~/

# Installer la police MesloLGS NF
install_font $os

echo "Configuration terminée. Redémarrez votre terminal."