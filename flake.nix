{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          localSystem = "${system}";
        };
        env = pkgs.stdenv;

        buildInputs = with pkgs; with xorg; [
          libX11
          libXinerama
          libXft
        ];

        dwm = env.mkDerivation {
          name = "dwm";
          src = self;
          buildInputs = buildInputs;
          installPhase = ''
            mkdir -p $out/bin
            mv dwm $out/bin
          '';
        };

      in
      {
        devShell = env.mkDerivation {
          buildInputs = buildInputs;
        };

        packages = {
          dwm = dwm;
          default = dwm;
        };
      }
    );
}
