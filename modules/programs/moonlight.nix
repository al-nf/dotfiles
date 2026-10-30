{ lib, pkgs, ... }:
let
  moonlight = lib.getExe pkgs.moonlight-qt;
  rdt = pkgs.writeShellApplication {
    name = "rdt";
    text = ''
      if [[ $# -eq 0 ]]; then
        echo "Usage: rdt HOSTNAME [MOONLIGHT_OPTIONS...]" >&2
        exit 2
      fi
      if [[ $1 == --help || $1 == -h ]]; then
        echo "Usage: rdt HOSTNAME [MOONLIGHT_OPTIONS...]"
        echo "Example: rdt petra --display-mode fullscreen"
        exit 0
      fi

      remote_host=$1
      shift
      exec ${moonlight} stream "$remote_host" Desktop \
        --resolution 1920x1080 --fps 60 --bitrate 5000 --packet-size 1024 \
        --absolute-mouse --capture-system-keys always --display-mode windowed "$@"
    '';
  };
in
{
  home.packages = [
    pkgs.moonlight-qt
    rdt
  ];

  programs.nushell.extraConfig = ''
    # Pair once, then approve the displayed PIN with sunshine-pair on Petra.
    def petra-pair [--host: string = "petra"] {
      ^${moonlight} pair $host
    }

    # Defaults
    def petra-desktop [
      --host: string = "petra"
      --resolution: string = "1920x1080"
      --fps: int = 60
      --bitrate: int = 5000
      --packet-size: int = 1024
      --fullscreen
    ] {
      let mode = if $fullscreen { "fullscreen" } else { "windowed" }
      # Forward Command/Super in windowed mode too; Ctrl+Option+Shift+Z releases capture.
      ^${lib.getExe rdt} $host --resolution $resolution --fps $fps --bitrate $bitrate --packet-size $packet_size --display-mode $mode
    }
  '';
}
