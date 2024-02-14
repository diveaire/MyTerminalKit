#!/bin/bash

# Définir l'emplacement des polices selon l'OS
font_dir=""
os_type="$(uname -s)"

case $os_type in
    Darwin)
        font_dir="$HOME/Library/Fonts"
        # S'assurer que Homebrew est installé
        if ! command -v brew >/dev/null 2>&1; then
            echo "Homebrew n'est pas installé. Installation en cours..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        ;;
    Linux)
        font_dir="$HOME/.local/share/fonts"
        mkdir -p $font_dir
        ;;
    *)
        echo "Système d'exploitation non pris en charge."
        exit 1
        ;;
esac

# Générer automatiquement la liste des polices à partir des fichiers ZIP dans le dossier 'fonts'
fonts=()
for zip in fonts/*.zip; do
    if [ -f "$zip" ]; then
        font_name=$(basename "$zip" .zip)
        fonts+=("$font_name")
    fi
done

# Fonction pour installer une police
install_font() {
    font_name=$1
    font_zip="${font_name}.zip"

    if [ "$os_type" = "Darwin" ]; then
        # Utiliser Homebrew pour installer la police sur macOS
        brew tap homebrew/cask-fonts
        brew install --cask font-$font_name

    elif [ "$os_type" = "Linux" ]; then
        # Décompresse le zip dans le dossier des polices pour Linux
        unzip -o "fonts/$font_zip" -d $font_dir
        # Recharger le cache des polices
        fc-cache -f -v
    fi

    echo "$font_name installé avec succès."
}
install_required_tools() {
    echo "Vérification et installation des outils requis..."

    # Liste des outils requis
    required_tools=("fc-cache")

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

install_required_tools $os_type
# Demander à l'utilisateur de choisir une police
echo "Choisissez une police à installer :"
select font_choice in "${fonts[@]}"; do
    case $font_choice in
        *)
            # Vérifier si la police est déjà installée
            if [ -f "$font_dir/${font_choice}NerdFont.ttf" ]; then
                echo "La police $font_choice est déjà installée."
            else
                install_font $font_choice
            fi
            break
            ;;
    esac
done
