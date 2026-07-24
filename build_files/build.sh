#!/bin/bash
set -ouex pipefail

cp -avf "/ctx/system_files"/. /

################################
# Remove Flatpaks
################################

# Remove all bundled system Flatpaks
flatpak uninstall --all --system -y || true
flatpak uninstall --unused --system -y || true

# Remove the Flathub remote
rm -f /etc/flatpak/remotes.d/flathub.flatpakrepo
rm -rf /etc/flatpak
rm -rf /var/lib/flatpak

# Remove Flatpak and related packages
dnf5 remove -y \
    flatpak \
    flatpak-libs \
    flatpak-kcm \
    flatpak-session-helper \
    flatpak-spawn \
    flatpak-selinux \
    toolbox

################################
# Remove unwanted Bazzite packages
################################

dnf5 remove -y \
    lutris \
    waydroid \
    waydroid-selinux \
    input-remapper \
    mariadb \
    mariadb-server \
    mariadb-common \
    mariadb-errmsg \
    mariadb-connector-c \
    mariadb-connector-c-config \
    mariadb-backup \
    mariadb-cracklib-password-check \
    mariadb-gssapi-server \
    bazaar \
    khelpcenter \
    kdebugsettings \
    krdc \
    krfb \
    webapp-manager \
    fcitx5 \
    gnome-disks \
    kbd-layout-viewer5 \
    kfind \
    waydroid-container-restart \
    foreground_booster \
    kde-connect \
    kdeconnectd \
    kde-connect-libs \
    rom-properties \
    rom-properties-common \
    rom-properties-kf6 \
    rom-properties-utils \
    uupd \
    topgrade \
    bazzite-portal

################################
# Install packages
################################

dnf5 install -y dnf-plugins-core

dnf5 config-manager addrepo \
    --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

dnf5 install -y \
    brave-origin \
    google-roboto-fonts \
    google-roboto-mono-fonts \
    nerd-fonts \
    cascadia-fonts-all

################################
# Services
################################

systemctl enable podman.socket

################################
# Blacklist HDMI audio
################################

cat > /usr/lib/modprobe.d/hdmi-blacklist.conf <<'EOF'
blacklist snd_hda_intel
EOF
