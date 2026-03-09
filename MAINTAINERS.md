# Maintainers Guide

This repository is a NixOS-optimized fork of `pdf2htmlEX`.

## Canonical maintenance docs
- Nix-specific maintenance workflow and constraints: [`nixos/docs/MAINTAINERS.md`](./nixos/docs/MAINTAINERS.md)
- Project roadmap/tasks: [`nixos/docs/ProjectTaskPlan.md`](./nixos/docs/ProjectTaskPlan.md)

## Repository guardrails
- Keep root layout as close to upstream as possible for easier upstream merges.
- Keep Nix-specific packaging and operational details under `nixos/` (except `flake.nix` / `flake.lock`).

## Validation commands
- Build: `nix build .#pdf2htmlEX`
- Binary smoke test: `./result/bin/pdf2htmlEX --version`
