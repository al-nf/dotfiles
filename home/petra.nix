{
  config,
  pkgs,
  lib,
  zen,
  ...
}:
let
  desktop = import ../modules/theme.nix;
  wallpaperDirectory = "${config.home.homeDirectory}/${desktop.wallpaperDirectory}";
  python = pkgs.python313.withPackages (packages: [ packages.gpustat ]);
in
{
  imports = [
    ../modules/programs/hyprland.nix
    ../modules/programs/desktop-theme.nix
    ../modules/programs/nushell.nix
    ../modules/programs/starship.nix
    ../modules/programs/git.nix
    ../modules/programs/fuzzel.nix
    ../modules/programs/cava.nix
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
  home.homeDirectory = "/home/afung";

  home.stateVersion = "25.05";

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

  programs.home-manager.enable = true;
  xdg.configFile."wayle/styles/index.scss" = {
    text = ".dashboard-dropdown .user-name { text-transform: none; }\n";
    force = true;
  };
  services.wayle = {
    enable = true;
    settings = {
      general.font-sans = desktop.font.family;
      bar.background-opacity = 0;
      bar.button-label-weight = "bold";
      bar.layout = [
        {
          monitor = "HDMI-A-1";
          left = [
            "dashboard"
            "hyprland-workspaces"
            "media"
          ];
          center = [ "clock" ];
          right = [
            "idle-inhibit"
            "systray"
            "network"
            "microphone"
            "volume"
            "notifications"
          ];
        }
      ];
      modules =
        let
          accentButton = {
            border-color = "accent";
            icon-bg-color = "accent";
          };
        in
        lib.genAttrs [
          "clock"
          "media"
          "idle-inhibit"
          "network"
          "microphone"
          "volume"
          "notifications"
        ] (_: accentButton // { label-color = "accent"; })
        // {
          dashboard = accentButton // {
            dropdown-lock-command = "petra-lm-lock";
          };
        };
      wallpaper = {
        engine-enabled = true;
        transition-type = "fade";
        transition-duration = 0.2;
        cycling-enabled = false;
        cycling-directory = wallpaperDirectory;
        monitors = [
          {
            name = "HDMI-A-1";
            wallpaper = "${wallpaperDirectory}/${desktop.defaultTheme.image}";
            fit-mode = "fill";
          }
        ];
      };
    };
  };

  systemd.user.services.wayle.Unit = {
    After = [ "awww.service" ];
    Requires = [ "awww.service" ];
  };

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
