{ pkgs, ... }: {
  home.packages = [
    (if pkgs.stdenv.isDarwin then 
      (with pkgs; stdenv.mkDerivation {
        inherit (vesktop) meta pname;
        version = "1.6.5";
        src = fetchurl {
          name = "Vesktop.dmg";
          url = "https://vencord.dev/download/vesktop/universal/dmg";
          hash = "sha256-mmPmovVyU8y0olrHuZBGZUo53HvFXghhmVeZLTSIfpM=";
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
