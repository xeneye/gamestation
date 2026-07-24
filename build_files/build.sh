#!/bin/bash
set -ouex pipefail
cp -avf "/ctx/system_files"/. /
dnf5 install -y dnf-plugins-core
dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf5 install -y brave-origin
dnf5 install -y google-roboto-fonts google-roboto-mono-fonts nerd-fonts cascadia-fonts-all
systemctl enable podman.socket
