{ config, pkgs, ... }:
let
  desktop = import ../theme.nix;
  inherit (desktop) colors;
in
{
  programs.kitty = {
    enable = true;

    settings = {
      shell = "nu";
      remember_window_size = false;
    };
    extraConfig = ''

      font_family      ${desktop.font.family}
      bold_font        ${desktop.font.family} Bold
      bold_italic_font ${desktop.font.family} Bold Italic
      font_size ${toString desktop.font.size}

      cursor_trail 3

      foreground              ${colors.text}
      background              ${colors.base}
      selection_foreground    ${colors.base}
      selection_background    ${colors.rosewater}

      cursor                  ${colors.rosewater}
      cursor_shape underline
      cursor_text_color       ${colors.base}

      url_color               ${colors.rosewater}

      active_border_color     ${colors.lavender}
      inactive_border_color   ${colors.overlay0}
      bell_border_color       ${colors.yellow}

      wayland_titlebar_color system
      macos_titlebar_color system

      active_tab_foreground   ${colors.crust}
      active_tab_background   ${colors.mauve}
      inactive_tab_foreground ${colors.text}
      inactive_tab_background ${colors.mantle}
      tab_bar_background      ${colors.crust}

      mark1_foreground ${colors.base}
      mark1_background ${colors.lavender}
      mark2_foreground ${colors.base}
      mark2_background ${colors.mauve}
      mark3_foreground ${colors.base}
      mark3_background ${colors.sapphire}

      # black
      color0 ${colors.surface1}
      color8 ${colors.surface2}

      # red
      color1 ${colors.red}
      color9 ${colors.red}

      # green
      color2  ${colors.green}
      color10 ${colors.green}

      # yellow
      color3  ${colors.yellow}
      color11 ${colors.yellow}

      # blue
      color4  ${colors.blue}
      color12 ${colors.blue}

      # magenta
      color5  ${colors.pink}
      color13 ${colors.pink}

      # cyan
      color6  ${colors.teal}
      color14 ${colors.teal}

      # white
      color7  ${colors.subtext1}
      color15 ${colors.subtext0}

      window_padding_width 5
    '';
  };
}
