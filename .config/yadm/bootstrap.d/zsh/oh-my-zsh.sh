#!/bin/sh

. "$UTIL"

if cmd_exists zsh && fs_exists "$HOME/.local/share/zsh/oh-my-zsh"; then
        mkdir -p "$HOME/.local/share/zsh"
        git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.local/share/zsh/oh-my-zsh"

        git clone --depth 1 https://github.com/dracula/zsh.git \
                "$HOME/.local/share/zsh/oh-my-zsh/custom/themes/dracula"
        mkdir "$HOME/.local/share/zsh/oh-my-zsh/custom/themes/lib"
        for file in dracula.zsh-theme lib/async.zsh; do
                ln -s "$HOME/.local/share/zsh/oh-my-zsh/custom/themes/dracula/$file" \
                        "$HOME/.local/share/zsh/oh-my-zsh/custom/themes/$file"
                done

                for repo in zsh-autosuggestions zsh-syntax-highlighting; do
                        git clone --depth 1 "https://github.com/zsh-users/$repo" \
                                "$HOME/.local/share/zsh/oh-my-zsh/custom/plugins/$repo"
                done
fi
