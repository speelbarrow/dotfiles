#!/usr/bin/env bash

# Bring helper funcs into scope
. $DOTFILES/helpers.sh

# Deal with any existing config
file "$HOME/.oh-my-zsh"

# Install OhMyZsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -) --unattended"

# Remove auto-generated .zshrc
file "$HOME/.zshrc"

# Install Dracula theme
git clone https://github.com/dracula/zsh.git $HOME/.oh-my-zsh/custom/themes/dracula

# Install other plugins
for repo in "zsh-users/zsh-autosuggestions" "zsh-users/zsh-syntax-highlighting" "noah-friedman/zsh-apple-touchbar"; do
	git clone "https://github.com/$repo" "$HOME/.oh-my-zsh/custom/plugins/`basename $repo`"
done

# Add symlink for zsh-apple-touchbar (uses -f because I never want the default)
ln -sf $DOTFILES/zsh/zsh-apple-touchbar.zsh $HOME/.oh-my-zsh/custom/plugins/zsh-apple-touchbar/zsh-apple-touchbar.zsh 

# Install `exa` (if not already present, or if `force` is set)
if { ! exists exa; } || $FORCE; then
	# If cargo is already installed, use that
	if exists cargo; then
		cargo install exa
	
	# Otherwise, check for other common package managers
	elif exists brew; then
		brew install exa
	elif exists apt; then
		sudo apt install exa
	elif exists apk; then
		sudo apk -S exa
	else
		echo "No package manager found. Please install exa manually."
	fi
fi


# Symlink .zshrc
ln -s $DOTFILES/zsh/.zshrc $HOME/.zshrc
