# 🌌 Project Task Plan: pdf2htmlEX-nixos

**Vision:** To provide a modern, Flake-based, highly-reproducible version of pdf2htmlEX optimized for NixOS 25.11 while maintaining a clean inheritance path from the community upstream.

---

## ✅ Phase 1: Nix Core & Reproducibility (COMPLETED)
*Goal: Establish a functional, sandboxed build environment.*

- [x] **Task 1.1: Define the Package (`nixos/package.nix`)**
  - Map upstream dependencies to Nixpkgs equivalents.
  - Implement static sub-builds for Poppler and FontForge to expose internal, undocumented C++ headers and ABI symbols required by the engine.
  - Inject `pkg-config` variables into CMake to securely resolve GLib/GIO and LibXML2 paths in the Nix sandbox.
  - *Success Criteria:* `nix-build` succeeds without network access during the build phase.

- [x] **Task 1.2: Root Flake Integration (`flake.nix`)**
  - Create the entry point in the root directory.
  - Implement a "Legacy Escape Hatch" by pinning the C++ toolchain to `nixos-24.11` (Poppler 24.02.0) to safely bypass the upstream deletion of `CharCodeToUnicode`.
  - *Success Criteria:* `nix build .#pdf2htmlEX` generates a working binary in `./result/bin/`.

- [x] **Task 1.3: Development Shell (`devShells`)**
  - Define a `nix develop` environment containing all build-time dependencies (`cmake`, `python3`, `jre_headless`, etc.).
  - *Success Criteria:* Environment natively supports the compilation pipeline.
---

## 🚧 Phase 2: Documentation & Identity
*Goal: Clarify the fork's purpose and align AI agents.*

- [x] **Task 2.1: Prepend NixOS instructions to `README.md`**
  - Add "Quick Start" for NixOS users.
  - Document the Flake URI and explain *why* the Flake is necessary (the Poppler API break).

- [x] **Task 2.2: Create `AGENTS.md`**
  - Define instructions for AI coding assistants (Cursor/Windsurf) to prioritize Nix-native workflows.
  - Mandate use of `nix build` over `apt-get` or manual `make` for testing.

- [x] **Task 2.3: Standardize the `nixos/` directory**
  - Ensure all Nix logic remains in the `nixos/` subdirectory to keep the root clean for upstream merges.

---

## ⏳ Phase 3: CI/CD & Automation
*Goal: Automate verification and ease user adoption.*

- [x] **Task 3.1: Implement Nix GitHub Action**
  - Create `.github/workflows/nix.yml`.
  - Use `cachix/install-nix-action` to verify the flake on every push.

- [x] **Task 3.2: Binary Caching (High Priority)**
  - Set up a Cachix push-pull mechanism.
  - *Note:* Because we compile Poppler and FontForge statically from source, binary caching is critical to avoid 5+ minute compile times for end-users.

---

## 🔮 Phase 4: Upstream Synchronization
*Goal: Maintain longevity through inheritance.*

- [x] **Task 4.1: Document the Sync Protocol**
  - Create a guide for merging `upstream/master` into `nixos-package`.
  - Handle potential conflicts in `CMakeLists.txt` or `.github/` folders.

- [x] **Task 4.2: Regular Maintenance & Version Locking**
  - Update host `flake.lock` periodically for security patches.
  - **CRITICAL:** The `nixpkgs-legacy` input MUST remain pinned to a version providing Poppler <= 24.09.0 unless upstream completely rewrites their font extraction logic to remove the `CharCodeToUnicode` dependency.
