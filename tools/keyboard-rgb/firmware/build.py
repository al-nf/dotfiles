import argparse
import hashlib
import json
import runpy
import shutil
import subprocess
from pathlib import Path

DIRECTORY = Path(__file__).resolve().parent
REPOSITORY = DIRECTORY.parents[2]


def output(*command, cwd=None):
    return subprocess.check_output(command, cwd=cwd, text=True).strip()


def main():
    parser = argparse.ArgumentParser(
        description="Build Petra's K556 firmware without flashing"
    )
    parser.add_argument("--source", type=Path, default=Path("/tmp/petra-sonixqmk"))
    profiles = parser.add_mutually_exclusive_group()
    profiles.add_argument(
        "--scan-test", action="store_true", help="Build the color-separated scan profile"
    )
    profiles.add_argument(
        "--debounce-test", action="store_true",
        help="Keep the color-separated scan and test immediate per-key presses"
    )
    arguments = parser.parse_args()
    use_color_scan = arguments.scan_test or arguments.debounce_test
    source = arguments.source.resolve()
    metadata = json.loads((DIRECTORY / "sources.json").read_text())
    if output("git", "rev-parse", "HEAD", cwd=source) != metadata["qmk"]["revision"]:
        raise ValueError("QMK checkout does not match the pinned revision")
    if output("git", "status", "--porcelain", "--untracked-files=no", cwd=source):
        raise ValueError("QMK checkout has tracked changes; inspect before building")
    submodules = output(
        "git", "submodule", "status", "--",
        "lib/chibios", "lib/chibios-contrib", "lib/printf", cwd=source
    )
    if any(line.startswith(("-", "+", "U")) for line in submodules.splitlines()):
        raise ValueError("Initialize submodules at their pinned revisions before building")
    desktop = json.loads(
        output("nix", "eval", "--json", "--file", str(REPOSITORY / "modules/theme.nix"))
    )
    settings = desktop["keyboardLighting"]
    client = runpy.run_path(str(REPOSITORY / "modules/programs/desktop-theme.py"))
    default_theme = desktop["defaultTheme"]
    colors = client["keyboard_palette"](
        {"keyboardColors": default_theme.get("keyboardColors", default_theme["colors"])},
        settings,
    )
    if not 100 <= settings["fadeMilliseconds"] <= 2000 or not 8 <= settings["radius"] <= 64:
        raise ValueError("Keyboard lighting parameters are out of range")
    if arguments.debounce_test:
        keymap = "petra_latency"
        filename = "qmk-k556-petra-latency.bin"
        metadata_key = "latency_test_build"
    elif arguments.scan_test:
        keymap = "petra_scan"
        filename = "qmk-k556-petra-scan.bin"
        metadata_key = "scan_test_build"
    else:
        keymap = "petra"
        filename = "qmk-k556-petra.bin"
        metadata_key = "custom_build"
    destination = source / "keyboards/redragon/k556/keymaps" / keymap
    destination.mkdir(exist_ok=True)
    for path in (DIRECTORY / "petra").iterdir():
        if path.is_file():
            shutil.copyfile(path, destination / path.name)
    if use_color_scan:
        with (destination / "config.h").open("a") as config:
            config.write(
                "\n#define SN32F2XX_PWM_DIRECTION COL2ROW\n"
                "#undef SN32F2XX_PWM_OUTPUT_ACTIVE_LEVEL\n"
                "#define SN32F2XX_PWM_OUTPUT_ACTIVE_LEVEL SN32F2XX_PWM_OUTPUT_ACTIVE_LOW\n"
                "#undef SN32F2XX_RGB_OUTPUT_ACTIVE_LEVEL\n"
                "#define SN32F2XX_RGB_OUTPUT_ACTIVE_LEVEL SN32F2XX_RGB_OUTPUT_ACTIVE_HIGH\n"
            )
    if arguments.debounce_test:
        with (destination / "rules.mk").open("a") as rules:
            rules.write("\nDEBOUNCE_TYPE = asym_eager_defer_pk\n")
        with (destination / "config.h").open("a") as config:
            config.write("\n#undef DEBOUNCE\n#define DEBOUNCE 5\n")
    (destination / "petra_defaults.h").write_text(
        "#pragma once\n"
        + "#define PETRA_DEFAULT_COLORS {" + ", ".join(map(str, colors)) + "}\n"
        + f"#define PETRA_DEFAULT_FADE_MS {settings['fadeMilliseconds']}\n"
        + f"#define PETRA_DEFAULT_RADIUS {settings['radius']}\n"
    )
    target_name = f"redragon/k556:{keymap}"
    driver_patch = DIRECTORY / "color-scan.patch"
    if use_color_scan:
        subprocess.run(["git", "apply", "--check", str(driver_patch)], cwd=source, check=True)
        subprocess.run(["git", "apply", str(driver_patch)], cwd=source, check=True)
    try:
        subprocess.run(["make", target_name, "-j4"], cwd=source, check=True)
    finally:
        if use_color_scan:
            subprocess.run(["git", "apply", "--reverse", str(driver_patch)], cwd=source, check=True)
    artifact = source / f".build/redragon_k556_{keymap}.bin"
    firmware = artifact.read_bytes()
    if len(firmware) != metadata["hardware"]["rom_bytes"]:
        raise ValueError("Unexpected firmware image size")
    target = DIRECTORY / filename
    shutil.copyfile(artifact, target)
    digest = hashlib.sha256(firmware).hexdigest()
    checksum = sum(
        int.from_bytes(firmware[index:index + 2], "little")
        for index in range(0, len(firmware), 2)
    ) & 0xffff
    metadata["qmk"][metadata_key] = {
        "target": target_name,
        "file": target.name,
        "bytes": len(firmware),
        "sha256": digest,
        "additive_checksum": f"0x{checksum:04x}",
        "default_colors": list(colors),
        "settings": settings,
        "status": "built only; not flashed or hardware-validated",
    }
    if use_color_scan:
        metadata["qmk"][metadata_key]["driver_patch_sha256"] = hashlib.sha256(
            driver_patch.read_bytes()
        ).hexdigest()
    if arguments.debounce_test:
        metadata["qmk"][metadata_key]["debounce"] = {
            "algorithm": "asym_eager_defer_pk",
            "milliseconds": 5,
        }
    (DIRECTORY / "sources.json").write_text(json.dumps(metadata, indent=2) + "\n")
    checksums = (DIRECTORY / "SHA256SUMS").read_text().splitlines()
    checksums = [line for line in checksums if line.split()[-1] != target.name]
    checksums.append(f"{digest}  {target.name}")
    (DIRECTORY / "SHA256SUMS").write_text("\n".join(checksums) + "\n")
    print(f"Built only, NOT flashed: {target}\nSHA256: {digest}")


if __name__ == "__main__":
    main()
