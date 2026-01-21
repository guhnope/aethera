#!/bin/bash

set -ouex pipefail

dnf -y copr enable avengemedia/dms
dnf -y copr enable avengemedia/danklinux
dnf remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring \
nano nano-default-editor 
dnf config-manager addrepo --from-repofile=https://negativo17.org/repos/fedora-multimedia.repo
dnf install --setopt=install_weak_deps=False -y fish grim slurp mako alacritty  \
niri xwayland-satellite xdg-desktop-portal-gtk wl-clipboard wlsunset mate-polkit \
quickshell matugen cliphist dms dms-greeter material-symbols-fonts neovim greetd \
greetd-selinux qt6-qtwayland adw-gtk3-theme network-manager-applet x264 x265 rar \
ffmpeg libvpx libdvdcss imv caja atril mousepad engrampa paperwork

systemctl enable --now greetd

dnf clean all
rm -rf /var/tmp/dnf/cache/
ostree container commit
rm -rf /tmp/*
