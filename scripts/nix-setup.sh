#!/usr/bin/env bash
set -euo pipefail

# Exit if Nix is already installed.
if [[ -f /etc/systemd/system/nix-daemon.service ]]; then
    exit 0
fi

curl -fsSL https://install.determinate.systems/nix \
    | sh -s -- install ostree --no-confirm
