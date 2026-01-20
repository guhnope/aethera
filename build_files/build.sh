#!/bin/bash

set -ouex pipefail

dnf5 -y copr enable avengemedia/dms
dnf5 -y copr enable avengemedia/danklinux
dnf5 remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring \
nano nano-default-editor 

dnf5 install --setopt=install_weak_deps=False -y fish grim slurp mako alacritty  \
niri xwayland-satellite xdg-desktop-portal-gtk wl-clipboard wlsunset mate-polkit \
quickshell matugen cliphist dms dms-greeter material-symbols-fonts neovim greetd \
greetd-selinux qt6-qtwayland adw-gtk3-theme network-manager-applet x264 x265 rar \
ffmpeg libvpx libdvdcss imv caja atril mousepad engrampa paperwork

systemctl enable --now greetd

dnf5 clean all
rm -rf /var/tmp/dnf/cache/
ostree container commit
rm -rf /tmp/*
