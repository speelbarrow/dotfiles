#!/bin/sh

# function for checking if a command exists on this system
exists() { [[ -x $(command -v "$1") ]]; }

# Install `eza` (if not already present, or if `force` is set)
if ! exists exa; then
	# If cargo is already installed, use that
	if exists cargo; then
		cargo install eza
	
	# Otherwise, check for other common package managers
	elif exists brew; then
		brew install eza
	elif exists apt; then
		sudo apt install eza
	elif exists apk; then
		sudo apk -S eza
	else
		echo "No package manager found. Please install eza manually."
	fi
fi
