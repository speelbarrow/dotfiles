#!/bin/sh

. "$UTIL"

if cmd_exists kitty; then
    mkdir -p $HOME/.local/share/kitty 2>/dev/null

    for file in dracula.conf diff.conf; do
        if fs_exists $HOME/.local/share/kitty/$file; then
            curl -o $HOME/.local/share/kitty/$file -L https://raw.githubusercontent.com/dracula/kitty/master/$file
        fi
    done
fi
