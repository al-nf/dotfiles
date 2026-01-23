{ pkgs, lib, spicetify, ... }:
let
  spicePkgs = spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ spicetify.homeManagerModules.default ];

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
