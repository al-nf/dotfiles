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
        horizontal-pad = desktop.spacing.launcherPadding.horizontal;
        vertical-pad = desktop.spacing.launcherPadding.vertical;
        inner-pad = desktop.spacing.launcherPadding.inner;
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
        width = desktop.spacing.borderWidth;
        radius = desktop.spacing.cornerRadius.launcher;
        selection-radius = desktop.spacing.cornerRadius.selection;
      };
    };
  };
}
