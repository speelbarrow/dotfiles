#!/usr/bin/env bash

# Bring helper funcs into scope
. "$DOTFILES/helpers.sh"

# Create a backup of any existing config file
file ~/.config/nvim

# Create symlinks for Neovim config files
mkdir -p ~/.config/nvim
ln -s "$(dirname "$0")/init.lua" ~/.config/nvim/init.lua
echo "Created Neovim config symlink"
