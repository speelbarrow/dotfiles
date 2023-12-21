function update {
	brew update
	brew upgrade --greedy
	brew autoremove
	brew cleanup
        bun update -g
 	python3 -m pip list --outdated --format=json | jq -r '.[] | "\(.name)==\(.latest_version)"' | xargs -n1 pip3 install -U
	rustup update
	nvim +'Lazy update' +qa
}
