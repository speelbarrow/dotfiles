# function for checking if a command exists on this system
exists() { [[ -x $(command -v "$1") ]]; }
