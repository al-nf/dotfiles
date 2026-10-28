{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;

    extraConfig = ''

    '';
  };

  home.file.".config/nvim" = {
    source = ./neovim;
    recursive = true;
  };
}
