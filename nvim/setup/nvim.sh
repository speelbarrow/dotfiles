#!/usr/bin/env bash

# Create a backup of any existing config file
if [ -f ~/.config/nvim/init.lua ]
then
	if $FORCE
	then
		echo "WARNING: 'force' flag has been set, overwriting 'init.lua' without backing up" 1>&2
	else
		echo "Neovim config already exists, renaming to 'init.lua.old'"
		mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.old
	fi
fi

# Create symlink for Neovim config file
ln -s "$(dirname "$0")/init.lua" ~/.config/nvim/init.lua
echo "Created Neovim config symlink"
