function zshrc {
        local config=${XDG_CONFIG_HOME:-$HOME/.config}

        # Local-only files that should be sourced before loading oh-my-zsh (if any)
        if [ -d $config/local/zsh/source/before ]
        then
                for file in $config/local/zsh/source/before/**/*
                        . $file
        fi

        # Files that should be sourced before loading oh-my-zsh
        for file in $config/zsh/source/before/**/*
                . $file

        # Load oh-my-zsh
        export ZSH=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/oh-my-zsh
        . $ZSH/oh-my-zsh.sh

        # Files that should be sourced after loading oh-my-zsh
        for file in $config/zsh/source/after/**/*
                . $file

        # Local-only files that should be sourced after loading oh-my-zsh (if any)
        if [ -d $config/local/zsh/source/after ]
        then
                for file in $config/local/zsh/source/after/**/*
                        . $file
        fi
}
zshrc
unfunction zshrc
