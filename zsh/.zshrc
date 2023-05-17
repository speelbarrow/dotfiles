# Determine location of scripts
DOTFILES=$(realpath "$(dirname $(realpath ${(%):-%N}))/..")
alias dotfiles="cd $DOTFILES"

# Run setup scripts for before loading oh my zsh
source $DOTFILES/zsh/.zshrc.pre-oh-my-zsh
[ -f $HOME/.zshrc.local.pre-oh-my-zsh ] && source $HOME/.zshrc.local.pre-oh-my-zsh

# Load oh my zsh
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Run setup script for after loading oh my zsh
source $DOTFILES/zsh/.zshrc.post-oh-my-zsh
[ -f $HOME/.zshrc.local.post-oh-my-zsh ] && source $HOME/.zshrc.local.post-oh-my-zsh
