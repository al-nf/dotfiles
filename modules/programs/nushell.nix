{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./direnv.nix ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.cargo/bin"
    "/usr/local/bin"
  ]
  ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    "/opt/homebrew/bin"
    "/Applications/flutter/bin"
    "${config.home.homeDirectory}/.docker"
  ];

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    loadSessionVariables = true;
    settings = {
      show_banner = false;
      buffer_editor = "nvim";
    };
    shellAliases = {
      vi = "nvim";
      vim = "nvim";
      gaa = "git add --all";
      gca = "git commit -a";
      gp = "git push";
      gl = "git pull";
      update-resume = "mv ~/Downloads/Alan_Fung_Resume.pdf ~/Documents/impt/Alan_Fung_Resume.pdf";
      cd = "z";
      ssh = "kitten ssh";
    }
    //
      lib.optionalAttrs (config.programs.zed-editor.enable && config.programs.zed-editor.package != null)
        {
          zed = lib.getExe config.programs.zed-editor.package;
        };
    extraConfig = ''
      source ${./nushell/catppuccin_mocha.nu}

      def hmsw [] {
        home-manager switch --flake $"($env.HOME)/.dots#(hostname | str replace '.local' "")"
      }

      def nixup [] {
        nix flake update --flake $"($env.HOME)/.dots"
      }

      def nrsw [] {
        sudo nixos-rebuild switch --flake $"($env.HOME)/.dots#(hostname | str replace '.local' "")"
      }

    '';
    envFile.text = ''
      # GUI terminals may start without the Nix profiles on PATH.
      # Set these even when the Home Manager session variables were already loaded.
      $env.PATH = ($env.PATH | split row (char esep) | prepend [
        "${config.home.profileDirectory}/bin"
        "/nix/var/nix/profiles/default/bin"
      ] | uniq)
    ''
    + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      $env.LIBRARY_PATH = ($env.LIBRARY_PATH? | default [] | split row (char esep) | prepend "/opt/homebrew/opt/libiconv/lib" | uniq)
      $env.C_INCLUDE_PATH = ($env.C_INCLUDE_PATH? | default [] | split row (char esep) | prepend "/opt/homebrew/opt/libiconv/include" | uniq)
      $env.LD_LIBRARY_PATH = ($env.LD_LIBRARY_PATH? | default [] | split row (char esep) | prepend $"($env.HOME)/.nix-profile/lib" | uniq)
    ''
    + ''
      $env.LS_COLORS = (vivid generate catppuccin-mocha)
      $env.VIRTUAL_ENV_DISABLE_PROMPT = 1

      if (which opam | is-not-empty) {
        opam env | lines | reduce -f {} { |line, acc|
          let parts = ($line | parse "{key}='{val}'; export {_};")
          if ($parts | is-not-empty) {
              let row = ($parts | first)
              $acc | insert $row.key $row.val
          } else {
              $acc
          }
        } | load-env
      }
    '';
  };
}
