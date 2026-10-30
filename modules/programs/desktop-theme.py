import argparse
import fcntl
import io
import json
import os
import select
import socket
import struct
import subprocess
import sys
import tempfile
import time
import tomllib
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


def atomic_write(path, content):
    temporary_path = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w", dir=path.parent, delete=False
        ) as temporary:
            temporary_path = Path(temporary.name)
            temporary.write(content)
        temporary_path.replace(path)
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)


def run(command, timeout=None):
    result = subprocess.run(
        command, capture_output=True, text=True, check=True, timeout=timeout
    )
    return result.stdout.strip()


def apply_palette(theme, commands):
    styling = tomllib.loads(run([commands["wayle"], "config", "get", "styling"]))
    if styling.get("theme-provider") != "wayle":
        run([commands["wayle"], "config", "set", "styling.theme-provider", "wayle"])
    for key, color in theme["palette"].items():
        if styling.get("palette", {}).get(key) != color:
            run([commands["wayle"], "config", "set", f"styling.palette.{key}", color])


def apply_border(theme, commands):
    result = run([commands["hyprctl"], "eval", theme["hyprland"]])
    if result != "ok":
        raise ValueError(f"Hyprland rejected the theme: {result}")


class OpenRGB:
    def __init__(self, connection):
        self.connection = connection
        version = self.request(0, 40, struct.pack("<I", 3))
        if struct.unpack("<I", version)[0] < 3:
            raise ValueError("OpenRGB SDK protocol 3 is required")
        self.send(0, 50, b"desktop-theme\0")

    def send(self, device, packet, payload=b""):
        self.connection.sendall(
            struct.pack("<4sIII", b"ORGB", device, packet, len(payload)) + payload
        )

    def receive(self, size):
        result = bytearray()
        while len(result) < size:
            chunk = self.connection.recv(size - len(result))
            if not chunk:
                raise ConnectionError("OpenRGB disconnected")
            result.extend(chunk)
        return bytes(result)

    def request(self, device, packet, payload=b""):
        self.send(device, packet, payload)
        while True:
            magic, received_device, received_packet, size = struct.unpack(
                "<4sIII", self.receive(16)
            )
            if magic != b"ORGB" or size > 8 * 1024 * 1024:
                raise ValueError("Invalid OpenRGB packet")
            response = self.receive(size)
            if received_packet == 100:
                raise ValueError("OpenRGB devices changed; retry the theme update")
            if (received_device, received_packet) != (device, packet):
                raise ValueError("Unexpected OpenRGB response")
            return response

    def controllers(self):
        count = struct.unpack("<I", self.request(0, 0))[0]
        return [
            self.decode_controller(self.request(device, 1, struct.pack("<I", 3)))
            for device in range(count)
        ]

    @staticmethod
    def decode_controller(payload):
        data = io.BytesIO(payload)

        def read(format):
            return struct.unpack("<" + format, data.read(struct.calcsize("<" + format)))

        def string():
            return data.read(read("H")[0]).rstrip(b"\0").decode()

        _, device_type = read("II")
        name = string()
        vendor, description, version, serial, location = [string() for _ in range(5)]
        mode_count, active_mode = read("HI")
        static_mode = None
        modes = []
        for mode_index in range(mode_count):
            start = data.tell()
            mode_name = string()
            mode_fields = read("12I")
            color_count = read("H")[0]
            mode_colors = [read("BBBx") for _ in range(color_count)]
            mode = {
                "name": mode_name,
                "index": mode_index,
                "data": payload[start : data.tell()],
                "color_mode": mode_fields[-1],
                "colors": mode_colors,
            }
            modes.append(mode)
            if mode_name.lower() == "static":
                static_mode = mode
        zones = []
        for _ in range(read("H")[0]):
            zone_name = string()
            zone_type, _, _, led_count = read("4I")
            matrix_data = data.read(read("H")[0])
            matrix = []
            if matrix_data:
                height, width = struct.unpack_from("<II", matrix_data)
                indices = struct.unpack_from(f"<{height * width}I", matrix_data, 8)
                matrix = [
                    [
                        None if index == 0xFFFFFFFF else index
                        for index in indices[row * width : (row + 1) * width]
                    ]
                    for row in range(height)
                ]
            zones.append(
                {
                    "name": zone_name,
                    "type": zone_type,
                    "led_count": led_count,
                    "matrix": matrix,
                }
            )
        leds = [{"name": string(), "value": read("I")[0]} for _ in range(read("H")[0])]
        colors = [read("BBBx") for _ in range(read("H")[0])]
        return {
            "name": name,
            "type": device_type,
            "vendor": vendor,
            "description": description,
            "version": version,
            "serial": serial,
            "location": location,
            "modes": modes,
            "zones": zones,
            "leds": leds,
            "colors": colors,
            "active_mode": active_mode,
            "static_mode": static_mode,
        }

    def fade(self, target, duration):
        controllers = self.controllers()
        for device, controller in enumerate(controllers):
            mode = controller["static_mode"]
            if mode is None:
                raise ValueError(f"No Static mode on {controller['name']}")
            if mode["color_mode"] not in (1, 2):
                raise ValueError(
                    f"Static color updates unsupported on {controller['name']}"
                )
            if controller["active_mode"] != mode["index"]:
                self.send(
                    device,
                    1101,
                    struct.pack("<Ii", 8 + len(mode["data"]), mode["index"])
                    + mode["data"],
                )
        started = time.monotonic()
        frames = max(1, round(duration * 30))
        for frame in range(1, frames + 1):
            time.sleep(max(0, started + duration * frame / frames - time.monotonic()))
            progress = frame / frames
            progress = progress * progress * (3 - 2 * progress)
            for device, controller in enumerate(controllers):
                mode = controller["static_mode"]
                starting_colors = (
                    mode["colors"] if mode["color_mode"] == 2 else controller["colors"]
                )
                colors = b"".join(
                    struct.pack(
                        "<BBBx",
                        *(
                            round(start + (end - start) * progress)
                            for start, end in zip(color, target)
                        ),
                    )
                    for color in starting_colors
                )
                if mode["color_mode"] == 2:
                    mode_data = mode["data"][: -4 * len(starting_colors)] + colors
                    self.send(
                        device,
                        1101,
                        struct.pack("<Ii", 8 + len(mode_data), mode["index"])
                        + mode_data,
                    )
                else:
                    self.send(
                        device,
                        1050,
                        struct.pack("<IH", 6 + len(colors), len(starting_colors))
                        + colors,
                    )
        self.request(0, 0)


def lighting_accents(theme, colors_key="keyboardColors"):
    colors = [
        bytes.fromhex(color.removeprefix("#"))
        for color in theme.get(colors_key, theme["keyboardColors"])
    ]
    if not colors or any(len(color) != 3 for color in colors):
        raise ValueError("Lighting colors must be RGB hex values")
    colors.sort(
        key=lambda color: sum(
            channel * weight for channel, weight in zip(color, (2126, 7152, 722))
        )
    )
    return colors[0], colors[-1]


def keyboard_palette(theme, settings):
    colors = lighting_accents(theme)
    white_point = bytes.fromhex(settings.get("whitePoint", "#ffffff").removeprefix("#"))
    if len(white_point) != 3:
        raise ValueError("Keyboard white point must be an RGB hex value")
    result = bytearray()
    for color, key in zip(
        (colors[0], colors[-1]), ("backgroundBrightness", "highlightBrightness")
    ):
        brightness = settings[key]
        if not 0 <= brightness <= 1:
            raise ValueError("Keyboard brightness must be between zero and one")
        result.extend(
            round(channel * brightness * correction / 255)
            for channel, correction in zip(color, white_point)
        )
    return bytes(result)


class QMKLighting:
    @staticmethod
    def devices(root=Path("/sys/class/hidraw")):
        for entry in sorted(root.glob("hidraw*")):
            try:
                properties = dict(
                    line.split("=", 1)
                    for line in (entry / "device/uevent").read_text().splitlines()
                    if "=" in line
                )
                if properties.get("HID_ID", "").lower() != "0003:00000c45:000050e4":
                    continue
                descriptor = (entry / "device/report_descriptor").read_bytes()
                if descriptor.startswith(bytes.fromhex("0660ff0964a101")):
                    yield Path("/dev") / entry.name
            except FileNotFoundError:
                continue

    def __init__(self, descriptor):
        self.descriptor = descriptor

    def exchange(self, command, payload=b""):
        packet = (b"PTR1" + bytes([command]) + payload).ljust(32, b"\0")
        if len(packet) != 32:
            raise ValueError("QMK lighting report is too large")
        if os.write(self.descriptor, b"\0" + packet) != 33:
            raise OSError("Incomplete QMK lighting report")
        deadline = time.monotonic() + 0.5
        while (remaining := deadline - time.monotonic()) > 0:
            if not select.select([self.descriptor], [], [], remaining)[0]:
                break
            try:
                reply = os.read(self.descriptor, 32)
            except BlockingIOError:
                continue
            if not reply:
                raise OSError("QMK lighting device disconnected")
            if len(reply) == 32 and reply[:5] == b"PTR1" + bytes([command | 0x80]):
                if reply[31] != 0:
                    raise ValueError("QMK lighting settings were rejected")
                return reply
        raise TimeoutError("QMK lighting acknowledgement timed out")

    def update(self, colors, settings, duration):
        fade = settings["fadeMilliseconds"]
        radius = settings["radius"]
        transition = round(duration * 1000)
        if (
            not 100 <= fade <= 2000
            or not 8 <= radius <= 64
            or not 0 <= transition <= 2000
        ):
            raise ValueError("QMK lighting timing or radius is out of range")
        payload = colors + struct.pack("<HHB", fade, transition, radius)
        self.exchange(2)
        reply = self.exchange(1, payload)
        if reply[5:16] != payload:
            raise ValueError("QMK lighting acknowledgement does not match the theme")


def apply_keyboard(theme, settings, duration):
    try:
        colors = keyboard_palette(theme, settings)
        for device in QMKLighting.devices():
            descriptor = os.open(device, os.O_RDWR | os.O_NONBLOCK | os.O_CLOEXEC)
            try:
                QMKLighting(descriptor).update(colors, settings, duration)
            finally:
                os.close(descriptor)
    except (OSError, ValueError, struct.error) as error:
        print(f"QMK keyboard update failed: {error}", file=sys.stderr)


def apply_rgb(theme, duration=0.4, keyboard_settings=None):
    if keyboard_settings is not None:
        apply_keyboard(theme, keyboard_settings, duration)
    try:
        color = (
            lighting_accents(theme, "lightingColors")[0]
            if keyboard_settings is not None
            else bytes.fromhex(theme["palette"]["primary"].removeprefix("#"))
        )
        with socket.create_connection(("127.0.0.1", 6742), timeout=0.5) as connection:
            connection.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
            OpenRGB(connection).fade(color, duration)
    except (OSError, ValueError, struct.error) as error:
        print(f"OpenRGB update failed: {error}", file=sys.stderr)


def apply_theme(theme, commands, rgb_duration=0.4, keyboard_settings=None):
    wallpaper = Path(theme["wallpaper"])
    if not wallpaper.is_file():
        raise ValueError(f"Wallpaper does not exist: {wallpaper}")
    cycling = run([commands["wayle"], "config", "get", "wallpaper.cycling-enabled"])
    if cycling == "true":
        run([commands["wayle"], "config", "set", "wallpaper.cycling-enabled", "false"])
        run([commands["wayle"], "wallpaper", "stop"])
    with ThreadPoolExecutor(max_workers=4) as executor:
        updates = [
            executor.submit(
                run, [commands["wayle"], "wallpaper", "set", str(wallpaper)]
            ),
            executor.submit(apply_palette, theme, commands),
            executor.submit(apply_border, theme, commands),
            executor.submit(apply_rgb, theme, rgb_duration, keyboard_settings),
        ]
        for update in updates:
            update.result()


def main():
    definitions = json.loads(Path(sys.argv[1]).read_text())
    themes = definitions["themes"]
    names = [theme["name"] for theme in themes]
    parser = argparse.ArgumentParser(
        description="Switch wallpaper, focused border, Wayle palette, and RGB lighting together."
    )
    parser.add_argument(
        "action", choices=["list", "current", "set", "next", "previous", "restore"]
    )
    parser.add_argument("name", nargs="?", choices=names)
    arguments = parser.parse_args(sys.argv[2:])
    if (arguments.action == "set") != (arguments.name is not None):
        parser.error("Only 'set' takes a theme name, and it requires one.")
    if arguments.action == "list":
        print("\n".join(names))
        return

    state_root = Path(
        os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local/state"))
    )
    state_directory = state_root / "desktop-theme"
    state_directory.mkdir(parents=True, exist_ok=True)
    with (state_directory / "lock").open("a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        current_file = state_directory / "current"
        current = (
            current_file.read_text().strip()
            if current_file.exists()
            else definitions["default"]
        )
        if current not in names:
            current = definitions["default"]
        if arguments.action == "current":
            print(current)
            return
        selected = arguments.name or current
        if arguments.action in ("next", "previous"):
            direction = 1 if arguments.action == "next" else -1
            selected = names[(names.index(current) + direction) % len(names)]
        theme = themes[names.index(selected)]
        apply_theme(
            theme,
            definitions["commands"],
            definitions["rgbTransitionDuration"],
            definitions.get("keyboardLighting"),
        )
        atomic_write(state_directory / "active-border.lua", theme["hyprland"] + "\n")
        atomic_write(current_file, selected + "\n")
        print(selected)


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as error:
        print(
            error.stderr.strip() or error.stdout.strip() or str(error), file=sys.stderr
        )
        sys.exit(1)
    except (OSError, ValueError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
