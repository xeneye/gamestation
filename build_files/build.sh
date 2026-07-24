#!/bin/bash
set -ouex pipefail
cp -avf "/ctx/system_files"/. /
sudo dnf install dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf install brave-origin
systemctl enable podman.socket
