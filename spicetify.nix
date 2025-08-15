{ pkgs, lib, spicetify-nix, ... }:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ spicetify-nix.homeManagerModules.default ];

  programs.spicetify =
  {
    enable = true;
    theme = spicePkgs.themes.comfy;

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle 
      hidePodcasts
      powerBar
    ];
    wayland = true;
    windowManagerPatch = true;
  };
}
