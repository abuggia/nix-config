
sh <(curl -L https://nixos.org/nix/install) --daemon

# in nix-config root
nix run nix-darwin -- switch --flake flake.nix

# do this once, then `rebuild` alias is available
darwin-rebuild switch --flake ~/Dropbox/projects/nix-config/flake.nix




