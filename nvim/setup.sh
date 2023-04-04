#!/usr/bin/env bash

# Bring helper funcs into scope
. $ROOT/helpers.sh

# Create a backup of any existing config file
file ~/.config/nvim/init.lua

# Create symlinks for Neovim config files
ln -s "$(dirname "$0")/init.lua" ~/.config/nvim/init.lua
ln -s "$(dirname "$0")/lua" ~/.config/nvim/lua
echo "Created Neovim config symlink"
