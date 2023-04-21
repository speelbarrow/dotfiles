# Determine location of scripts
DOTFILES=$(realpath "$(dirname $(realpath ${(%):-%N}))/..")

# Run setup script for before loading oh my zsh
source $DOTFILES/zsh/.zshrc.pre-oh-my-zsh

# Load oh my zsh
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Run setup script for after loading oh my zsh
source $DOTFILES/zsh/.zshrc.post-oh-my-zsh
