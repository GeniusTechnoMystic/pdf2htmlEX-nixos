# Maintainers Guide

This fork is optimized for Nix/NixOS reproducibility while keeping root layout close to upstream `pdf2htmlEX`.

## Scope boundaries
- Keep upstream-like source in repository root (`pdf2htmlEX/`, historical docs/scripts).
- Keep Nix-specific packaging and operational docs in `nixos/` (except root `flake.nix` and `flake.lock`).

## Upstream sync protocol
1. Add/fetch upstream remote and merge `upstream/master` into your working branch.
2. Resolve conflicts with priority order:
   - Preserve upstream behavior in root paths where possible.
   - Re-apply Nix-specific deltas in `nixos/package.nix` and `flake.nix`.
3. Re-run build validation using only:
   - `nix build .#pdf2htmlEX`
   - `./result/bin/pdf2htmlEX --version`

## Critical compatibility boundary
- Do **not** move `nixpkgs-legacy` beyond a Poppler line that removed `CharCodeToUnicode` (24.10+ breakage).
- Current intended boundary: Poppler 24.02.0 from `nixos-24.11`.

## Release hygiene
- Keep Cachix key/name in `flake.nix` and CI workflow aligned.
- Update `flake.lock` intentionally (security and dependency maintenance), then verify build + smoke test.

## Project identity checklist
Before each release, verify:
- Metadata links point to this repository.
- README maintenance links resolve.
- `nix build .#pdf2htmlEX` and `./result/bin/pdf2htmlEX --version` pass in CI.
