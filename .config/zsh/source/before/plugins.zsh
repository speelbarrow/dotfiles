plugins+=(zsh-autosuggestions zsh-syntax-highlighting)

if command -v python3 >/dev/null 2&>1 || command -v python >/dev/null 2&>1 ; then
        plugins+=(autoswitch_virtualenv)
fi
