{ lib, pkgs, ... }:
{
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.xdg-utils ];

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = [ pkgs.tree-sitter ];
  };

  home.file.".config/nvim" = {
    source = ./neovim;
    recursive = true;
  };
}
