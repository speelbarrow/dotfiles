#!/usr/bin/env bash

# Parse CLI flags
BAD_FLAG=false
export FORCE=false
export CONTINUE=false
HELP=false
for FLAG in "$@"; do
	[ "${FLAG:0:1}" != - ] && { BAD_FLAG=true; break; }

	if [ "${FLAG:1:1}" != - ]; then
		# Iterate over remaining characters and parse each individually
		while read -rn 1 CHAR; do
			case $CHAR in
				"c")
					CONTINUE=true
					;;
				"f")
					FORCE=true
					;;
				"h")
					HELP=true
					;;
				$'\0');;
				*)
					BAD_FLAG=true
					break
					;;
			esac
		done < <(echo "${FLAG:1}")
	else
		# Check for specific values in the whole flag string (minus leading '--')
		case ${FLAG:2} in
			"continue")
				CONTINUE=true
				;;
			"force")
				FORCE=true
				;;
			"help")
				HELP=true
				;;
			*)
				BAD_FLAG=true
				break
				;;	
		esac
	fi
done

# Show usage if incorrect flags
if $HELP || $BAD_FLAG; then
	echo "Usage: $0 [-c|f|h|[-continue|force|help]]"
	printf "\t-c, --continue\tcontinue installing configurations even when an installation fails for a program\n"
	printf "\t-f, --force\tforcibly overwrite files while setting up\n"
	printf "\t-h, --help\tshow this help text\n"
	exit $BAD_FLAG
elif $FORCE; then
	read -rp "WARNING: You have entered force mode. Are you SURE you want to do this??? (y/N): " yn
	{ echo "$yn" | grep -qi "^y$"; } || exit 1
fi

# Save root directory of config files to avoid computing repeatedly
export DOTFILES
DOTFILES=$(dirname "$(realpath "${BASH_SOURCE[0]}")")


# Bring helper functions into scope now that we know where the root directory is
. "$DOTFILES/helpers.sh"

# Check for dependencies
for DEPENDENCY in git wget; do exists $DEPENDENCY || { >&2 echo "ERROR: required program '$DEPENDENCY' is not installed."; exit 1; }; done

# Check if commands for config files are present, if so then run the associated script
FAILED=false
for CONFIGURABLE in nvim zsh; do
	if exists "$CONFIGURABLE"; then
		echo "Configuring $CONFIGURABLE . . ."

		"$DOTFILES/$CONFIGURABLE/setup.sh"

		# Check if the script exitted non-zero
		if [ "${STATUS=$?}" -ne 0 ]; then
			echo "Failed to configure \`$CONFIGURABLE\`" 1>&2
			FAILED=true

			# Exit only if CONTINUE is not set
			if ! $CONTINUE; then
				echo "If you would like to continue installing configuration for other programs, please rerun this script with the \`--continue\` flag" 1>&2
				exit "$STATUS"
			fi
		fi

		echo "Successfully configured \`$CONFIGURABLE\`"
	fi
done

# Output to stderr if any configurations failed
{ $FAILED && >&2 echo "Installation of some configurations failed"; } || true
