#!/bin/sh

. "$UTIL"

for hook in "$YADM_DIR"/hooks/*.sh; do
    if fs_exists "$HOME/.local/share/yadm/repo.git/hooks/$(basename "$hook" .sh)"; then
        ln -s "$hook" "$HOME/.local/share/yadm/repo.git/hooks/$(basename "$hook" .sh)"
    fi
done
