#!/bin/sh

. $(chezmoi source-path)/run_helpers.sh

# Check for cargo
if exists cargo; then
    cargo install lolcrab
fi
