function z {
        local ignore=".git"

        if [ -e $HOME/.ezaignore ]; then
                ignore+="|$(cat $HOME/.ezaignore | grep -Ev -e '^#' | grep -Ev '^( |\t)*$' | tr '\n' '|' | sed -E 's/\/\|/|/g' | sed -E 's/(^|\|)\//\1/g' | sed -E 's/\|$//')"
        fi
        if [ -e $HOME/.config/local/.ezaignore ]; then
                ignore+="|$(cat $HOME/.config/local/.ezaignore | grep -Ev -e '^#' | grep -Ev '^( |\t)*$' | tr '\n' '|' | sed -E 's/\/\|/|/g' | sed -E 's/(^|\|)\//\1/g' | sed -E 's/\|$//')"
        fi

        eza -l --git --icons --header --git-ignore --ignore-glob="$ignore" $@
}
alias za='z -a'
alias zaa='z -a --ignore-glob " "'
alias zz='za --tree --level 5'
alias zza='zz --ignore-glob " "'
