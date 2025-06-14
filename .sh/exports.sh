#!/bin/sh
#
# ~/.sh/exports
#

# This file contains environment variables that are meant to be exported to the
# shell session. This file is sourced by ~/.bashrc and ~/.zshrc.

# xdg
export XDG_CONFIG_HOME="$HOME/.config"

# EDITOR
if check nvim; then
  export EDITOR="nvim"
  if check neovide; then
    export VISUAL="neovide"
  else
    export VISUAL="nvim"
  fi
else
  export EDITOR="vi"
  export VISUAL="vi"
fi

# bat / batcat ( debian/ubuntu )
if check batcat; then
  export BAT_BIN="batcat"
elif check bat; then
  export BAT_BIN="bat"
fi

# bat
if [ -n "$BAT_BIN" ]; then
  export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | $BAT_BIN -p -lman' "
  export PAGER="$BAT_BIN"
  export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config" # TODO: check if same on debian/ubuntu
fi

# fzf
if check fzf; then
  export FZF_DEFAULT_OPTS="--layout=reverse --border --prompt='❱ ' \
    --color=spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

  export FZF_TMUX=1
  export BAT_PREVIEW="$BAT_BIN --color=always --style=numbers --line-range=:500 {}"

  if check fd; then
    export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix -E .git -E node_modules -E .cache"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix -E .git -E node_modules -E .cache"
    _fzf_compgen_path() {
      fd --hidden -E .git -E node_modules -E .cache . "$1"
    }
    _fzf_compgen_dir() {
      fd --dir --hidden -E .git -E node_modules -E .cache . "$1"
    }
  elif check rg; then
    export FZF_DEFAULT_COMMAND="rg --files --hidden"
  else
    export FZF_DEFAULT_COMMAND="find . -regextype 'posix-extended' -iregex '(\.git(?!ignore|modules)|node_modules|cache).*' -type d -prune -o -print"
  fi
fi

# Spicetify
if [ -d "$HOME/.spicetify" ]; then
  export PATH="$PATH:$HOME/.spicetify"
fi

# delta
if check delta; then
  export DELTA_PAGER="less -RF"
fi

# Cargo
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$PATH:$HOME/.cargo/bin"
fi
