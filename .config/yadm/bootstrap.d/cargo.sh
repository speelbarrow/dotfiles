#!/bin/sh

. "$UTIL"

if cmd_exists cc; then
        if ! cmd_exists cargo; then
                curl https://sh.rustup.rs -sSf | sh -s -- -y --profile=minimal
                . "$HOME/.cargo/env"
        fi
else
        echo "No local C installation. Skipping \`cargo install\`s." >&2
fi
