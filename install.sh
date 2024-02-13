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

# Installer Curl
install_curl() {
    if ! command -v curl >/dev/null 2>&1; then
        echo "Installation de Curl..."
        if [ "$1" = "macos" ]; then
            brew install curl
        elif [ "$1" = "linux" ]; then
            sudo apt update && sudo apt install curl
        else
            echo "Système d'exploitation non pris en charge pour l'installation de Curl."
            exit 1
        fi
    else
        echo "Curl est déjà installé."
    fi
}

# Installer oh-my-zsh
install_oh-my-zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installation de Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh-My-Zsh est déjà installé."
    fi
}

# Installer Ruby et Ruby Dev
install_ruby() {
    if ! command -v ruby >/dev/null 2>&1; then
        echo "Installation de Ruby..."
        if [ "$1" = "macos" ]; then
            brew install ruby
        elif [ "$1" = "linux" ]; then
            sudo apt update
            sudo apt install ruby ruby-dev
        else
            echo "Système d'exploitation non pris en charge."
            exit 1
        fi
    else
        echo "Ruby est déjà installé."
    fi
}

install_required_tools() {
    echo "Vérification et installation des outils requis..."

    # Liste des outils requis
    required_tools=("unzip" "bat" )

    for tool in "${required_tools[@]}"; do
        if ! command -v $tool &> /dev/null; then
            echo "Installation de $tool..."

            if [ "$1" = "Darwin" ]; then
                # Installer avec Homebrew sur macOS
                brew install $tool
            elif [ "$1" = "Linux" ]; then
                # Installer avec apt sur Linux
                sudo apt-get install -y $tool
            fi
        else
            echo "$tool est déjà installé."
        fi
    done
}

# Installer color-ls
install_colorls() {
    gem install colorls
}



# OS principal
os=$(detect_os)

# Installer Homebrew (pour macOS)
install_homebrew $os

# Installer Zsh
install_zsh $os

# Installer Curl
install_curl $os

# Installer OH-my-zsh
install_oh-my-zsh

# Installer Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# Installer Ruby et Ruby Dev
install_ruby $os

# Installer les paquets de bases
install_required_tools $os

# Installer color-ls
install_colorls

# Copier les fichiers de configuration
if [ "$os" = "macos" ]; then
    cp macOs/.zshrc ~/
    cp macOs/.p10k.zsh ~/
else
    cp linux/.zshrc ~/
    cp linux/.p10k.zsh ~/
fi

# Installer la police MesloLGS NF
install_font $os

echo "Configuration terminée. Redémarrez votre terminal."