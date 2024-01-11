
# MyTerminalKit

MyTerminalKit est un ensemble d'outils conçu pour configurer automatiquement votre terminal avec Zsh, le thème Powerlevel10k, et la police MesloLGS NF. C'est la solution idéale pour personnaliser rapidement et efficacement votre environnement de terminal.

## Prérequis

Avant de lancer l'installation, assurez-vous que les éléments suivants sont installés sur votre système :
- `git`
- `curl` ou `wget` (nécessaire pour télécharger les fichiers depuis GitHub)

## Installation

Pour mettre en place la configuration de votre terminal, procédez comme suit :

1. Clonez le dépôt GitHub :
 - HTTPS
```bash
git clone https://github.com/diveaire/MyTerminalKit.git
```
- SSH
```bash
git clone git@github.com:diveaire/MyTerminalKit.git
```
2. Accédez au dossier cloné :
```bash
cd MyTerminalKit
```
3. Rendez le script `install.sh` exécutable :
```bash
chmod +x install.sh
```
4. Lancez le script d'installation :
```bash
./install.sh
```

Le script `install.sh` s'occupera de la configuration de Zsh, de l'installation du thème Powerlevel10k, de la police MesloLGS NF, et appliquera les configurations personnalisées fournies dans les fichiers `.zshrc` et `.p10k.zsh`.

## Personnalisation

Vous pouvez modifier les fichiers de configuration selon vos besoins :
- `.zshrc` : Votre configuration Zsh personnalisée.
- `.p10k.zsh` : Votre configuration du thème Powerlevel10k.

## Contributions

Les contributions sont toujours les bienvenues. Si vous souhaitez apporter des améliorations, n'hésitez pas à faire une pull request ou à ouvrir un issue.

## Licence

Distribué sous la licence MIT. Voir `LICENSE` pour plus d'informations.
