#!/bin/sh
#
# ~/.sh/functions
#

# This file contains functions that are meant to be sourced by ~/.bashrc and ~/.zshrc.

check() {
  if command -v $1 &> /dev/null; then return 0; else return 1; fi
}

ex() {
  if [ $# -eq 0 ]; then
    echo "error: no <file> provided for extraction"
    echo "usage: ex <file>"
  fi
  while [ $# -ne 0 ]; do
    if [ ! -f $1 ]; then
      echo "'$1' is not a valid file"
    fi
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.tar) tar xf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar x $1 ;;
      *.gz) gunzip $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *) echo "'$1' cannot be extracted via ex()" ;;
    esac
    shift
  done
}

mkcd() {
  if [ $# -eq 0 ]; then
    echo "error: no <dir> provided for creation"
    echo "usage: mkcd <dir>"
  fi
  mkdir -p $1 && cd $1
}

e() {
  if [[ -n "$VISUAL" ]]; then
    "$VISUAL" "$@"
  elif [[ -n "$EDITOR" ]]; then
    "$EDITOR" "$@"
  else
    echo "No editor set"
  fi
}
