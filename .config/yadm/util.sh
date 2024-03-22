if [ -d "$HOME/.cargo" ]; then
    . "$HOME/.cargo/env"
fi

cmd_exists() {
    command -v $1 >/dev/null 2>&1
    return $?
}

fs_exists() {
    if [ -e "$1" ]; then
        echo "\`$1\` already exists. Skipping... (remove it if you want to re-download)" >&2
        return 1
    else
        return 0
    fi
}
