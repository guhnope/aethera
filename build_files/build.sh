#!/bin/bash

set -ouex pipefail


dnf remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring \
nano nano-default-editor 

dnf install --setopt=install_weak_deps=False -y fish grim slurp mako alacritty  \
niri xwayland-satellite xdg-desktop-portal-gtk wl-clipboard wlsunset mate-polkit \
greetd greetd-selinux qt6-qtwayland adw-gtk3-theme network-manager-applet neovim \
imv caja atril mousepad engrampa paperwork dnf5-plugins firewalld NetworkManager-wifi \
NetworkManager-bluetooth NetworkManager-openvpn NetworkManager-openvpn-gnome

dnf -y copr enable avengemedia/dms
dnf -y copr enable avengemedia/danklinux
dnf install -y quickshell matugen cliphist dms dms-greeter material-symbols-fonts

#dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
#dnf -y install x264 x265 rar ffmpeg libvpx libdvdcss

systemctl enable --now greetd

dnf clean all
rm -rf /var/tmp/dnf/cache/
ostree container commit
rm -rf /tmp/*
