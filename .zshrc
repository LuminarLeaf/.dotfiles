#!/bin/zsh

# Brew
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]] then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# bash like word select
autoload -U select-word-style
select-word-style bash

# Set zinit directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Catppuccin for zsh-syntax-highlighting
source ~/.sh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Snippets
# zinit snippet OMZP::alias-finder
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load Plugins
autoload -U compinit && compinit

zinit cdreplay -q

# Load oh-my-posh
if [ -z "$TERM_PROGRAM" ] || [ "$TERM_PROGRAM" != "WarpTerminal" ]; then
    eval "$(oh-my-posh init zsh --config ~/.config/omp/omp_config.toml)"
fi

# Keybindings
bindkey -v
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^?' backward-delete-char
bindkey '^f' forward-char
bindkey '^[b' vi-backward-word
bindkey '^[f' vi-forward-word
bindkey '^[n' down-line-or-history
bindkey '^[p' up-line-or-history
bindkey '^[^?' backward-kill-word

# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
HISTORY_IGNORE='(rm *|pkill *)'
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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color always $realpath'
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Functions
if [ -f ~/.sh/functions.sh ]; then source ~/.sh/functions.sh; fi

# Exports
if [ -f ~/.sh/exports.sh ]; then source ~/.sh/exports.sh; fi

# Aliases
if [ -f ~/.sh/aliases.sh ]; then source ~/.sh/aliases.sh; fi

# Shell integrations
if check fzf; then eval "$(fzf --zsh)"; fi
if check zoxide; then eval "$(zoxide init --cmd cd zsh)"; fi

# nvm
if [ -f /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi
