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

dnf install --setopt=install_weak_deps=False -y neovim ffmpeg \
niri xwayland-satellite matugen cliphist wl-clipboard wlsunset grim slurp mako adw-gtk3-theme  \
gstreamer1-plugins-good gstreamer1-plugins-bad-free imv caja atril mousepad engrampa paperwork


wget2 -O /etc/yum.repos.d/terra.repo https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-44.noarch.rpm \
               https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-44.noarch.rpm

dnf install --setopt=install_weak_deps=False -y ghostty noctalia-git noctalia-greeter \
terra-release-multimedia gamescope protontricks heroic-games-launcher-bin steam proton-plus

dnf install --setopt=install_weak_deps=False -y rar libdvdcss x264 x265

flatpak override --user --filesystem=$HOME/.themes:ro
flatpak override --user --filesystem=$HOME/.config/gtk-3.0:ro
flatpak override --user --filesystem=$HOME/.config/gtk-4.0:ro
flatpak override --user --env=GTK_THEME=adw-gtk3


ln -sf /usr/bin/nvim /usr/bin/vi
ln -sf /usr/bin/nvim /usr/bin/vim

systemctl enable greetd
systemctl enable firewalld

if [ -f /usr/share/doc/niri/wiki/Layer‐Shell-Components.md ]; then
    mv /usr/share/doc/niri/wiki/Layer‐Shell-Components.md /usr/share/doc/niri/wiki/Layer-Shell-Components.md
fi

dnf clean all
rm -rf /var/cache/libdnf5/ /var/tmp/dnf/
ostree container commit
rm -rf /tmp/*
