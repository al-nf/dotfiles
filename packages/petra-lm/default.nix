{
  lib,
  runCommand,
  symlinkJoin,
  writeShellApplication,
  quickshell,
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
in
symlinkJoin {
  name = "petra-lm";
  paths = [
    greeter
    lock
  ];
}
