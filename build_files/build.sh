#!/bin/bash
set -ouex pipefail

cp -avf /ctx/system_files/etc/. /etc/

################################
# Remove Flatpaks
################################

# Remove all bundled system Flatpaks
flatpak uninstall --all --system -y || true
flatpak uninstall --unused --system -y || true

# Remove the Flathub remote and local Flatpak data
rm -f /etc/flatpak/remotes.d/flathub.flatpakrepo
rm -rf /etc/flatpak
rm -rf /var/lib/flatpak

# Remove Flatpak and related packages
dnf5 remove -y \
    flatpak \
    flatpak-kcm \
    flatpak-libs \
    flatpak-selinux \
    flatpak-session-helper \
    flatpak-spawn \
    toolbox

################################
# Remove unwanted Bazzite packages
################################

dnf5 remove -y \
    bazaar \
    bazzite-portal \
    fcitx5 \
    foreground_booster \
    gnome-disk-utility \
    input-remapper \
    kbd-layout-viewer5 \
    kcm-fcitx \
    kde-connect \
    kde-connect-libs \
    kdeconnectd \
    kfind \
    khelpcenter \
    krdc \
    krfb \
    lutris \
    mariadb \
    mariadb-backup \
    mariadb-common \
    mariadb-connector-c \
    mariadb-connector-c-config \
    mariadb-cracklib-password-check \
    mariadb-errmsg \
    mariadb-gssapi-server \
    mariadb-server \
    rom-properties \
    rom-properties-common \
    rom-properties-kf6 \
    rom-properties-utils \
    topgrade \
    uupd \
    waydroid \
    waydroid-container-restart \
    waydroid-selinux \
    webapp-manager

################################
# Remove leftover Bazzite overlay files
################################

# Waydroid launcher
rm -f /usr/share/applications/waydroid-container-restart.desktop

# Waydroid helper scripts
rm -f \
    /usr/libexec/waydroid-container-restart \
    /usr/libexec/waydroid-container-start \
    /usr/libexec/waydroid-container-stop \
    /usr/libexec/waydroid-fix-controllers

# Waydroid application directory
rm -rf /usr/share/applications/Waydroid

# Bazzite launchers
rm -f \
    /usr/share/applications/bazzite-documentation.desktop \
    /usr/share/applications/discourse.desktop \
    /usr/share/applications/system-update.desktop

################################
# Configure repositories
################################

# Install config-manager
dnf5 install -y dnf-plugins-core

# Enable Terra repository
dnf5 config-manager setopt terra.enabled=1

# Add Brave Browser repository
dnf5 config-manager addrepo \
    --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

################################
# Install packages
################################

dnf5 install -y \
    brave-origin \
    cascadia-fonts-all \
    google-roboto-fonts \
    google-roboto-mono-fonts \
    nerd-fonts \
    protonplus

################################
# Prepare Nix
################################

mkdir -p /nix
mkdir -p /var/usrlocal/bin
install -m755 /ctx/scripts/nix-setup.sh /var/usrlocal/bin/nix-setup.sh

################################
# Enable services
################################

systemctl enable podman.socket
systemctl enable nix-setup.service

################################
# Blacklist HDMI audio
################################

cat >/usr/lib/modprobe.d/hdmi-blacklist.conf <<'EOF'
blacklist snd_hda_intel
EOF
