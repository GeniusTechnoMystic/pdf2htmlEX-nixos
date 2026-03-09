# AI Agent Directives for pdf2htmlEX-nixos

You are an AI coding assistant interacting with a **NixOS-optimized fork** of `pdf2htmlEX`. You must adhere strictly to the following architectural rules:

## 1. The "Nix Way" is Absolute
- **NEVER** suggest using `apt-get`, `dnf`, `pacman`, `brew`, or `apk` to install dependencies. 
- **NEVER** suggest running `make`, `cmake`, or `make install` manually on the host system.
- All dependencies, environment variables, and compiler flags are strictly managed via `flake.nix` and `nixos/package.nix`.
- To test compilation, exclusively use: `nix build .#pdf2htmlEX`
- To test the binary, exclusively use: `./result/bin/pdf2htmlEX <args>`

## 2. Directory Standardization
- The root directory (`/`) must remain as close to upstream `pdf2htmlEX` as possible to ensure painless `git merge upstream/master` operations in the future.
- **ALL** Nix-specific logic, documentation, and overrides MUST live inside the `/nixos/` subdirectory (with the sole exception of the root `flake.nix` and `flake.lock`).

## 3. The Poppler 24.02.0 Boundary
- This project relies on internal Poppler APIs that were deleted in Poppler 24.10.0+ (specifically the `CharCodeToUnicode` class). 
- **NEVER** attempt to update the `nixpkgs-legacy` input in `flake.nix` to a branch that utilizes Poppler >= 24.10.0. The build environment must remain pinned to Poppler 24.x (currently provided via `nixos-24.11`).
- We perform static sub-builds of Poppler and FontForge in the `preConfigure` phase to access hidden `.a` archive symbols. Do not attempt to link against shared `.so` system libraries for these two dependencies.
