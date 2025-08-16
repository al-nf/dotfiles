{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      env = [
        "HYPRCURSOR_THEME, rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE, 16"
      ];
      exec-once = [
        "swww-daemon"
        "swww-img ~/Pictures/walls/jingliu.png"
        "hyprpanel"
        "hyprctl setcursor rose-pine-hyprcursor 24"
      ];
      monitor =
      [
        "HDMI-A-1, 2560x1440@120, 0x0, 1"
      ];
      "$mod" = "SUPER";
      bind =
      [
        "$mod, W, togglefloating"
        "$mod, F, exec, firefox"
        "$mod, T, exec, kitty"
        "$mod, Q, killactive"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod CTRL, 1, movetoworkspacesilent, 1"
        "$mod CTRL, 2, movetoworkspacesilent, 2"
        "$mod CTRL, 3, movetoworkspacesilent, 3"
        "$mod CTRL, 4, movetoworkspacesilent, 4"
        "$mod CTRL, 5, movetoworkspacesilent, 5"
        "$mod CTRL, 6, movetoworkspacesilent, 6"
        "$mod CTRL, 7, movetoworkspacesilent, 7"
        "$mod CTRL, 8, movetoworkspacesilent, 8"
        "$mod CTRL, 9, movetoworkspacesilent, 9"
        "$mod CTRL, 0, movetoworkspacesilent, 10"


        "$mod, A, exec, rofi -show drun"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      cursor = {
        no_hardware_cursors = 1;
      };
      input = {
        repeat_rate = 60;
        repeat_delay = 200;
      };
      decoration = {
        rounding = 10;
        rounding_power = 2.5;

        blur = {
          enabled = true;
          brightness = 1.0;
          contrast = 1.0;
          noise = 0.01;
          vibrancy = 0.2;
          vibrancy_darkness = 0.5;

          passes = 2;
          size = 7;
        };
        shadow = {
          enabled = true;
          range = 100;
          render_power = 4;
          color = "rgba(1a1a1aee)";
          scale = 0.97;
        };
      };
      animations = {
        enabled = true;
      };
      windowrule = [
        "opacity 0.8 0.8, floating:0"
        "opacity 0.8 0.8, floating:1"
        "opacity 1.0 1.0, class:spotify"
        "opacity 1.0 1.0, class:firefox"
        "float, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      ];

      general = {
        border_size = 2;
        "col.active_border" = "rgba(cceaffee) rgba(52b6ffee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
    };
  };
}
