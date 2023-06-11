#!/usr/bin/env bash

# Bring helper funcs into scope
. "$DOTFILES/helpers.sh"

# Create a backup of any existing config file
file ~/.config/nvim

# Create symlinks for Neovim config files
mkdir -p ~/.config/nvim/lua
ln -s "$(dirname "$0")/init.lua" ~/.config/nvim/init.lua
ln -s "$(dirname "$0")/lua/dotfiles" ~/.config/nvim/lua/dotfiles
echo "Created Neovim config symlink"
