# Repository Guidelines

## Project Structure & Module Organization
- `flake.nix` defines the Nix flake entrypoint, `darwinConfigurations.adam-m2`, and a dev shell.
- `modules/darwin/default.nix` contains the nix-darwin system module (system packages, fonts, homebrew, defaults).
- `users/adam/home.nix` is the Home Manager config for the `adam` user.
- User dotfiles live alongside the user config, e.g. `users/adam/.zshrc` and `users/adam/tmux.conf`.
- `bootstrap.sh` documents initial setup steps; `iterm-profile.json` stores terminal profile settings.

## Build, Test, and Development Commands
- `nix develop` enters the dev shell (includes `codex`).
- `nix run nix-darwin -- switch --flake ./flake.nix` applies the current flake to the host.
- `darwin-rebuild switch --flake .#adam-m2` applies the configured host after nix-darwin is installed.
- `nix flake update` updates flake inputs (expect changes in `flake.lock`).

## Coding Style & Naming Conventions
- Use 2-space indentation in Nix files, matching the existing modules.
- Keep system-wide configuration in `modules/`, per-user configuration in `users/<name>/`.
- Prefer lowercase, descriptive filenames (e.g., `home.nix`, `default.nix`); keep related dotfiles near their owner.

## Testing Guidelines
- No automated tests are defined in this repo.
- Use `darwin-rebuild switch --flake .#adam-m2` as the primary verification step when changing system settings.
- For Nix-level validation, run `nix flake check` if you add checks later.

## Commit & Pull Request Guidelines
- Commit messages are short, lowercase phrases (examples: "update neovim", "flake updates", "clean up").
- Keep commits focused on a single change area when possible.
- PRs should include a brief summary, the commands run (e.g., `darwin-rebuild switch --flake .#adam-m2`), and any expected behavioral changes.
- Include screenshots only when changing visual tooling (e.g., iTerm profile updates).
