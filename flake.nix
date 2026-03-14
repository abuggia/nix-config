{
  description = "abuggia nix configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    adam-neovim.url = "github:abuggia/neovim-flake/";
    adam-neovim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, adam-neovim, nix-index-database, ... }:
  let 
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    darwinConfigurations.adam-m2 = nix-darwin.lib.darwinSystem {
      system = system;
      modules = [
        ./modules/darwin

        home-manager.darwinModules.home-manager {
          # fix for: https://github.com/nix-community/home-manager/issues/4026
          users.users.adam.home = "/Users/adam"; 

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit adam-neovim; };
            users.adam = import ./users/adam/home.nix;
          };
        }

        # TODO: need this for comma
        # nix-index-database.hmModules.nix-index
      ];

    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [ pkgs.codex ];
      shellHook = ''
        echo "Environment Loaded!"
      '';
    };
  };
}
