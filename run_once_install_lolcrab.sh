#!/bin/sh

. $(chezmoi source-path)/../zsh/helpers.sh

# Check for cargo
if exists cargo; then
    cargo install lolcrab
fi
