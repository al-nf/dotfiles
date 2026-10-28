{ ... }:
let
  desktop = import ../theme.nix;
in
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "catppuccin"
      "nix"
      "toml"
      "dockerfile"
      "nu"
      "verilog"
      "assembly"
      "ver"
      "latex"
      "hyprlang"
      "matlab"
      "linkerscript"
      "html"
      "make"
      "catppuccin-icons"
      "ocaml"
    ];

    userSettings = {
      base_keymap = "VSCode";
      vim_mode = true;
      relative_line_numbers = "enabled";
      ui_font_size = 16;
      buffer_font_family = desktop.font.family;
      buffer_font_size = 15;

      theme = {
        mode = "dark";
        light = "One Light";
        dark = "Catppuccin Mocha";
      };

      terminal = {
        font_family = desktop.font.family;
        font_size = 13;
        detect_venv = "off";
      };
      soft_wrap = "editor_width";
    };
  };
}
