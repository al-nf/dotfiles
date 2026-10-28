{
  description = "NixOS + macOS dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      spicetify,
      zen,
      ...
    }:
    let
      petraModules = [
        ./home/petra.nix
        ./modules/programs/spicetify.nix
      ];
      petraSpecialArgs = { inherit spicetify zen; };
      forSystem =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      nixosConfigurations.petra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = petraSpecialArgs;
            home-manager.users.afung.imports = petraModules;
          }
        ];
      };

      homeConfigurations = {
        petra = home-manager.lib.homeManagerConfiguration {
          pkgs = forSystem "x86_64-linux";
          extraSpecialArgs = petraSpecialArgs;
          modules = petraModules;
        };

        babylon = home-manager.lib.homeManagerConfiguration {
          pkgs = forSystem "aarch64-darwin";
          modules = [
            ./home/babylon.nix
          ];
        };
      };
    };
}
