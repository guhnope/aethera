#!/bin/bash
set -ouex pipefail

dnf remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring nano \
nano-default-editor

dnf install -y greetd greetd-selinux \
kernel-modules-extra tcpdump symlinks appstream cups zip unzip wget2 bluez-cups dnf5-plugins \
alsa-firmware alsa-tools-firmware alsa-utils pipewire pipewire-gstreamer flatpak flatpak-selinux \
pipewire-alsa pipewire-pulseaudio pipewire-utils pipewire-jack-audio-connection-kit dhcp-client \
firewalld NetworkManager-wifi NetworkManager-bluetooth NetworkManager-openvpn libva-intel-media-driver \
NetworkManager-openvpn-gnome openvpn systemd-container systemd-networkd fish ImageMagick \
sane-backends-drivers-cameras sane-backends-drivers-scanners rootfiles dhcp-client \
system-config-printer-udev system-config-printer-libs iwlwifi-mld-firmware iwlwifi-mvm-firmware

ln -sf /usr/bin/nvim /usr/bin/vi
ln -sf /usr/bin/nvim /usr/bin/vim

dnf install -y --nogpgcheck --repofrompath "terra,https://repos.fyralabs.com/terra/\$releasever" terra-release
dnf config-manager --set-enabled terra-multimedia

dnf install --setopt=install_weak_deps=False -y noctalia-git noctalia-greeter \
material-symbols-fonts niri xwayland-satellite xdg-desktop-portal-gtk matugen rar libdvdcss cliphist \
grim slurp mako ghostty wl-clipboard wlsunset mate-polkit qt6-qtwayland adw-gtk3-theme x264 x265 \
ffmpeg gstreamer1-plugins-good gstreamer1-plugins-bad-free imv caja atril mousepad engrampa paperwork

systemctl enable greetd
systemctl enable firewalld

if [ -f /usr/share/doc/niri/wiki/Layer‐Shell-Components.md ]; then
    mv /usr/share/doc/niri/wiki/Layer‐Shell-Components.md /usr/share/doc/niri/wiki/Layer-Shell-Components.md
fi

dnf clean all
rm -rf /var/cache/dnf/ /var/tmp/dnf/
ostree container commit
rm -rf /tmp/*
