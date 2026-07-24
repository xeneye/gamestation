#!/bin/bash
set -ouex pipefail
cp -avf "/ctx/system_files"/. /
dnf5 install dnf-plugins-core
dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf5 install brave-origin
systemctl enable podman.socket
