# K556 firmware preparation

Nothing here automatically flashes, erases, changes code security, or reboots a
keyboard. This environment is for build-only preparation. No packages are added
to Home Manager. Reactive lighting runs on the keyboard, with no host-side
keypress listener or continuously running lighting process.

## Hardware and recovery status

The chip marking was reported as `VS11K09A-1`. A SonixFlasherC 3.0.0 info-only
query identified `SN32F24XB`, 64 KB ROM, security level CS1, and flash checksum
`0x9cdf`. The board marking was reported as `8179-Q US V7`, dated 2018-11-21.

`candidate-stock-k556-240b.bin` is the community archive's US-layout K556 image.
Its provenance and SHA-256 are recorded in `sources.json`. It is **not a backup
of this keyboard**. Its additive checksum is `0x1529`, different from the device's
initially observed `0x9cdf`. A later info-only query reported by the user returned
`0x1529`, matching the candidate. The reason for the earlier difference is unknown.
The matching 16-bit checksum increases confidence but does not prove byte-for-byte
equivalence or successful restoration on this keyboard.

Verify the archived file from this directory:

```sh
sha256sum -c SHA256SUMS
```

Do not change the CS1 security setting just to try reading or backing up flash.
Recovery pads have not been identified. Successful software bootloader entry does
not prove hardware recovery after a failed or incompatible flash.

### Recovery investigation

The SonixQMK identification table explicitly distinguishes `VS11K09A-1`
(`SN32F248B`) from `VS11K09A` (`SN32F248`). The pinned keyboard database also
lists the K556 with `VS11K09A-1` / `SN32F248B`. The selected target and candidate
therefore match the reported chip family, but this does not validate the PCB
revision or establish that the archived image matches the installed firmware.

The pinned archive contains a K556 image and a separate K556-DE image under
`stockFWs/Redragon/240B`; neither filename establishes compatibility with PCB
`8179-Q US V7`. The US candidate's available file history only records a
repository refactor, not a restoration test on this revision.

SonixFlasherC 3.0.0 does not expose a firmware dump command. The SN32F240B
datasheet, section 14.8.1, documents that CS1 blocks external User ROM reads
through WRITER/SWD, and changing CS1 to CS0 first erases User ROM. Do not remove
protection to obtain a backup. This does not rule out a firmware-specific read
interface, but none has been established for this keyboard.

Before flashing, obtain either a vendor-confirmed recovery image for the exact
PCB/chip or confirmation from SonixQMK of a tested matching stock image. Also
identify and test the physical bootloader recovery route without writing flash.
The unidentified J1/J3/J4/J5 pads are not established recovery points; do not
short them based on their labels. No stock recovery test has been performed.

## Temporary build environment

The pinned, unmodified `redragon/k556:default` target built successfully with
GCC 13.3. The saved `qmk-k556-default.bin` is 65,536 bytes, including the gap
before the target's four-byte end flag at `0xfffc`; the build reports 40,078
section bytes. ELF inspection confirms vectors at address zero. Its SHA-256 is
in `SHA256SUMS`. The user flashed this default image, reported checksum
verification against `0xa4b7`, and tested all keys and key combinations
successfully. The default RGB animation also runs.

The shell uses QMK CLI and GCC ARM Embedded 13.3. The compiler override applies
RPATH before the ELF interpreter because the packaged toolchains segfaulted even
on `--version` on Petra. The adjustment is confined to this development shell.

From the repository root, use the dotfiles' pinned nixpkgs in Nushell:

```nu
let nixpkgs = (nix eval --raw .#nixosConfigurations.petra.pkgs.path)
nix-shell -I $"nixpkgs=($nixpkgs)" tools/keyboard-rgb/firmware/shell.nix
```

Then, inside that temporary shell, prepare the pinned source in a new directory:

```sh
git clone --branch sn32_develop https://github.com/SonixQMK/qmk_firmware.git /tmp/petra-sonixqmk
cd /tmp/petra-sonixqmk
git checkout 62973ee48a976c6f7cc6d4f7b198bd48a2fdfe60
git submodule update --init --recursive
make redragon/k556:default -j4
```

If the source directory already exists, do not clone over it. Inspect its status
and revision before reusing it. Only run the build target above, not a `:flash`
target or `qmk flash`. This builds the unmodified upstream default keymap. For the
custom firmware, use the separate build command below. Build success is not
physical hardware validation. The existing EVision protocol does not carry over
to QMK.

## Petra reactive firmware

`petra/` is a separate keymap that includes the upstream default keymap unchanged,
including Fn+Esc bootloader entry. It adds a custom RGB Matrix effect and a
lighting-only Raw HID interface. The host never reads keypresses through this
interface and never streams animation frames.

- The darker theme accent forms the background at 65% brightness, preserving
  contrast against full-brightness reactive highlights.
- The mouse uses that same darker accent at full brightness, rather than the
  first accent in the theme definition. This keeps its hue aligned with the
  keyboard background even when accent order differs between themes.
- The lighter accent highlights pressed keys at 100% brightness, with a symmetric
  localized glow fading over 800 ms. Up to eight recent presses contribute;
  overlapping glows use their maximum, not an additive brightness boost.
- Theme colors transition over `rgbTransitionDuration` on the keyboard.
- `modules/theme.nix` declares brightness, fade duration, and glow radius in
  `keyboardLighting`. Theme updates take effect through Home Manager without a
  firmware rebuild. Supported fade duration is 100–2000 ms, radius 8–64 QMK
  coordinate units, and theme transition duration 0–2 seconds.
- Brightness and the RGB toggle on the existing Fn layer still work. Other
  stock RGB effects remain selectable except Digital Rain and Typing Heatmap,
  whose framebuffer is omitted to preserve RAM. A theme update reselects the
  custom effect without forcing the LEDs on.
- `keyboardLighting.whitePoint` applies keyboard-only RGB channel correction to
  both the background and reactive highlight; the mouse is not corrected. The
  accepted white point for the revised color-separated scan is `#f0ffff`.
- A theme can declare `keyboardColors` separately from its desktop `colors`.
  Red themes use richer keyboard accents to avoid a pale/pink appearance; mouse
  and desktop colors are unchanged. These overrides apply on theme restore or
  switching, without reflashing.
- Theme updates stay in RAM, with no explicit EEPROM writes. On power-up, the
  compiled default theme is used until `desktop-theme restore` or a theme change.
  Changing that power-up default requires rebuilding and reflashing.

From the repository root, inside the temporary build shell:

```sh
python3 tools/keyboard-rgb/firmware/build.py
```

The script checks the QMK revision, tracked-file cleanliness, and required
submodule revisions; copies only this custom keymap into the existing checkout;
generates boot colors from the declarative default theme; and builds
`redragon/k556:petra`. It saves `qmk-k556-petra.bin` and updates its checksums and
metadata. It does not flash or activate NixOS/Home Manager.

The current custom build links successfully with 36,830 loadable section bytes
in a 65,536-byte image. ELF inspection shows the original 768-byte main and
1536-byte process stack reservations unchanged, with 692 bytes left in the heap
region. Native mocked-firmware tests cover rendering, decay, descending color
transitions, and request validation; mocked host tests cover discovery, packet
framing, acknowledgements, invalid settings, and timeouts. Physical validation
of this custom build remains pending.

### Color-separated scan diagnostic

The existing custom firmware's keys and reactive lighting were tested by the
user, but mixed colors appeared unusually red and the overall brightness seemed
lower than before. Host/readback checks confirmed that the requested RGB values
were correct. A manually tested approximate white point was `#78e0ff`; no
permanent correction based on that original-driver white point was applied.

Build a separate diagnostic image inside the same development shell:

```sh
python3 tools/keyboard-rgb/firmware/build.py --scan-test
```

This builds `redragon/k556:petra_scan` and saves `qmk-k556-petra-scan.bin`, leaving
`qmk-k556-petra.bin` and its metadata unchanged as the rollback image. It uses
the current declarative theme defaults, the same keymap and lighting protocol,
but scans individual RGB rows with PWM on the column pins. The corresponding
GPIO active levels are changed to match their swapped roles. No electrical
current limit, clock rate, or PWM period is raised.

`color-scan.patch` is applied only during this build and reversed in a `finally`
block afterward; the normal build uses the untouched upstream driver. The patch
corrects the alternate scan path's key-column index, interrupt-safe PWM calls,
and unmapped-LED bounds handling. It preserves upstream's hardware PWM channel
and row lookahead rather than treating queued values as immediate outputs. It
also avoids declaring an unused scan-direction-specific variable. Native tests
with address/undefined-behavior sanitizers cover all 21 key columns, all 18 color
phases, queued RGB order, unmapped LED positions, and scan wraparound using the K556's
actual LED layout.

The first diagnostic image (`0x8750`) was flashed and appeared substantially
brighter, but green requests appeared red and red requests appeared blue. Its
attempt to directly align queued PWM values with the active phase was incorrect.
The revised patch restores upstream's phase/row lookahead. Brightness and color
accuracy still require another physical test; native mocks cannot establish
the peripheral's actual latch timing.

The revised image (`0x692e`) was subsequently flashed. The user confirmed green
output and working typing, and accepted `#f0ffff` as a slightly less-pink white.
The theme helper now applies this mild red-channel reduction declaratively.

The revised diagnostic build links successfully with 36,890 loadable section bytes in a
65,536-byte image. It remains an experiment: brighter or more accurate colors
are not guaranteed. Keyboard scanning must also be tested again on hardware.

After Fn+Esc and confirming bootloader ID `0c45:7040`, the diagnostic flash command
is this single line in Nushell:

```nu
sudo /tmp/petra-sonixflasher-3.0.0/sonixflasher --vid-pid "0c45/7040" --file "/home/afung/.dots/tools/keyboard-rgb/firmware/qmk-k556-petra-scan.bin" --offset 0
```

Check against `qmk.scan_test_build.additive_checksum` in `sources.json`. After a
successful flash, test keys and fast typing first, then compare solid primaries
and uncorrected full white before changing the palette. Theme restore still uses
the normal helper; there is no Home Manager or NixOS switch for this experiment.

To roll back, enter the bootloader with Fn+Esc and flash the preserved
`qmk-k556-petra.bin` with the same command, replacing only the firmware filename.
Its checksum remains `0x00cb`. If Fn+Esc fails, physical recovery remains
unverified; do not short unidentified pads or blindly retry failed flashes.

### Activation and flashing

The NixOS change adds `70-petra-keyboard.rules`, granting the active local user
access to this QMK device's hidraw nodes using `uaccess`. It does not grant raw
input access or make devices world-writable. Activate the NixOS configuration
yourself and apply Home Manager, then reconnect the keyboard when appropriate.
The RGB mouse remains controlled through the existing OpenRGB service.

Since the keyboard now runs QMK, **do not reuse `--reboot evision`** to flash it.
Hold Fn and tap Esc to enter the bootloader, then identify its USB ID:

```nu
/tmp/petra-sonixflasher-3.0.0/sonixflasher --list-connected
```

The SN32F248B bootloader is normally `0c45:7040`. Only if that ID is confirmed,
run this single line in Nushell with stable power:

```nu
sudo /tmp/petra-sonixflasher-3.0.0/sonixflasher --vid-pid "0c45/7040" --file "/home/afung/.dots/tools/keyboard-rgb/firmware/qmk-k556-petra.bin" --offset 0
```

Compare the verified checksum with `qmk.custom_build.additive_checksum` in
`sources.json`. Do not unplug during flashing or blindly retry an error. After
success, test keys and typing again, then run `desktop-theme restore` locally in
Hyprland and check both the background color and pressed-key glow. Replugging
after a successful flash can be used to test the compiled power-up defaults.

### Lighting protocol

USB VID/PID remain `0c45:50e4`. The separate application collection uses vendor
usage page `0xff60`, usage `0x64`, rather than VIA's usual usage `0x61`.
The host checks both USB identity and this descriptor before opening a device.
No extra Python packages are required; the client uses Linux hidraw directly.

Each report is 32 bytes, with `PTR1` in bytes 0–3, command in byte 4, background
RGB in 5–7, highlight RGB in 8–10, little-endian fade milliseconds in 11–12,
transition milliseconds in 13–14, and radius in 15. Remaining bytes are zero.
Command 1 sets the theme; command 2 reads the target colors and settings without
changing them. Replies set command bit 7 and report status in byte 31 (zero for
success). Invalid settings are rejected without updating colors. No command
changes keymaps, injects keys, changes firmware protection, or flashes firmware.

References:

- [Chip identification and bootloader documentation](https://sonixqmk.github.io/SonixDocs/install/)
- [Sonix SN32F240B datasheet, section 14.8.1](https://www.sonix.com.tw/files/1/2F8093AC4FA19D4EE060007F010024BC)
- [Pinned keyboard database](https://github.com/SonixQMK/Mechanical-Keyboard-Database/blob/13f78cb0292675f202218f1e7249bc2bd83a1ee8/README.md)
- [SonixQMK K556 target](https://github.com/SonixQMK/qmk_firmware/tree/62973ee48a976c6f7cc6d4f7b198bd48a2fdfe60/keyboards/redragon/k556)
- [Candidate recovery archive](https://github.com/SonixQMK/Mechanical-Keyboard-Database/tree/13f78cb0292675f202218f1e7249bc2bd83a1ee8/stockFWs/Redragon/240B)
- [Current flasher](https://github.com/SonixQMK/SonixFlasherC/tree/73f9fab8a82c5c4f91181d276676c8f936726925)
- [QMK Raw HID](https://docs.qmk.fm/features/rawhid)
- [QMK RGB Matrix custom effects](https://docs.qmk.fm/features/rgb_matrix)
