{
  description = "pdf2htmlEX NixOS 25.11 fork, a hermetic, reproducible PDF to HTML converter";

  # This block tells Nix where to find the pre-compiled binaries
  nixConfig = {
    extra-substituters = [
      "https://pdf2htmlex-nixos.cachix.org"
    ];
    extra-trusted-public-keys = [
      "pdf2htmlex-nixos.cachix.org-1:pdf2htmlex-nixos.cachix.org-1:TT2BBbTqyRdVdfmgY2/OW11liW9t4Z7XSdYJLUg2Dyg="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # NixOS 24.11 natively contains the perfect Poppler 24.02.0
    nixpkgs-legacy.url = "github:NixOS/nixpkgs/nixos-24.11";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-legacy, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Instantiate the highly-stable 24.11 build environment
        pkgs-legacy = import nixpkgs-legacy { inherit system; };
      in
      {
        # This allows users to run: nix build github:youruser/pdf2htmlEX-nixos
        packages.pdf2htmlEX = pkgs-legacy.callPackage ./nixos/package.nix { };
        packages.default = self.packages.${system}.pdf2htmlEX;

        # For development: nix develop
        devShells.default = pkgs-legacy.mkShell {
          inputsFrom = [ self.packages.${system}.pdf2htmlEX ];

          nativeBuildInputs = with pkgs; [ cmake pkg-config cachix ];

          #buildInputs = self.packages.${system}.pdf2htmlEX.buildInputs;
          buildInputs = with pkgs; [ gdb strace ];

          shellHook = ''
            echo "❄️ pdf2htmlEX Dev Shell Loaded"
            echo "📦 Active Cache: https://pdf2htmlex-nixos.cachix.org"
          '';

        };
      }
    );
}
