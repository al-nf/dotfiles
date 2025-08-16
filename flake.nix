{
  description = "NixOS dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };
  outputs = { nixpkgs, home-manager, spicetify-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.petra = nixpkgs.lib.nixosSystem {
        inherit system;
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

      homeConfigurations = {
        afung = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit spicetify-nix;};
          modules = [ 
            ./home

            ./modules/programs/spicetify.nix
          ];
        };
      };
    };
}
