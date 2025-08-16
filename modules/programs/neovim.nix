{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    extraConfig =
    ''

    '';
  };

  home.file.".config/nvim" = {
    source = ./neovim; 
    recursive = true;
  };
}

