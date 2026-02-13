# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE='nerdfont-complete'

# Plugins
# Custom plugins (zsh-autosuggestions, zsh-syntax-highlighting) must be
# cloned into $ZSH_CUSTOM/plugins/ — the installer handles this for you.
plugins=(
    git
    history
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
    colored-man-pages
    extract
    web-search
    copyfile
    copypath
    npm
    pip
)

source "$ZSH/oh-my-zsh.sh"

# ── Aliases ─────────────────────────────────────────────────────────────────

alias zshconfig="${EDITOR:-vim} ~/.zshrc"
alias p10kconfig="${EDITOR:-vim} ~/.p10k.zsh"
alias zshupdate='git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull'
alias src='exec zsh'
alias cls='clear'

# colorls aliases — only loaded when colorls is installed
if command -v colorls &>/dev/null; then
    alias ll='colorls -l --sd --group-directories-first'
    alias ls='colorls --group-directories-first'
    alias la='colorls -a'
    alias lla='colorls -la --sd --group-directories-first'
    alias lsd='colorls -d'
fi

# ── Powerlevel10k ───────────────────────────────────────────────────────────

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
