# Determine location of scripts
DOTFILES=$(dirname $(realpath $BASH_SOURCE))

# Run setup script for before loading oh my zsh
source $DOTFILES/pre-ohmy.zsh

# Load oh my zsh
source $ZSH/oh-my-zsh.sh

# Run setup script for after loading oh my zsh
source $DOTFILES/post-ohmy.zsh
