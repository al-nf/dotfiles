{ config, pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      hmcfg = "cd ~/.config/home-manager";
      hmsw = "home-manager switch";
      gaa = "git add --all";
      gca = "git commit -a";
    };
    extraConfig = ''
      source ./../nushell/catppuccin_mocha.nu
      $env.LS_COLORS = (vivid generate catppuccin-mocha)
      $env.config = {
        show_banner: false,
        buffer_editor: "nvim",
      }
    '';
  };
}
