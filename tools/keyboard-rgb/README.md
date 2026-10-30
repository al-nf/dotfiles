# K556 LED calibration

This is the legacy **stock EVision firmware** calibration tool. The keyboard now
runs QMK; do not use this map or calibration script on it. See
[firmware/README.md](firmware/README.md) for the firmware-driven reactive effect
and declarative theme synchronization. That implementation uses QMK's own LED
coordinates and does not need a host-side key listener.

Project-local preparation for reactive lighting. Nothing is installed into PATH,
no input-device permissions are added, and no keypresses are monitored.
The standard-library Python script talks to the existing local OpenRGB server.

`k556.json` is a **provisional, physically unverified** ANSI 104-key map. Its
coordinates are inferred from the live OpenRGB 6-by-23 matrix. The driver exposes
126 addressable slots; slots without physical-key assignments are deliberately
left unmapped. Fn may be handled entirely by the keyboard rather than generating
a Linux input event. Matrix coordinates are not precise physical distances.

From the repository root, inspect the map remotely without changing lighting:

```sh
python tools/keyboard-rgb/calibrate.py inspect
```

When home, walk representative keys, including navigation and the number pad:

```sh
python tools/keyboard-rgb/calibrate.py walk
```

The script asks for confirmation before touching lighting, then highlights one
expected key at a time. Press Enter in the terminal to advance, or `q` to finish.
It does not detect which physical key you press. Record any mismatches with the
expected key name, LED number, and actual lit key. To check every mapped key:

```sh
python tools/keyboard-rgb/calibrate.py walk --all
```

Or highlight one provisional key for five seconds:

```sh
python tools/keyboard-rgb/calibrate.py key KEY_A
```

Lighting actions use Custom mode with a dim background and a single lavender
highlight. Only the matching keyboard is touched; mouse lighting is unaffected.
The tool holds the theme helper's lock, so avoid cycling themes during calibration.
It restores the original LED values and active mode on normal exit, Ctrl-C, or
SIGTERM. A killed process, lost connection, or stopped server can prevent cleanup;
in that case, run `desktop-theme restore` from a local Hyprland session, or restart
the OpenRGB system service to reapply the boot color. No explicit firmware-save
or profile-save command is issued; device-controlled persistence is not guaranteed.

Do not enable reactive lighting based on this map until the physical positions
have been verified. Future work: verify the input-event names separately, choose
safe key-event permissions, and implement an idle-sleeping reactive effect.
