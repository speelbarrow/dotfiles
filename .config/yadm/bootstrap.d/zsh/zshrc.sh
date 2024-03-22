#!/bin/sh

. "$UTIL"

if fs_exists "$HOME/.zshrc"; then
    ln -s "$HOME/.config/zsh/zshrc.zsh" "$HOME/.zshrc"
fi
