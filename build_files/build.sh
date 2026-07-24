#!/bin/bash
set -ouex pipefail

cp -avf "/ctx/system_files"/. /

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
    krunner-bazaar \
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
# Kernel arguments
################################

mkdir -p /usr/lib/bootc/kargs.d

cat > /usr/lib/bootc/kargs.d/10-blacklist-hdmi.toml <<'EOF'
kargs = [
  "module_blacklist=snd_hda_intel"
]
EOF
