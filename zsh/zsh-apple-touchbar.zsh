source $ZSH_CUSTOM/plugins/zsh-apple-touchbar/functions.zsh

if [ -e $HOME/.zsh-apple-touchbar.zsh.local ]; then
	source $HOME/.zsh-apple-touchbar.zsh.local
else
	function local_touchbar {}
fi

set_state 'default'

function default_view() {
	remove_and_unbind_keys

	set_state 'default'

	for i in {1..24}
	do
		print_key "\033]1337;SetKeyLabel=F$i= \a"
	done

	create_key 1 'status' 'git status' '-s'
	create_key 2 'commit all and push' 'git add .; git commit; git push' '-s'
	create_key 3 'commit and push' 'git commit; git push' '-s'
	local_touchbar 4
}

zle -N default_view

precmd_apple_touchbar() {
	case $state in
		default) default_view ;;
	esac
}

autoload -Uz add-zsh-hook

add-zsh-hook precmd precmd_apple_touchbar
