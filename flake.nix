{
  description = "abuggia nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    adam-neovim.url = "github:abuggia/neovim-flake/a22a30a0cd7b25e9973f98369ad09cc1bd1f44e3";
    adam-neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, adam-neovim, ... }:
    {
      darwinConfigurations.adam-m2 = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [

          ({ pkgs, ... }: {

            # Auto upgrade nix package and the daemon service.
            services.nix-daemon.enable = true;
            nix.settings.experimental-features = "nix-command flakes";

            # Create /etc/zshrc that loads the nix-darwin environment.
            programs.zsh.enable = true;
            environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
            environment.loginShell = pkgs.zsh;

            #?? Set Git commit hash for darwin-version.
            #system.configurationRevision = self.rev or self.dirtyRev or null;
            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 4;
          })

          home-manager.darwinModules.home-manager {

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit adam-neovim; };

              # users.users.adam.home = "/Users/adam"; # https://github.com/nix-community/home-manager/issues/4026
              users.adam = import ./hosts/adam-m2.nix;
            };

          }
        ];
      };
    };
}
