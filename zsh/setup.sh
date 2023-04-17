#!/usr/bin/env bash

# Bring helper funcs into scope
. $ROOT/helpers.sh

# Install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

# Install Typewritten theme
git clone https://github.com/reobin/typewritten.git $ZSH_CUSTOM/themes/typewritten
ln -s "$ZSH_CUSTOM/themes/typewritten/typewritten.zsh-theme" "$ZSH_CUSTOM/themes/typewritten.zsh-theme"
ln -s "$ZSH_CUSTOM/themes/typewritten/async.zsh" "$ZSH_CUSTOM/themes/async"

# Install other plugins
for repo in "zsh-users/zsh-autosuggestions" "zsh-users/zsh-syntax-highlighting" `[ $(uname) = "Darwin" ] && echo "zsh-users/zsh-apple-touchbar"`; do
	git clone "https://github.com/$repo" "$ZSH_CUSTOM/plugins/`basename $repo`"
done
