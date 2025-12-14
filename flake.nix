{
  description = "NixOS + macOS dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen = {
      url = "github:al-nf/zen-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };


  outputs = { self, nixpkgs, home-manager, nixos-wsl, spicetify, zen, ... }:
    let
      forSystem = system: import nixpkgs { inherit system; };
    in {
      nixosConfigurations.petra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        overlays = [
          (self: super: {
            libsForQt5 = super.libsForQt5 // {
              fcitx5-with-addons = super.fcitx5;
            };
          })
        ];
        modules = [
          ./nixos
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.afung = import ./home/petra.nix;
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
          extraSpecialArgs = { inherit spicetify zen; };
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
