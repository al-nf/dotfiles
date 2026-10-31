{
  config,
  lib,
  desktopMonitor,
  ...
}:
let
  desktop = import ../theme.nix;
  lua = lib.generators.mkLuaInline;
  screenshot = mode: "hl.dsp.exec_cmd('hyprshot -m ${mode} -o ~/Pictures/Screenshots')";
  bind = keys: dispatcher: {
    _args = [
      "SUPER + ${keys}"
      (lua dispatcher)
    ];
  };
  startupCommands = [
    "hyprctl setcursor ${lib.escapeShellArg config.home.pointerCursor.name} ${toString config.home.pointerCursor.hyprcursor.size}"
  ];
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      on._args = [
        "hyprland.start"
        (lua ''
          function()
            ${lib.concatMapStringsSep "\n" (
              command: "hl.exec_cmd(${lib.generators.toLua { } command})"
            ) startupCommands}
          end
        '')
      ];
      monitor = desktopMonitor;
      bind = [
        (bind "W" "hl.dsp.window.float({ action = 'toggle' })")
        (bind "SHIFT + W" "hl.dsp.exec_cmd('wayle panel settings')")
        (bind "F" "hl.dsp.exec_cmd('zen-beta')")
        (bind "T" "hl.dsp.exec_cmd('kitty')")
        (bind "L" "hl.dsp.exec_cmd('petra-lm-lock')")
        (bind "Q" "hl.dsp.window.close()")
        (bind "left" "hl.dsp.focus({ direction = 'l' })")
        (bind "right" "hl.dsp.focus({ direction = 'r' })")
        (bind "up" "hl.dsp.focus({ direction = 'u' })")
        (bind "down" "hl.dsp.focus({ direction = 'd' })")
        (bind "A" "hl.dsp.exec_cmd('fuzzel')")
        (bind "bracketright" "hl.dsp.exec_cmd('desktop-theme next')")
        (bind "bracketleft" "hl.dsp.exec_cmd('desktop-theme previous')")
        (bind "Print" (screenshot "window"))
        (bind "SHIFT + Print" (screenshot "region"))
        {
          _args = [
            "Print"
            (lua (screenshot "output"))
          ];
        }
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lua "hl.dsp.exec_cmd('wayle audio output-volume +5')")
            {
              repeating = true;
              locked = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lua "hl.dsp.exec_cmd('wayle audio output-volume -5')")
            {
              repeating = true;
              locked = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lua "hl.dsp.exec_cmd('wayle audio output-mute')")
            { locked = true; }
          ];
        }
        {
          _args = [
            "XF86AudioMicMute"
            (lua "hl.dsp.exec_cmd('wayle audio input-mute')")
            { locked = true; }
          ];
        }
        {
          _args = [
            "SUPER + mouse:272"
            (lua "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            "SUPER + mouse:273"
            (lua "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }
      ]
      ++ lib.concatMap (
        workspace:
        let
          number = toString workspace;
          key = if workspace == 10 then "0" else number;
        in
        [
          (bind key "hl.dsp.focus({ workspace = ${number} })")
          (bind "SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${number}, follow = true })")
          (bind "CTRL + ${key}" "hl.dsp.window.move({ workspace = ${number}, follow = false })")
        ]
      ) (lib.range 1 10);
      config = {
        cursor = {
          no_hardware_cursors = 1;
        };
        input = {
          repeat_rate = 60;
          repeat_delay = 200;
        };
        decoration = {
          rounding = desktop.spacing.cornerRadius.window;
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
            color = "rgba(${lib.removePrefix "#" desktop.colors.shadow}ee)";
            scale = 0.97;
          };
        };
        animations = {
          enabled = true;
        };
        general = {
          gaps_in = desktop.spacing.windowGaps.inner;
          gaps_out = desktop.spacing.windowGaps.outer;
          border_size = desktop.spacing.borderWidth;
          col = {
            active_border = {
              colors = map (color: "rgba(${lib.removePrefix "#" color}ee)") desktop.defaultTheme.colors;
              angle = desktop.borderAngle;
            };
            inactive_border = "rgba(${lib.removePrefix "#" desktop.colors.inactiveBorder}aa)";
          };
        };
      };
      window_rule = [
        {
          name = "default opacity";
          match.title = ".*";
          opacity = "0.8 0.8";
        }
        {
          name = "tile kitty";
          match.class = "kitty";
          tile = true;
          opacity = "0.7 0.7";
        }
        {
          name = "spotify";
          match.class = "spotify";
          opacity = "1.0 1.0";
        }
        {
          name = "zen";
          match.class = "zen-beta";
          opacity = "1.0 1.0";
        }
        {
          name = "zen pip";
          match.title = "^(Picture-in-Picture)$";
          float = true;
          pin = true;
        }
        {
          name = "warframe";
          match.title = "Warframe";
          opacity = "1.0 1.0";
        }
        {
          name = "sharing indicator";
          match.title = "Sharing Indicator";
          workspace = "special silent";
        }
      ];
    };
  };
}
