{ lib, pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      nerd-fonts.jetbrains-mono
      maple-mono.NF
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      corefonts
    ];
}
