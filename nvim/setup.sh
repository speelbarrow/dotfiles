#!/usr/bin/env bash

# Bring helper funcs into scope
. $ROOT/helpers.sh

# Install packer.nvim if necessary
clone wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Create a backup of any existing config file
file ~/.config/nvim/init.lua

# Create symlink for Neovim config file
ln -s "$(dirname "$0")/init.lua" ~/.config/nvim/init.lua
echo "Created Neovim config symlink"
