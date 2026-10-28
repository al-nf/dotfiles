{
  config,
  lib,
  pkgs,
  ...
}:
let
  desktop = import ../theme.nix;
  inherit (desktop) themes;
  palette = {
    bg = desktop.colors.base;
    surface = desktop.colors.surface0;
    elevated = desktop.colors.surface1;
    fg = desktop.colors.text;
    fg-muted = desktop.colors.subtext0;
    inherit (desktop.colors)
      red
      yellow
      green
      blue
      ;
  };
  definitions = pkgs.writeText "desktop-themes.json" (
    builtins.toJSON {
      default = desktop.defaultThemeName;
      commands = {
        wayle = lib.getExe pkgs.wayle;
        hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
      };
      themes = map (theme: {
        inherit (theme) name;
        wallpaper = "${config.home.homeDirectory}/${desktop.wallpaperDirectory}/${theme.image}";
        palette = palette // {
          primary = builtins.head theme.colors;
        };
        hyprland = "hl.config(${
          lib.generators.toLua { } {
            general.col.active_border = {
              colors = map (color: "rgb(${lib.removePrefix "#" color})") theme.colors;
              angle = desktop.borderAngle;
            };
          }
        })";
      }) themes;
    }
  );
  switcher = pkgs.writeShellScriptBin "desktop-theme" ''
    exec ${pkgs.python313}/bin/python3 ${./desktop-theme.py} ${definitions} "$@"
  '';
in
{
  home.packages = [ switcher ];

  wayland.windowManager.hyprland.extraConfig = ''
    local theme_state = os.getenv("XDG_STATE_HOME") or (os.getenv("HOME") .. "/.local/state")
    local theme_file = theme_state .. "/desktop-theme/active-border.lua"
    local saved_theme = io.open(theme_file, "r")
    if saved_theme then
      saved_theme:close()
      dofile(theme_file)
    end
  '';

  systemd.user.services.desktop-theme = {
    Unit = {
      Description = "Restore the selected desktop theme";
      After = [
        config.wayland.systemd.target
        "wayle.service"
      ];
      Requires = [ "wayle.service" ];
      PartOf = [ config.wayland.systemd.target ];
      StartLimitIntervalSec = 30;
      StartLimitBurst = 5;
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${switcher}/bin/desktop-theme restore";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };
}
