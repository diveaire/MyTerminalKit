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

# Installer Zsh Autosuggestions
install_zsh_autosuggestions() {
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        echo "Installation de Zsh Autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
        echo "Zsh Autosuggestions est déjà installé."
    fi
}

# Installer Zsh Syntax Highlighting
install_zsh_syntax_highlighting() {
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        echo "Installation de Zsh Syntax Highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo "Zsh Syntax Highlighting est déjà installé."
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
    required_tools=("unzip" "bat" "ruby-full" "libncurses5-dev" "ruby-dev" "build-essential" "libssl-dev" "libreadline-dev" "zlib1g-dev" "libffi-dev")

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
    sudo gem install colorls
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

# Installer Zsh Autosuggestions
install_zsh_autosuggestions

# Installer Zsh Syntax Highlighting
install_zsh_syntax_highlighting

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

# Suppresion du dossier après installation
echo "Voulez-vous supprimer les fichiers d'installation téléchargés ? (o/n)"
read -r response

if [[ "$response" =~ ^([oO][uU][iI]|[oO])$ ]]
then
    echo "Suppression des fichiers d'installation..."
    # Supprimer le répertoire powerlevel10k si nécessaire
    rm -rf ~/powerlevel10k
    echo "Les fichiers d'installation ont été supprimés."
else
    echo "Les fichiers d'installation n'ont pas été supprimés."
fi

echo "Configuration terminée. Redémarrez votre terminal."



echo "Configuration terminée. Redémarrez votre terminal."
