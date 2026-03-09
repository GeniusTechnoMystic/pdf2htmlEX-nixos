{
  description = "pdf2htmlEX NixOS 25.11 fork, a high-fidelity PDF to HTML conversion tool";

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

          nativeBuildInputs = with pkgs; [ cmake pkg-config ];

          #buildInputs = self.packages.${system}.pdf2htmlEX.buildInputs;
          buildInputs = with pkgs; [ gdb strace ];
        };
      }
    );
}
