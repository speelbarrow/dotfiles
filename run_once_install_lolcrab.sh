#!/bin/sh

# Check for cargo
if ! [[ -x $(command -v "cargo") ]]; then
    cargo install lolcrab
fi
