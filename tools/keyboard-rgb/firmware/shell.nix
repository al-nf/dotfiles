{
  pkgs ? import <nixpkgs> { },
}:
let
  compiler = pkgs.gcc-arm-embedded-13.overrideAttrs {
    preFixup = ''
      find "$out" -type f | while read -r binary; do
        patchelf "$binary" > /dev/null 2>&1 || continue
        patchelf --set-rpath ${
          pkgs.lib.makeLibraryPath [
            "$out"
            pkgs.stdenv.cc.cc
            pkgs.ncurses5
            pkgs.libxcrypt-legacy
          ]
        } "$binary" || true
        patchelf --set-interpreter "$(cat "$NIX_CC/nix-support/dynamic-linker")" "$binary" || true
      done
    '';
  };
in
pkgs.mkShell {
  packages = [
    (pkgs.qmk.override { gcc-arm-embedded = compiler; })
  ];
}
