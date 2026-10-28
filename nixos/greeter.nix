{
  config,
  lib,
  pkgs,
  ...
}:
let
  interface = pkgs.callPackage ../packages/petra-lm { };
  sessionWrapper = config.services.displayManager.sessionData.wrapper;
  hyprlandSession = pkgs.writeShellScript "petra-lm-hyprland-session" ''
    unset QT_QPA_PLATFORM
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=Hyprland
    export XDG_CURRENT_DESKTOP=Hyprland
    exec ${sessionWrapper} ${config.programs.hyprland.package}/bin/start-hyprland
  '';
  sessionCommand = builtins.toJSON [ hyprlandSession ];
  greeter = pkgs.writeShellScript "petra-lm-greeter-session" ''
    export PETRA_LM_SESSION_COMMAND=${lib.escapeShellArg sessionCommand}
    export QT_QPA_PLATFORM=wayland
    export QT_QUICK_CONTROLS_STYLE=Basic
    exec ${pkgs.dbus}/bin/dbus-run-session \
      ${lib.getExe pkgs.cage} -s -- ${interface}/bin/petra-lm-greeter
  '';
in
{
  services.greetd = {
    enable = true;
    settings.default_session.command = greeter;
  };

  security.pam.services.greetd.rules.auth.login.modulePath = lib.mkForce "petra-greetd";
  security.pam.services.petra-greetd = {
    nodelay = true;
    enableGnomeKeyring = config.security.pam.services.login.enableGnomeKeyring;
    allowNullPassword = config.security.pam.services.login.allowNullPassword;
  };
  security.pam.services.petra-lock.nodelay = true;
}
