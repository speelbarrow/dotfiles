{ ... }: [''
if [ -n "$IN_NIX_SHELL" ]
then
  export PS1="''${PS1}[nix] "
fi
'']
