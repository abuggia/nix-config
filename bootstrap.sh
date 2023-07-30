
sh <(curl -L https://nixos.org/nix/install) --daemon

# in the project dir, run this
nix run nix-darwin -- switch --flake flake.nix

# then we can use `darwin-rebuild`
darwin-rebuild switch --flake ~/Dropbox/projects/macos-config/flake.nix

# Then you can run `darwin-rebuild` going forwa
# Which has the alias `rebuild`



