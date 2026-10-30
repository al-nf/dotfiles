"""Set up Sunshine credentials and approve a Moonlight PIN without a browser.

Run as the desktop user on Petra (over `ssh -t` for interactive prompts).
API contract: Sunshine v2026.914.233613, src/confighttp.cpp.
"""

import argparse
import base64
import getpass
import json
import re
import ssl
import subprocess
import sys
import urllib.error
import urllib.request


def setup(username):
    password = getpass.getpass("New Sunshine password: ")
    if not password or password != getpass.getpass("Confirm password: "):
        raise ValueError("Passwords must match and must not be empty.")
    subprocess.run(["sunshine", "--creds", username, password], check=True)
    subprocess.run(["systemctl", "--user", "restart", "sunshine"], check=True)
    print("Sunshine credentials saved and service restarted.")


def pair(pin, username, name):
    if not re.fullmatch(r"[0-9]{4}", pin):
        raise ValueError("The Moonlight PIN must contain exactly four digits.")
    password = getpass.getpass("Sunshine password: ")
    authorization = base64.b64encode(f"{username}:{password}".encode()).decode()
    # Sunshine uses a self-signed certificate. Only contact the local API;
    # remote access to this helper travels over SSH.
    context = ssl._create_unverified_context()
    opener = urllib.request.build_opener(
        urllib.request.ProxyHandler({}),
        urllib.request.HTTPSHandler(context=context),
    )

    def request(payload=None):
        headers = {"Authorization": f"Basic {authorization}"}
        data = None
        if payload is not None:
            headers["Content-Type"] = "application/json"
            data = json.dumps(payload).encode()
        req = urllib.request.Request(
            "https://localhost:47990/api/pin", data=data, headers=headers
        )
        with opener.open(req, timeout=60) as response:
            return json.load(response)

    pending = request()["pairings"]
    if len(pending) != 1:
        raise ValueError(
            f"Expected one pending pairing request, found {len(pending)}. "
            "Start `petra-pair` on Babylon and leave it waiting; "
            "cancel any other pairing attempts."
        )
    result = request({"pairing_id": pending[0]["id"], "pin": pin, "name": name})
    if result.get("status") is not True:
        raise ValueError("Pairing failed. Check the PIN and start a new attempt.")
    print(f"Paired {name}. Run `petra-desktop` on Babylon.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="action", required=True)
    setup_parser = subparsers.add_parser("setup", help="Set credentials and restart Sunshine")
    setup_parser.add_argument("--username", default=getpass.getuser())
    pair_parser = subparsers.add_parser("pair", help="Approve the PIN shown by Moonlight")
    pair_parser.add_argument("pin")
    pair_parser.add_argument("--username", default=getpass.getuser())
    pair_parser.add_argument("--name", default="babylon")
    args = parser.parse_args()
    if args.action == "setup":
        setup(args.username)
    else:
        pair(args.pin, args.username, args.name)


if __name__ == "__main__":
    try:
        main()
    except urllib.error.HTTPError as error:
        print(f"Sunshine API returned HTTP {error.code}. Check your credentials.", file=sys.stderr)
        sys.exit(1)
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        print(f"Sunshine: {error}", file=sys.stderr)
        sys.exit(1)
