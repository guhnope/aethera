#!/bin/bash

set -ouex pipefail


dnf remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring \
nano nano-default-editor 

dnf install --setopt=install_weak_deps=False -y  \
greetd greetd-selinux neovim tcpdump symlinks  \
dnf5-plugins firewalld NetworkManager-wifi open264 zip unzip \
NetworkManager-bluetooth NetworkManager-openvpn NetworkManager-openvpn-gnome 
#cups bluez-cups appstream open264 openvpn wget2 zip unzip rsync
#sane-backends-drivers-cameras sane-backends-drivers-scanners systemd-container
#rootfiles system-config-printer-udev system-config-printer-libs systemd-networkd

dnf -y copr enable avengemedia/dms
dnf -y copr enable avengemedia/danklinux
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
dnf install  --setopt=install_weak_deps=False -y quickshell matugen cliphist \
dms dms-greeter material-symbols-fonts niri xwayland-satellite xdg-desktop-portal-gtk  \
fish grim slurp mako alacritty wl-clipboard wlsunset mate-polkit qt6-qtwayland adw-gtk3-theme \
x264 x265 rar ffmpeg libvpx libdvdcss gstreamer1-plugins-good gstreamer1-plugins-bad-free \
imv caja atril mousepad engrampa paperwork network-manager-applet

systemctl enable --now greetd
systemctl enable --now firewalld

dnf clean all
rm -rf /var/tmp/dnf/cache/
ostree container commit
rm -rf /tmp/*