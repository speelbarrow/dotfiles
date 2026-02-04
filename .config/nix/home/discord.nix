{ pkgs, ... }: {
  home.packages = [
    (if pkgs.stdenv.isDarwin then 
      (with pkgs; stdenv.mkDerivation {
        inherit (vesktop) meta pname version;
        src = fetchurl {
          name = "Vesktop.dmg";
          url = "https://vencord.dev/download/vesktop/universal/dmg";
          hash = "sha256-LxX1CAdgg5b0uUgLjqs1vhyLT1J2Tgj4Pz0vEMFFp7o=";
        };
        nativeBuildInputs = [ undmg ];
        sourceRoot = ".";
        installPhase = ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -R Vesktop.app $out/Applications
        runHook postInstall
        '';
      }) 
    else pkgs.vesktop)
  ];
  programs.nixvim.plugins.cord = {
    enable = true;
  };
}
