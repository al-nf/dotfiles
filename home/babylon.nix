{ pkgs, ... }:
let
  tex = pkgs.texliveMedium.withPackages (
    ps: with ps; [
      amsmath
      float
      caption
      graphics
      biblatex
      biber
    ]
  );
  python = pkgs.python314.withPackages (ps: [ ps.pip ]);
in
{
  imports = [
    ./common.nix
    ../modules/programs/ssh.nix
  ];

  home.homeDirectory = "/Users/afung";

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
    libiconv
    fzf
    nodejs
    clang-tools
    tailscale
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
    sc-im
    tex
    codex
    python
  ];
}
