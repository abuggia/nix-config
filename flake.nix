{
  description = "abuggia nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, ... }: {
    darwinConfigurations.adam-m2 = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [

        #./configuration.nix
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

        home-manager.darwinModules.home-manager

        ./hosts/adam-m2.mix
      ];
    };
  };
}
