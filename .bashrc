#!/bin/bash
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f ~/.sh/functions.sh ]; then source ~/.sh/functions.sh; fi
if [ -f ~/.sh/exports.sh ]; then source ~/.sh/exports.sh; fi
if [ -f ~/.sh/aliases.sh ]; then source ~/.sh/aliases.sh; fi

export SHELL=/bin/bash

shopt -s histappend checkwinsize expand_aliases
set +o noclobber

# Brew
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Bash completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# Keybindings
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

# fzf
if check fzf; then eval "$(fzf --bash)"; fi

# zoxide
if check zoxide; then eval "$(zoxide init --cmd cd bash)"; fi

# Load oh-my-posh
if check oh-my-posh; then
  eval "$(oh-my-posh init bash --config "$XDG_CONFIG_HOME/omp/omp_config.toml")"
else
  PS1='[\u@\h \W]\$ '
fi

