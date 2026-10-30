{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      nerd-fonts.jetbrains-mono
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      corefonts
    ];
}
