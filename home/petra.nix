{
  pkgs,
  zen,
  ...
}:
let
  python = pkgs.python313.withPackages (packages: [ packages.gpustat ]);
in
{
  imports = [
    ./common.nix
    ../modules/programs/hyprland.nix
    ../modules/programs/desktop-theme.nix
    ../modules/programs/fuzzel.nix
    ../modules/programs/cava.nix
    ../modules/programs/spicetify.nix
    ../modules/programs/wayle.nix
  ];

  _module.args.desktopMonitor = {
    output = "HDMI-A-1";
    mode = "2560x1440@120";
    position = "0x0";
    scale = 1;
  };

  home.homeDirectory = "/home/afung";

  home.pointerCursor = {
    enable = true;
    package = pkgs.rose-pine-hyprcursor;
    name = "rose-pine-hyprcursor";
    size = 24;
    hyprcursor.enable = true;
  };

  home.packages = with pkgs; [
    (callPackage ../packages/petra-lm { })
    fastfetch
    pavucontrol
    piper
    openrgb
    hyprshot
    ripgrep
    vivid
    btop
    ffmpeg
    corefonts
    nh
    tela-circle-icon-theme
    nerd-fonts.jetbrains-mono
    fzf
    tailscale
    gnumake
    gh
    discord
    mosh
    rustup
    devenv
    uv
    ruff
    unzip
    bun
    zellij
    fd
    git-lfs
    nvtopPackages.nvidia
    desktop-file-utils
    olympus
    reptyr
    codex
    bubblewrap
    nixfmt

    python

    zen.packages.${pkgs.stdenv.hostPlatform.system}.beta
  ];

  xdg.desktopEntries.olympus = {
    name = "Olympus";
    comment = "Celeste Mod Manager";
    exec = "steam-run olympus %u";
    icon = "olympus";
    terminal = false;
    categories = [
      "Game"
      "Application"
    ];
    mimeType = [ "x-scheme-handler/everest" ];
  };
}
