#!/bin/bash

set -ouex pipefail


dnf remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring \
nano nano-default-editor 

dnf install --setopt=install_weak_deps=False -y fish grim slurp mako alacritty  \
niri xwayland-satellite xdg-desktop-portal-gtk wl-clipboard wlsunset mate-polkit \
greetd greetd-selinux qt6-qtwayland adw-gtk3-theme network-manager-applet neovim \
imv caja atril mousepad engrampa paperwork dnf5-plugins firewalld NetworkManager-wifi \
NetworkManager-bluetooth NetworkManager-openvpn NetworkManager-openvpn-gnome \ 
sane-backends-drivers-cameras sane-backends-drivers-scanners rsync \ 
rootfiles system-config-printer-udev system-config-printer-libs systemd-networkd \
distrobox cups buildah bluez-cups appstream open264 openvpn wget2 zip unzip \
tcpdump symlinks systemd-container


dnf -y copr enable avengemedia/dms
dnf -y copr enable avengemedia/danklinux
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
dnf install -y quickshell matugen cliphist dms dms-greeter material-symbols-fonts \
x264 x265 rar ffmpeg libvpx libdvdcss gstreamer1-plugins-good gstreamer1-plugins-bad-free

systemctl enable --now greetd
systemctl enable --now firewalld

dnf clean all
rm -rf /var/tmp/dnf/cache/
ostree container commit
rm -rf /tmp/*