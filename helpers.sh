# function for backing up/overwriting a file/directory
file() {
	[ -z ${1+x} ] && { >&2 echo "ERROR: invalid script function call to 'file'"; exit 1; }
	SHORT=`basename $1`
	{ $FORCE && { >&2 echo "removing $SHORT (force)"; rm -rf $1; }; } || { [ -e $1 ] && { echo "moving '$SHORT' to '$SHORT.old'" ; file $1.old; mv "$1" "$1.old"; }; }
}

# function for cloning a github repository to a specific directory
clone() {
	{ [ -z ${1+x} ] && [ -z ${2+x} ]; } && { >&2 echo "ERROR: invalid script function call to 'clone'"; exit 1; }
	file $2
	git clone --depth 1 https://github.com/$1 $2
}

# function for checking if a command exists on this system
exists() { [[ -x $(command -v $1) ]]; }
