{ config, pkgs, lib, ... }:

{
  imports = 
  [
    ../modules/programs/nushell.nix
    ../modules/programs/starship.nix
    ../modules/programs/git.nix
    ../modules/programs/cava.nix
    ../modules/programs/neovim.nix
    ../modules/programs/ssh.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  home.username = "afung";
  home.homeDirectory = "/home/afung";

  home.stateVersion = "25.05";

  home.packages = [
    pkgs.fastfetch
    pkgs.ripgrep
    pkgs.vivid
    pkgs.btop
    pkgs.nh
    pkgs.gh
    pkgs.gcc
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.vscode
    pkgs.lua
    pkgs.asm-lsp
    pkgs.rustup
    pkgs.go
    pkgs.python313
    pkgs.python313Packages.pip
    pkgs.virtualenv
    pkgs.bun
    pkgs.devenv
    pkgs.direnv
    pkgs.libiconv
    pkgs.zoxide
    pkgs.fzf
    pkgs.carapace
    pkgs.nodejs
    pkgs.clang-tools
    pkgs.awscli2
    pkgs.awsebcli
    pkgs.wslu  # WSL utilities
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
}
