{
  description = "NixOS + macOS dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify.url = "github:Gerg-L/spicetify-nix";
    zen-browser.url = "github:al-nf/zen-flake";
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, spicetify, zen-browser, ... }:
    let
      forSystem = system: import nixpkgs { inherit system; };
    in {
      nixosConfigurations.petra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.afung = import ./home;
          }
        ];
      };

      nixosConfigurations.pharos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          ./nixos/pharos.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.afung = import ./home/pharos.nix;
          }
        ];
      };

      homeConfigurations = {
        petra = home-manager.lib.homeManagerConfiguration {
          pkgs = forSystem "x86_64-linux";
          extraSpecialArgs = { inherit spicetify zen-browser; };
          modules = [
            ./home/petra.nix
            ./modules/programs/spicetify.nix
          ];
        };

        babylon = home-manager.lib.homeManagerConfiguration {
          pkgs = forSystem "aarch64-darwin";
          modules = [
            ./home/babylon.nix
          ];
        };

        pharos = home-manager.lib.homeManagerConfiguration {
          pkgs = forSystem "x86_64-linux";
          modules = [
            ./home/pharos.nix
          ];
        };
      };
    };
}
