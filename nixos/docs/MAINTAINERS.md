# Maintainers Guide

This fork is optimized for Nix/NixOS reproducibility while keeping root layout close to upstream `pdf2htmlEX`.

---

## Canonical maintenance docs
- Top-level maintainer entrypoint: [`MAINTAINERS.md`](../../MAINTAINERS.md)
- Project roadmap/tasks: [`nixos/docs/ProjectTaskPlan.md`](./ProjectTaskPlan.md)

---

## Scope boundaries
- Keep upstream-like source in repository root (`pdf2htmlEX/`, historical docs/scripts).
- Keep Nix-specific packaging and operational docs in `nixos/` (except root `flake.nix` and `flake.lock`).

---

## Upstream sync protocol
1. Add/fetch upstream remote and merge `upstream/master` into your working branch.
```bash
   git remote add upstream [https://github.com/pdf2htmlEX/pdf2htmlEX.git](https://github.com/pdf2htmlEX/pdf2htmlEX.git)
   git fetch upstream
   git checkout -b sync-upstream-$(date +%F)
   git merge upstream/master
```

2. Resolve conflicts with priority order:
   - Preserve upstream behavior in root paths where possible.
   - Re-apply Nix-specific deltas in `nixos/package.nix` and `flake.nix`.
   - **CMakeLists.txt:** If upstream updates the Poppler requirement, reject those changes. We must remain linked to Poppler 24.02.0 to preserve the CharCodeToUnicode dependency. If upstream modifies library detection, verify that the `sed` and `substituteInPlace` logic in `nixos/package.nix` still targets the correct lines.
   - **package.nix:** Add any new dependencies introduced by upstream to the `buildInputs`.
   - **Nix Files:** Ensure nixos/ and flake.nix are never overwritten by upstream’s non-Nix CI/CD files.

3. Re-run build validation using only:
   - `nix build .#pdf2htmlEX`
   - `./result/bin/pdf2htmlEX --version`

---

## Critical compatibility boundary
- Do **not** move `nixpkgs-legacy` beyond a Poppler line that removed `CharCodeToUnicode` (24.10+ breakage).
- Current intended boundary: Poppler 24.02.0 from `nixos-24.11`.

---

## ❄️ Nix Maintenance & Security

Even if upstream is silent, the Nix ecosystem must be updated periodically for security patches.

### 1. Updating Dependencies

Run this monthly to update `cmake`, `glibc`, and build tools:

```bash
nix flake update

```

*Note: Because `pkgs-legacy` is pinned to `nixos-24.11`, this will NOT move Poppler or FontForge past their safe versions.*

---

## Binary Cache Maintenance

This project uses **Cachix** to store pre-compiled binaries.

* **Manual Push:** If you make significant changes to the Nix expressions locally:
`nix build .#pdf2htmlEX && cachix push pdf2htmlex-nixos ./result`

* **CI/CD:** GitHub Actions automatically push to Cachix on every push to the `nixos-package` branch.

---

## 🤖 AI Agent Guardrails

Maintainers should ensure that the `AGENTS.md` file remains updated. Any new C++ dependencies must be added to `nixos/package.nix` rather than being installed imperatively.

---

## Release hygiene
- Keep Cachix key/name in `flake.nix` and CI workflow aligned.
- Update `flake.lock` intentionally (security and dependency maintenance), then verify build + smoke test.

---

## Project identity checklist
Before each release, verify:
- Metadata links point to this repository.
- README maintenance links resolve.
- `nix build .#pdf2htmlEX` and `./result/bin/pdf2htmlEX --version` pass in CI.
