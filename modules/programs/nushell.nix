{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ direnv ];

  programs.direnv = {
    enable = true;
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      gaa = "git add --all";
      gca = "git commit -a";
      gp = "git push";
      gl = "git pull";
      cd = "z";
    };
    extraConfig = ''
      source ~/.dots/modules/programs/nushell/catppuccin_mocha.nu
      source ~/.zoxide.nu
      source $"($nu.cache-dir)/carapace.nu"

      def hmsw [] {
        home-manager switch --flake $"($env.HOME)/.dots#(hostname | str replace '.local' "")"
      }
      def update-resume [] {
        rm -f ~/Documents/impt/Alan_Fung_Resume.pdf
        mv ~/Downloads/Alan_Fung_Resume.pdf ~/Documents/impt
      }
    '';
    envFile.text = ''
      $env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.nix-profile/bin")
      $env.PATH = ($env.PATH | split row (char esep) | prepend $"/nix/var/nix/profiles/default/bin")
      $env.PATH = ($env.PATH | split row (char esep) | prepend $"/opt/homebrew/bin")
      $env.LIBRARY_PATH = []
      $env.C_INCLUDE_PATH = []
      $env.LIBRARY_PATH = ($env.LIBRARY_PATH | split row (char esep) | prepend $"/opt/homebrew/opt/libiconv/lib")
      $env.C_INCLUDE_PATH = ($env.C_INCLUDE_PATH | split row (char esep) | prepend $"/opt/homebrew/opt/libiconv/include")
      $env.LS_COLORS = (vivid generate catppuccin-mocha)
      $env.config = {
        show_banner: false,
        buffer_editor: "nvim",
      }
      mkdir $"($nu.cache-dir)"
      carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

      zoxide init nushell | save -f ~/.zoxide.nu
    '';
  };
}
