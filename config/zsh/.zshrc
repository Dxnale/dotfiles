# Alias to create a Python module folder with __init__.py
alias mod='f() { mkdir "$1" && touch "$1/__init__.py"; unset -f f; }; f'

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc: executed by zsh for non-login shells.
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.|

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Install zoxide if not present
if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
    curl -sS https://webi.sh/zoxide | sh; \
    source ~/.config/envman/PATH.env
fi

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting

# Configuración de colores para syntax highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[function]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[command]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#7c90fa,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#7bd167,italic'
ZSH_HIGHLIGHT_STYLES[path]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#7c90fa'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#7c90fa'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#7bd167'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#7bd167'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#7bd167'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#7c90fa'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ff9747'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#dad5cd'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#8773f8'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6c7086'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#dad5cd'

# Add in zsh and fzf completions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash false  # improves performance

# Shell integrations
eval "$(zoxide init --cmd cd zsh)"


# Configuración adicional para fzf-tab
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags '--color=bg:#1b1926,bg+:#2a2838,fg:#dad5cd,fg+:#dad5cd,hl:#8773f8,hl+:#7c90fa,pointer:#ff9747,info:#7bd167,spinner:#7c90fa,header:#7bd167,prompt:#8773f8,marker:#ff9747'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Función para hacer pull de master guardando temporalmente los cambios
smartpull() {
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [ "$current_branch" != "master" ]; then
      echo "Error: No estás en la rama master"
      return 1
  fi
  echo "Guardando cambios actuales..."
  git stash
  echo "Haciendo pull de master..."
  git pull origin master
  echo "Restaurando cambios guardados..."
  git stash pop
}

# Función para activar automáticamente entornos virtuales de Python
function auto_venv() {
    if [[ -d ./venv ]] ; then
        source ./venv/bin/activate
    elif [[ -d ./.venv ]] ; then
        source ./.venv/bin/activate
    fi
}

# Prompt
autoload -U colors && colors
PROMPT="%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$ "

#######################################################
#                     Aliases                         #
#######################################################

# Alias: fd (fdfind)
alias fd='fdfind'

# Aliases: ls
alias l='eza -1A --group-directories-first --color=always --git-ignore'
alias ls='l'
alias la='l -l --time-style="+%Y-%m-%d %H:%M" --no-permissions --octal-permissions'
alias ls='ls --color'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# Aliases: git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

# Aliases: systemd
alias sd='sudo systemctl'
alias sdu='systemctl --user'
alias jd='journalctl --no-pager'

# Aliases: human-readable
alias cal='TZ=Asia/Bangkok cal --monday'
alias du='du --human-readable'
alias free='free --human'

# Aliases: safety
alias cp='cp --interactive'
alias mv='mv --interactive'

alias rf='rm -rf'
alias py='python3'
alias ipy='ipython'
alias ping='ping -4A'

alias -g p='2>&1 | less'
alias sudo='sudo '  # allow aliases with sudo

launch() {
    (setsid "$@" >/dev/null 2>&1 &)
}

alias vim='nvim'
alias c='clear'
alias clip='xclip -sel clip'
alias ps4='$HOME/Software/ps4/PPPwnUI.sh'
alias pwn='$HOME/Software/ps4/PPPwnUI.sh'

# Variables de entorno
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PNPM_HOME="/home/dan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# Habilitar Ctrl + Backspace para borrar una palabra completa
bindkey '^H' backward-kill-word

# Habilitar Ctrl + Flecha izquierda/derecha para moverse entre palabras
bindkey '^[[1;5D' backward-word  # Ctrl + Flecha izquierda
bindkey '^[[1;5C' forward-word   # Ctrl + Flecha derecha

# Habilitar Ctrl + Supr para borrar una palabra completa hacia adelante
bindkey '^[[3;5~' kill-word

# Habilitar selección de texto con Shift + Flechas
bindkey '^[[1;2A' beginning-of-line    # Shift + Flecha arriba (selecciona desde el cursor hasta el inicio de la línea)
bindkey '^[[1;2B' end-of-line          # Shift + Flecha abajo (selecciona desde el cursor hasta el final de la línea)

# Reasignar Ctrl + Z para deshacer cambios
bindkey '^Z' undo

# Opcional: Asignar Alt + Z para suspender procesos
bindkey '^[z' suspend

# Cargar zsh-hook
autoload -Uz add-zsh-hook

# Ejecutar auto_venv cuando se cambie de directorio
add-zsh-hook chpwd auto_venv


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nodenv setup
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# Cargar env
. "$HOME/.local/bin/env"

# Ejecutar auto_venv al iniciar la terminal
auto_venv

# Man colors
man() {
  GROFF_NO_SGR=1 \
  LESS_TERMCAP_mb=$'\e[31m' \
  LESS_TERMCAP_md=$'\e[34m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[1;30m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[35m' \
  command man "$@"
}
search () { if [ -z "$1" ]; then echo "ERROR: Se requiere un patrón de búsqueda." >&2; return 1; fi; fd --type f --print0 | xargs -0 rg "$1"; }

# Función para buscar archivos con rg y ordenar por fecha de modificación
# Uso: rgsort "patron_regex" [directorio_inicio]
rgs() {
    if [ -z "$1" ]; then
        echo "Uso: rgsort \"patron_regex\" [directorio_inicio]"
        return 1
    fi

    local SEARCH_DIR=${2:-.} # Usa el segundo argumento como directorio, o '.' si no se proporciona

    rg -l --multiline --multiline-dotall "$1" "$SEARCH_DIR" | \
    xargs -d '\n' -r stat --format '%Y %n' 2>/dev/null | \
    sort -rn | \
    cut -d' ' -f2-
}

source /home/dan/.config/broot/launcher/bash/br

npm() { command pnpm "$@"; }

# bun completions
[ -s "/home/dan/.bun/_bun" ] && source "/home/dan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/home/dan/.opencode/bin:$PATH
export EDITOR="zed"

fpath+=~/.zfunc; autoload -Uz compinit; compinit
