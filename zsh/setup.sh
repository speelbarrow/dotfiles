#!/usr/bin/env bash

# Bring helper funcs into scope
. $DOTFILES/helpers.sh

# Deal with any existing config
file "$HOME/.oh-my-zsh"

# Install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

# Remove auto-generated .zshrc
file "$HOME/.zshrc"

# Install Typewritten theme
git clone https://github.com/reobin/typewritten.git $HOME/.oh-my-zsh/custom/themes/typewritten
ln -s $HOME/.oh-my-zsh/custom/themes/typewritten/typewritten.zsh-theme $HOME/.oh-my-zsh/custom/themes/typewritten.zsh-theme
ln -s $HOME/.oh-my-zsh/custom/themes/typewritten/async.zsh $HOME/.oh-my-zsh/custom/themes/async

# Install other plugins
for repo in "zsh-users/zsh-autosuggestions" "zsh-users/zsh-syntax-highlighting" "zsh-users/zsh-apple-touchbar"; do
	git clone "https://github.com/$repo" "$HOME/.oh-my-zsh/custom/plugins/`basename $repo`"
done

# Add symlink for zsh-apple-touchbar (uses -f because I never want the default)
ln -sf $DOTFILES/zsh/zsh-apple-touchbar.zsh $HOME/.oh-my-zsh/custom/plugins/zsh-apple-touchbar/zsh-apple-touchbar.zsh 

# Symlink .zshrc
ln -s $DOTFILES/zsh/.zshrc $HOME/.zshrc
