# Determine location of scripts
DOTFILES=$(dirname $(realpath ${(%):-%N}))

# Run setup script for before loading oh my zsh
source $DOTFILES/.zshrc.pre-oh-my-zsh

# Load oh my zsh
source $ZSH/oh-my-zsh.sh

# Run setup script for after loading oh my zsh
source $DOTFILES/.zshrc.post-oh-my-zsh
