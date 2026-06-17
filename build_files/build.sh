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

# Install desktop apps
dnf install --setopt=install_weak_deps=False -y neovim material-symbols-fonts ffmpeg \
niri xwayland-satellite matugen cliphist wl-clipboard wlsunset grim slurp mako adw-gtk3-theme  \
gstreamer1-plugins-good gstreamer1-plugins-bad-free imv caja atril mousepad engrampa paperwork


wget2 -O /etc/yum.repos.d/terra.repo https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-44.noarch.rpm \
               https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-44.noarch.rpm

dnf install --setopt=install_weak_deps=False -y ghostty noctalia-git noctalia-greeter \
terra-release-multimedia gamescope protontricks heroic-games-launcher-bin steam proton-plus

dnf install --setopt=install_weak_deps=False -y rar libdvdcss x264 x265

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
