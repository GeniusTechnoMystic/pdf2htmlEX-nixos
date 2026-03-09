# Maintainer's Guide & Sync Protocol

This document outlines how to keep this Nix-powered fork synchronized with the upstream `pdf2htmlEX` repository.

## Upstream Synchronization (The Sync Protocol)
To pull in the latest changes OR BUGFIXES from the original `pdf2htmlEX` repository while preserving the Nix build logic:

1. **Add the Upstream Remote** (if not already present):
```bash
   git remote add upstream [https://github.com/pdf2htmlEX/pdf2htmlEX.git](https://github.com/pdf2htmlEX/pdf2htmlEX.git)
```

2. **The Clean-Merge/Sync Workflow:**
```bash
   git fetch upstream
   git checkout -b sync-upstream-$(date +%F)
   git merge upstream/master

```

3. **Critical Conflict Resolution:**
* **CMakeLists.txt:** If upstream updates the Poppler requirement, reject those changes. We must remain linked to Poppler 24.02.0 to preserve the CharCodeToUnicode dependency. If upstream modifies library detection, verify that the `sed` and `substituteInPlace` logic in `nixos/package.nix` still targets the correct lines.
* **package.nix:** Add any new dependencies introduced by upstream to the `buildInputs`.
* **Nix Files:** Ensure nixos/ and flake.nix are never overwritten by upstream’s non-Nix CI/CD files.

---

## ❄️ Nix Maintenance & Security

Even if upstream is silent, the Nix ecosystem must be updated periodically for security patches.

### 1. Updating Dependencies

Run this monthly to update `cmake`, `glibc`, and build tools:

```bash
nix flake update

```

*Note: Because `pkgs-legacy` is pinned to `nixos-24.11`, this will NOT move Poppler or FontForge past their safe versions.*

### 2. Binary Cache Management (Cachix)

This project uses **Cachix** to store pre-compiled binaries.

* **Manual Push:** If you make significant changes to the build process, manually push to the cache to save CI time:

```bash
nix build .#pdf2htmlEX
cachix push pdf2htmlex-nixos ./result
```

* **CI/CD:** GitHub Actions automatically push to Cachix on every push to the `nixos-package` branch.

---

## 🤖 AI Agent Guardrails

Maintainers should ensure that the `AGENTS.md` file remains updated. Any new C++ dependencies must be added to `nixos/package.nix` rather than being installed imperatively.

---

## Binary Cache Maintenance

This project uses **Cachix** to store pre-compiled binaries.

* **Manual Push:** If you make significant changes to the Nix expressions locally:
`nix build .#pdf2htmlEX && cachix push pdf2htmlex-nixos ./result`

* **CI/CD:** GitHub Actions automatically push to Cachix on every push to the `nixos-package` branch.
