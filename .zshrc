#!/bin/zsh

# Brew
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]] then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# bash like word select
autoload -U select-word-style
select-word-style bash

# Set antidote directory
ANTIDOTE_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/antidote"

# Download antidote if not present
if [ ! -d "$ANTIDOTE_DIR" ]; then
  mkdir -p "$(dirname $ANTIDOTE_DIR)"
  git clone https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

# Load antidote
source "${ANTIDOTE_DIR}/antidote.zsh"

zstyle ':antidote:bundle' use-friendly-names 'yes'

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=($ANTIDOTE_DIR/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh

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

