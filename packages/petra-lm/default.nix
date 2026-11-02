{
  lib,
  runCommand,
  symlinkJoin,
  writeShellApplication,
  quickshell,
  systemd,
  util-linux,
}:
let
  interface = runCommand "petra-lm-interface" { } ''
    mkdir -p "$out/qml"
    cp ${./qml}/*.qml "$out/qml/"
    cp ${./qml/wallpaper.jpg} "$out/qml/wallpaper.jpg"
  '';
  greeter = writeShellApplication {
    name = "petra-lm-greeter";
    text = ''
      exec ${lib.getExe quickshell} --no-duplicate --path ${interface}/qml/Greeter.qml
    '';
  };
  lock = writeShellApplication {
    name = "petra-lm-lock";
    text = ''
      if [[ ! -r /etc/pam.d/petra-lock ]]; then
        echo "Activate the NixOS configuration before using petra-lm-lock." >&2
        exit 1
      fi
      exec ${util-linux}/bin/flock --nonblock "''${XDG_RUNTIME_DIR:?}/petra-lock.lock" \
        ${lib.getExe quickshell} --no-duplicate --path ${interface}/qml/Lock.qml
    '';
  };
  suspend = writeShellApplication {
    name = "suspend";
    text = ''
      exec ${lib.getExe' systemd "systemd-run"} --user --collect --quiet \
        --unit=petra-suspend --service-type=exec \
        --setenv="WAYLAND_DISPLAY=''${WAYLAND_DISPLAY:?Run suspend from a Wayland session.}" \
        --setenv=PETRA_LM_SUSPEND=1 \
        --setenv=PETRA_LM_SYSTEMCTL=${lib.getExe' systemd "systemctl"} \
        ${lib.getExe' lock "petra-lm-lock"}
    '';
  };
in
symlinkJoin {
  name = "petra-lm";
  paths = [
    greeter
    lock
    suspend
  ];
}
