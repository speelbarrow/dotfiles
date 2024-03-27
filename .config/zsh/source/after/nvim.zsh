# Set EDITOR environment variable and `vim` command alias if Neovim found
if [ -x `command -v nvim` ]; then
        export EDITOR='nvim'
        alias vim='nvim'
fi
