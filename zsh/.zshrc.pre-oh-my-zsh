# Set theme and related configuration
ZSH_THEME="typewritten"
export TYPEWRITTEN_PROMPT_LAYOUT="singleline_verbose"
export TYPEWRITTEN_SYMBOL="$"
export TYPEWRITTEN_RELATIVE_PATH="adaptive"
export TYPEWRITTEN_COLOR_MAPPINGS="primary:6;secondary:14;accent:green;notice:blue;info_negative:1;info_positive:green;info_neutral_1:9;info_neutral_2:blue;info_special:7"

# Path to oh-my-zsh default install dir
export ZSH="$HOME/.oh-my-zsh"

# Enable auto-update for OMZ
zstyle ':omz:update' enable auto

# QoL configuration
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Load OMZ plugins
plugins=(colored-man-pages colorize git zsh-apple-touchbar zsh-autosuggestions zsh-syntax-highlighting)
if [ `uname` = "Darwin" ]; then
	plugins+=(brew macos)

	# Autocomplete for brew
	FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
  else # If not macOS, then probably Debian-based Linux
	plugins+=(debian)
fi
