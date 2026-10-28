{ config, pkgs, lib, ... }:
let
  tex = (pkgs.texliveMedium.withPackages (
    ps: with ps; [
      amsmath float caption graphics biblatex biber
    ]
  ));
in
let
  py = (pkgs.python314.withPackages (
    ps: with ps; [
      pip
    ]
  ));
in
{
  imports = 
  [
    ../modules/programs/nushell.nix
    ../modules/programs/starship.nix
    ../modules/programs/git.nix
    ../modules/programs/kitty.nix
    ../modules/programs/neovim.nix
    ../modules/programs/ssh.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "afung";
  home.homeDirectory = "/Users/afung";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    fastfetch
    ripgrep
    vivid
    btop
    nh
    gh
    gcc
    nerd-fonts.jetbrains-mono
    vscode
    lua
    asm-lsp
    rustup
    go
    uv
    virtualenv
    bun
    devenv
    direnv
    libiconv
    zoxide
    fzf
    carapace
    nodejs
    clang-tools
    tailscale
    hyperfine
    docker
    typst
    bear
    meson
    wget
    ninja
    mosh
    pandoc
    ocaml
    opam
    sqlite
    ddgr
    sc-im
    tex
    codex
    py



    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/afung/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    #EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
