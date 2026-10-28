{ lib, pkgs, ... }:
let
  desktop = import ../theme.nix;
  rgba = color: alpha: "${lib.removePrefix "#" color}${alpha}";
  lightAccent = builtins.head desktop.defaultTheme.colors;
  strongAccent = builtins.elemAt desktop.defaultTheme.colors 1;
in
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "${desktop.font.family}:size=${toString desktop.font.size}";
        dpi-aware = "no";
        terminal = "${pkgs.kitty}/bin/kitty -e";
        icon-theme = "Tela-circle";
        prompt = "›";
        hide-before-typing = true;
        width = 38;
        lines = 11;
        horizontal-pad = 20;
        vertical-pad = 14;
        inner-pad = 10;
        layer = "top";
      };
      colors = {
        background = rgba desktop.colors.base "f2";
        text = rgba desktop.colors.text "ff";
        prompt = rgba lightAccent "ff";
        placeholder = rgba desktop.colors.subtext0 "ff";
        input = rgba desktop.colors.brightText "ff";
        match = rgba strongAccent "ff";
        selection = rgba desktop.colors.surface0 "ff";
        selection-text = rgba desktop.colors.brightText "ff";
        selection-match = rgba lightAccent "ff";
        border = rgba strongAccent "cc";
      };
      border = {
        width = 2;
        radius = 14;
        selection-radius = 8;
      };
    };
  };
}
