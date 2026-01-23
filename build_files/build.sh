#!/bin/bash
set -ouex pipefail

dnf remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring \
nano nano-default-editor 

dnf install -y greetd greetd-selinux  \
tcpdump symlinks appstream cups zip unzip wget2 bluez-cups dnf5-plugins flatpak \
alsa-firmware alsa-tools-firmware alsa-utils pipewire pipewire-gstreamer flatpak-selinux \
pipewire-alsa pipewire-pulseaudio pipewire-utils pipewire-jack-audio-connection-kit \
firewalld NetworkManager-wifi NetworkManager-bluetooth NetworkManager-openvpn libva-intel-media-driver \
NetworkManager-openvpn-gnome openvpn systemd-container systemd-networkd fish ImageMagick \
sane-backends-drivers-cameras sane-backends-drivers-scanners rootfiles dhcp-client \
system-config-printer-udev system-config-printer-libs intel-vaapi-driver iwlwifi-mld-firmware

dnf -y copr enable avengemedia/dms
dnf -y copr enable avengemedia/danklinux
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
dnf install  --setopt=install_weak_deps=False -y quickshell matugen cliphist \
dms dms-greeter material-symbols-fonts niri xwayland-satellite xdg-desktop-portal-gtk  \
grim slurp mako alacritty wl-clipboard wlsunset mate-polkit qt6-qtwayland adw-gtk3-theme \
x264 x265 rar ffmpeg libdvdcss gstreamer1-plugins-good gstreamer1-plugins-bad-free \
imv caja atril mousepad engrampa paperwork network-manager-applet   

systemctl enable --now greetd
systemctl enable --now firewalld

rm -rf /usr/share/doc/niri
rm -rf /usr/share/licenses/niri
rm -rf /usr/share/doc/just

dnf clean all
rm -rf /var/tmp/dnf/cache/
ostree container commit
rm -rf /tmp/*