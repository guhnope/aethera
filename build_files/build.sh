#!/bin/bash
set -ouex pipefail

# 1. Clean out unwanted default packages
dnf remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring nano \
nano-default-editor

# 2. Base Fedora system packages
dnf install -y greetd greetd-selinux \
kernel-modules-extra tcpdump symlinks appstream cups zip unzip wget2 bluez-cups dnf5-plugins \
alsa-firmware alsa-tools-firmware alsa-utils pipewire pipewire-gstreamer flatpak flatpak-selinux \
pipewire-alsa pipewire-pulseaudio pipewire-utils pipewire-jack-audio-connection-kit dhcp-client \
firewalld NetworkManager-wifi NetworkManager-bluetooth NetworkManager-openvpn libva-intel-media-driver \
NetworkManager-openvpn-gnome openvpn systemd-container systemd-networkd fish ImageMagick \
sane-backends-drivers-cameras sane-backends-drivers-scanners rootfiles dhcp-client \
system-config-printer-udev system-config-printer-libs iwlwifi-mld-firmware iwlwifi-mvm-firmware

# 3. Pull down the official Terra repository file directly
wget2 -O /etc/yum.repos.d/terra.repo https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo

# 4. Enable the Terra subrepositories using modern DNF5 syntax
dnf config-manager setopt terra-multimedia.enabled=1

# 5. Install your desktop environment stack (including Neovim, Noctalia, and Ghostty)
dnf install --setopt=install_weak_deps=False -y neovim noctalia-git noctalia-greeter \
material-symbols-fonts niri xwayland-satellite xdg-desktop-portal-gtk matugen rar libdvdcss cliphist \
grim slurp mako ghostty wl-clipboard wlsunset mate-polkit qt6-qtwayland adw-gtk3-theme x264 x265 \
ffmpeg gstreamer1-plugins-good gstreamer1-plugins-bad-free imv caja atril mousepad engrampa paperwork

# 6. Create the system-wide symbolic links for vi and vim targeting neovim
ln -sf /usr/bin/nvim /usr/bin/vi
ln -sf /usr/bin/nvim /usr/bin/vim

# 7. Enable system services (No '--now' flag inside container builds)
systemctl enable greetd
systemctl enable firewalld

# 8. Safe guard for the Niri documentation rename
if [ -f /usr/share/doc/niri/wiki/Layer‐Shell-Components.md ]; then
    mv /usr/share/doc/niri/wiki/Layer‐Shell-Components.md /usr/share/doc/niri/wiki/Layer-Shell-Components.md
fi

# 9. Cleanup caches and commit ostree layer
dnf clean all
rm -rf /var/cache/libdnf5/ /var/tmp/dnf/
ostree container commit
rm -rf /tmp/*
