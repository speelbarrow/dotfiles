#!/bin/sh

. "$UTIL"

if cmd_exists nvim && cmd_exists cargo && ! cmd_exists lolcrab; then
        cargo install lolcrab
fi
