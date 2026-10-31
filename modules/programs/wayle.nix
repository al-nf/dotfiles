{
  config,
  lib,
  desktopMonitor,
  ...
}:
let
  desktop = import ../theme.nix;
  wallpaperDirectory = "${config.home.homeDirectory}/${desktop.wallpaperDirectory}";
in
{
  xdg.configFile."wayle/styles/index.scss" = {
    text = ".dashboard-dropdown .user-name { text-transform: none; }\n";
    force = true;
  };
  services.wayle = {
    enable = true;
    settings = {
      general.font-sans = desktop.font.family;
      bar = desktop.spacing.bar // {
        background-opacity = 0;
        button-label-weight = "bold";
        layout = [
          {
            monitor = desktopMonitor.output;
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
      };
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
            name = desktopMonitor.output;
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
}
