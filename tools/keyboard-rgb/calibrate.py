import argparse
import fcntl
import json
import os
import runpy
import signal
import socket
import struct
import sys
import time
from pathlib import Path

DIRECTORY = Path(__file__).resolve().parent
CLIENT = runpy.run_path(
    str(DIRECTORY.parents[1] / "modules/programs/desktop-theme.py")
)["OpenRGB"]


def load_map(controller, definition):
    if len(controller["colors"]) != definition["led_count"]:
        raise ValueError("Keyboard LED count does not match the provisional map")
    matrices = [zone["matrix"] for zone in controller["zones"] if zone["matrix"]]
    if len(matrices) != 1:
        raise ValueError("Expected one keyboard matrix")
    matrix = matrices[0]
    height, width = definition["matrix_size"]
    if len(matrix) != height or any(len(row) != width for row in matrix):
        raise ValueError("Keyboard matrix dimensions do not match the provisional map")
    keys = {}
    for key, (row, column) in definition["keys"].items():
        if not (0 <= row < height and 0 <= column < width):
            raise ValueError(f"Invalid matrix position for {key}")
        led = matrix[row][column]
        if led is None or not 0 <= led < len(controller["colors"]):
            raise ValueError(f"No valid LED at the provisional position for {key}")
        if led in keys.values():
            raise ValueError(f"Duplicate LED assignment for {key}")
        keys[key] = led
    return matrix, keys


def set_colors(client, device, colors):
    payload = b"".join(struct.pack("<BBBx", *color) for color in colors)
    client.send(
        device, 1050, struct.pack("<IH", 6 + len(payload), len(colors)) + payload
    )


def set_mode(client, device, mode):
    client.send(
        device,
        1101,
        struct.pack("<Ii", 8 + len(mode["data"]), mode["index"]) + mode["data"],
    )


def interrupt(signum, frame):
    raise KeyboardInterrupt


def main():
    parser = argparse.ArgumentParser(
        description="Inspect or locally calibrate the provisional K556 LED map. Does not read keyboard events."
    )
    parser.add_argument("action", choices=["inspect", "key", "walk"])
    parser.add_argument("key", nargs="?")
    parser.add_argument("--seconds", type=float, default=5)
    parser.add_argument(
        "--all",
        action="store_true",
        help="Walk all 104 keys instead of representative anchors",
    )
    arguments = parser.parse_args()
    definition = json.loads((DIRECTORY / "k556.json").read_text())
    if (arguments.action == "key") != (arguments.key is not None):
        parser.error("Only 'key' takes a key name, and it requires one")
    if not 0 < arguments.seconds <= 60:
        parser.error("--seconds must be between 0 and 60")
    if arguments.key is not None and arguments.key not in definition["keys"]:
        parser.error("Unknown key; use the KEY_* names shown by 'inspect'")
    state = (
        Path(os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local/state")))
        / "desktop-theme"
    )
    state.mkdir(parents=True, exist_ok=True)
    with (state / "lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        with socket.create_connection(("127.0.0.1", 6742), timeout=1) as connection:
            connection.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
            client = CLIENT(connection)
            matches = [
                (index, controller)
                for index, controller in enumerate(client.controllers())
                if controller["name"] == definition["device_name"]
            ]
            if len(matches) != 1:
                raise ValueError("Expected exactly one matching K556 keyboard")
            device, original = matches[0]
            matrix, keys = load_map(original, definition)
            print(
                f"PROVISIONAL map: {len(keys)} keys, {len(original['colors'])} LED slots; not physically verified."
            )
            if arguments.action == "inspect":
                for row in matrix:
                    print(" ".join("  ." if led is None else f"{led:3}" for led in row))
                for key, led in keys.items():
                    print(f"{key:20} LED {led}")
                return
            if not sys.stdin.isatty():
                parser.error("Lighting calibration requires an interactive terminal")
            print(
                "This briefly changes ONLY the keyboard. Original lighting is restored on completion or Ctrl-C."
            )
            input(
                "When you can see the keyboard, press Enter to start (Ctrl-C to cancel): "
            )
            selected = (
                [arguments.key]
                if arguments.action == "key"
                else list(keys)
                if arguments.all
                else [
                    "KEY_ESC",
                    "KEY_F1",
                    "KEY_F12",
                    "KEY_GRAVE",
                    "KEY_BACKSPACE",
                    "KEY_Q",
                    "KEY_A",
                    "KEY_ENTER",
                    "KEY_Z",
                    "KEY_SPACE",
                    "KEY_LEFTCTRL",
                    "KEY_UP",
                    "KEY_KP7",
                    "KEY_KPENTER",
                    "KEY_KP0",
                ]
            )
            custom = next(
                (mode for mode in original["modes"] if mode["name"] == "Custom"), None
            )
            if custom is None:
                raise ValueError("No Custom mode is available")
            try:
                set_mode(client, device, custom)
                for key in selected:
                    colors = [(12, 10, 20)] * len(original["colors"])
                    colors[keys[key]] = (180, 160, 230)
                    print(f"Expected lit key: {key}, LED {keys[key]}", flush=True)
                    set_colors(client, device, colors)
                    if arguments.action == "walk":
                        response = input(
                            "Enter = next; q = stop. Note any mismatches: "
                        )
                        if response.lower() == "q":
                            break
                    else:
                        time.sleep(arguments.seconds)
            finally:
                set_colors(client, device, original["colors"])
                set_mode(client, device, original["modes"][original["active_mode"]])
                restored = client.decode_controller(
                    client.request(device, 1, struct.pack("<I", 3))
                )
                if (
                    restored["active_mode"] != original["active_mode"]
                    or restored["colors"] != original["colors"]
                    or restored["modes"][original["active_mode"]]["colors"]
                    != original["modes"][original["active_mode"]]["colors"]
                ):
                    raise ValueError(
                        "Could not verify restoration; run desktop-theme restore when logged in locally"
                    )
                print("Original lighting restored.")


if __name__ == "__main__":
    signal.signal(signal.SIGTERM, interrupt)
    try:
        main()
    except (KeyboardInterrupt, EOFError):
        print("Cancelled.", file=sys.stderr)
        sys.exit(130)
    except (OSError, ValueError, struct.error) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
