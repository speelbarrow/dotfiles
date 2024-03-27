#!/bin/sh

. "$UTIL"

if cmd_exists cargo && ! cmd_exists eza; then
        cargo install eza
        cargo install eza
fi
