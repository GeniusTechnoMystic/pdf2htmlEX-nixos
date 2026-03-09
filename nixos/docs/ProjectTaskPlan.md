# 🌌 Project Task Plan: pdf2htmlEX-nixos

**Vision:** To provide a modern, Flake-based, highly-reproducible version of pdf2htmlEX optimized for NixOS 25.11 while maintaining a clean inheritance path from the community upstream.

---

## 🏗️ Phase 1: Nix Core & Reproducibility
*Goal: Establish a functional, sandboxed build environment.*

- [ ] **Task 1.1: Define the Package (`nixos/package.nix`)**
  - Map upstream dependencies (Poppler, FontForge, etc.) to Nixpkgs 25.11 equivalents.
  - Implement `cmakeFlags` to handle Nix-specific `$out` paths.
  - *Success Criteria:* `nix-build` succeeds without network access during the build phase.

- [ ] **Task 1.2: Root Flake Integration (`flake.nix`)**
  - Create the entry point in the root directory.
  - Configure `src = ./.` to ensure local changes are picked up.
  - Call `./nixos/package.nix` for the default package output.
  - *Success Criteria:* `nix build .#pdf2htmlEX` generates a working binary in `./result/bin/`.

- [ ] **Task 1.3: Development Shell (`devShells`)**
  - Define a `nix develop` environment containing all build-time dependencies.
  - *Success Criteria:* `cmake .. && make` works natively inside the `nix develop` shell.

---

## 📖 Phase 2: Documentation & Identity
*Goal: Clarify the fork's purpose and align AI agents.*

- [ ] **Task 2.1: Prepend NixOS instructions to `README.md`**
  - Add "Quick Start" for NixOS users.
  - Document the Flake URI: `github:youruser/pdf2htmlEX-nixos/nixos-package`.

- [ ] **Task 2.2: Create `AGENTS.md`**
  - Define instructions for AI coding assistants (Cursor/Windsurf) to prioritize Nix-native workflows.
  - Mandate use of `nix build` over `apt-get` or manual `make` for testing.

- [ ] **Task 2.3: Standardize the `nixos/` directory**
  - Ensure all Nix logic remains in the `nixos/` subdirectory to keep the root clean for upstream merges.

---

## 🤖 Phase 3: CI/CD & Automation
*Goal: Automate verification and ease user adoption.*

- [ ] **Task 3.1: Implement Nix GitHub Action**
  - Create `.github/workflows/nix.yml`.
  - Use `cachix/install-nix-action` to verify the flake on every push to `nixos-package`.

- [ ] **Task 3.2: (Optional) Binary Caching**
  - Set up a Cachix push-pull mechanism to avoid long FontForge/Poppler compilation times for end-users.

---

## 🔄 Phase 4: Upstream Synchronization
*Goal: Maintain longevity through inheritance.*

- [ ] **Task 4.1: Document the Sync Protocol**
  - Create a guide for merging `upstream/master` into `nixos-package`.
  - Handle potential conflicts in `CMakeLists.txt` or `.github/` folders.

- [ ] **Task 4.2: Regular Maintenance**
  - Update `flake.lock` periodically to track NixOS 25.11 security patches.
