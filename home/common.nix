{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./fonts.nix
    ../modules/programs/nushell.nix
    ../modules/programs/starship.nix
    ../modules/programs/git.nix
    ../modules/programs/kitty.nix
    ../modules/programs/neovim.nix
    ../modules/programs/zed.nix
  ];

  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home.username = "afung";
  # Keep the compatibility version fixed when updating Home Manager.
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
