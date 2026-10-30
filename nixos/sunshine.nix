{
  config,
  pkgs,
  ...
}:
let
  cli =
    action:
    pkgs.writeShellApplication {
      name = "sunshine-${action}";
      runtimeInputs = [
        pkgs.python3
        config.services.sunshine.package
        pkgs.systemd
      ];
      text = ''
        exec python3 ${./sunshine-cli.py} ${action} "$@"
      '';
    };
in
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    package = pkgs.sunshine.override { cudaSupport = true; };
    openFirewall = false;
    settings = {
      sunshine_name = "petra";
      capture = "kms";
      encoder = "nvenc";
      origin_web_ui_allowed = "pc";
      upnp = "disabled";
      system_tray = "disabled";
    };
    applications.apps = [ { name = "Desktop"; } ];
  };

  # Match the streaming ports from the NixOS Sunshine module, without exposing
  # the administration API. Pairing approval runs locally over SSH instead.
  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [
      47984
      47989
      48010
    ];
    allowedUDPPorts = [
      47998
      47999
      48000
      48002
      48010
    ];
  };

  environment.systemPackages = [
    (cli "setup")
    (cli "pair")
  ];
}
