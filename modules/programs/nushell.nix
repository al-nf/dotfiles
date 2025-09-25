{ config, pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      gaa = "git add --all";
      gca = "git commit -a";
    };
    extraConfig = ''
      $env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.nix-profile/bin")
      $env.PATH = ($env.PATH | split row (char esep) | prepend $"/nix/var/nix/profiles/default/bin")
      source ~/.dots/modules/programs/nushell/catppuccin_mocha.nu
      $env.LS_COLORS = (vivid generate catppuccin-mocha)
      $env.config = {
        show_banner: false,
        buffer_editor: "nvim",
      }
      def hmsw [] { home-manager switch --flake $"($env.HOME)/.dots#(hostname | str replace '.local' "")" }
    '';
  };
}
