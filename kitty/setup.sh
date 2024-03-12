#! /usr/bin/env bash

# Bring helper funcs into scope
. "$DOTFILES/helpers.sh"

# Clear any existing kitty config
file ~/.config/kitty

# Symlink files to ~/.config/kitty directory
mkdir -p "$HOME/.config/kitty"
ln -s "$DOTFILES/kitty/*.conf" "$HOME/.config/kitty/"

# Clone and symlink Dracula theme
git clone git@github.com:dracula/kitty.git "$HOME/.config/kitty/dracula"
ln -s "$HOME/.config/kitty/dracula/dracula.conf" "$HOME/.config/kitty/dracula.conf"
ln -s "$HOME/.config/kitty/dracula/diff.conf" "$HOME/.config/kitty/diff.conf"
