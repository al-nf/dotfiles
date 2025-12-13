{ config, pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    
    extensions = [
      "catppuccin"
      "nix"
    ];
    
    userSettings = {
      base_keymap = "VSCode";
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 15;
      
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Catppuccin Mocha";
      };
      
      terminal = {
        font_family = "JetBrainsMono Nerd Font";
        font_size = 13;
      };
      soft_wrap = "editor_width";
    };
  };
}
