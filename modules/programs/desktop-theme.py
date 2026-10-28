import argparse
import fcntl
import json
import os
import subprocess
import sys
import tempfile
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


def run(command):
    result = subprocess.run(command, capture_output=True, text=True, check=True)
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


def apply_theme(theme, commands):
    wallpaper = Path(theme["wallpaper"])
    if not wallpaper.is_file():
        raise ValueError(f"Wallpaper does not exist: {wallpaper}")
    cycling = run([commands["wayle"], "config", "get", "wallpaper.cycling-enabled"])
    if cycling == "true":
        run([commands["wayle"], "config", "set", "wallpaper.cycling-enabled", "false"])
        run([commands["wayle"], "wallpaper", "stop"])
    with ThreadPoolExecutor(max_workers=3) as executor:
        updates = [
            executor.submit(
                run, [commands["wayle"], "wallpaper", "set", str(wallpaper)]
            ),
            executor.submit(apply_palette, theme, commands),
            executor.submit(apply_border, theme, commands),
        ]
        for update in updates:
            update.result()


def main():
    definitions = json.loads(Path(sys.argv[1]).read_text())
    themes = definitions["themes"]
    names = [theme["name"] for theme in themes]
    parser = argparse.ArgumentParser(
        description="Switch wallpaper, focused border, and Wayle palette together."
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
        apply_theme(theme, definitions["commands"])
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
