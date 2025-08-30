{ config, pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      hmcfg = "cd ~/.dots/home";
      gaa = "git add --all";
      gca = "git commit -a";
    };
    extraConfig = ''
      source ~/.dots/modules/programs/nushell/catppuccin_mocha.nu
      $env.LS_COLORS = (vivid generate catppuccin-mocha)
      $env.config = {
        show_banner: false,
        buffer_editor: "nvim",
      }
      def hmsw [] { home-manager switch --flake $".dots#(hostname | str replace '.local' "")" }
    '';
  };
}
