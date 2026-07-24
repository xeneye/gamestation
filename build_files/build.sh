#!/bin/bash
set -ouex pipefail
cp -avf "/ctx/system_files"/. /
dnf install dnf-plugins-core
dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf install brave-origin
systemctl enable podman.socket
