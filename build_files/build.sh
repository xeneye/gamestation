#!/bin/bash
set -ouex pipefail
cp -avf "/ctx/system_files"/. /
systemctl enable podman.socket
