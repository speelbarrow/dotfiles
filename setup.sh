#!/usr/bin/env bash

# Neovim
if [ -x "$(command -v nvim)" ]
then
	if [ -f ~/.config/nvim/init.lua ]
	then
		echo "Neovim config already exists, moving to init.vim.old"
		mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.old
	fi
		ln -s "$(dirname "$0")/init.lua" ~/.config/nvim/init.lua
		echo "Created Neovim config symlink"
fi
