{ lib, pkgs, ... }:
let
  moonlight = lib.getExe pkgs.moonlight-qt;
in
{
  home.packages = [ pkgs.moonlight-qt ];

  programs.nushell.extraConfig = ''
    # Pair once, then approve the displayed PIN with sunshine-pair on Petra.
    def petra-pair [--host: string = "petra"] {
      ^${moonlight} pair $host
    }

    # Connect directly to Petra's existing desktop through Tailscale.
    def petra-desktop [
      --host: string = "petra"
      --resolution: string = "2560x1440"
      --fps: int = 60
      --fullscreen
    ] {
      let mode = if $fullscreen { "fullscreen" } else { "windowed" }
      ^${moonlight} stream $host Desktop --resolution $resolution --fps $fps --absolute-mouse --display-mode $mode
    }
  '';
}
