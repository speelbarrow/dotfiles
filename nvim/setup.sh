#!/usr/bin/env bash

# Bring helper funcs into scope
. $DOTFILES/helpers.sh

# Install Neovim support for Python
[ $FORCE && (pip3 install neovim --force-reinstall --upgrade) ] || pip3 install neovim --upgrade

# Create a backup of any existing config file
file ~/.config/nvim/init.lua

# Create symlinks for Neovim config files
ln -s "$(dirname "$0")/init.lua" ~/.config/nvim/init.lua
ln -s "$(dirname "$0")/lua" ~/.config/nvim/lua
echo "Created Neovim config symlink"
