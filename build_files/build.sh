#!/bin/bash
set -ouex pipefail

# =====================================================================
# 1. CLEAN OUT DEFAULT PACKAGES
# =====================================================================
dnf remove -y vim-minimal vim-enhanced firefox firefox-langpacks gnome-keyring nano \
nano-default-editor

# =====================================================================
# 2. BASE SYSTEM RUNTIMES (CORE REPO LAYER)
# =====================================================================
dnf install -y greetd greetd-selinux \
kernel-modules-extra tcpdump symlinks appstream  zip unzip wget2 bluez-cups dnf5-plugins \
 flatpak flatpak-selinux dhcp-client firewalld NetworkManager-wifi NetworkManager-bluetooth NetworkManager-openvpn libva-intel-media-driver \
NetworkManager-openvpn-gnome openvpn systemd-container systemd-networkd fish rootfiles dhcp-client

echo "Firmware"
dnf install -y  iwlwifi-mld-firmware iwlwifi-mvm-firmware
echo "Printers and Scanners"
dnf install -y cups system-config-printer-udev system-config-printer-libs ane-backends-drivers-cameras sane-backends-drivers-scanners

# =====================================================================
# 3. CORE REPO PACKAGES (NO WEAKDEPS)
# =====================================================================
dnf install --setopt=install_weak_deps=False -y neovim  \
niri xwayland-satellite matugen cliphist wl-clipboard wlsunset grim slurp mako adw-gtk3-theme \
pipewire-gstreamer gstreamer1-plugins-good gstreamer1-plugins-bad-free imv caja atril engrampa \
alsa-firmware alsa-tools-firmware alsa-utils pipewire  pipewire-alsa pipewire-pulseaudio \
pipewire-utils pipewire-jack-audio-connection-kitpaperwork gamescope gamemode ImageMagick

# =====================================================================
# 4. EXTERNAL REPOSITORY (TERRA)
# =====================================================================
wget2 -O /etc/yum.repos.d/terra.repo https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo
dnf install -y terra-release-multimedia terra-release-extras
dnf install --setopt=install_weak_deps=False -y ghostty noctalia noctalia-greeter \
unrar zed helium-browser-bin  x264 x265 vulkan-loader mesa-libEGL vulkan-tools vkBasalt
#dnf install -y steam ffmpeg xevd protonplus terra-protontricks terra-wine-dxvk

# =====================================================================
# 5. DECLARATIVE SYSTEM-WIDE FLATPAK PROVISIONING
# =====================================================================
# Create core target paths for declarative remote setups
mkdir -p /etc/flatpak/remotes.d
mkdir -p /etc/flatpak/preinstall.d
mkdir -p /etc/systemd/system

# A. Register the official Flathub upstream endpoint configuration configuration
cat << 'EOF' > /etc/flatpak/remotes.d/flathub.flatpakrepo
[Flatpak Remote]
Name=flathub
Title=Flathub
URL=https://dl.flathub.org/repo/flathub.flatpakrepo
EOF

# B. Declare baseline user applications using Flatpak's native system preinstall schema
cat << 'EOF' > /etc/flatpak/preinstall.d/aethera-apps.preinstall
[Flatpak Preinstall io.github.aerogem.Bazaar]
Branch=stable

[Flatpak Preinstall com.spotify.Client]
Branch=stable

[Flatpak Preinstall com.discordapp.Discord]
Branch=stable

[Flatpak Preinstall md.obsidian.Obsidian]
Branch=stable

[Flatpak Preinstall dev.zed.Zed]
Branch=stable
EOF


# C. Generate first-boot systemd synchronization manager to run once the network goes online
cat << 'EOF' > /etc/systemd/system/aethera-flatpak-sync.service
[Unit]
Description=Aethera Linux First-Boot Flatpak Deployment Engine
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/flatpak preinstall -y --system
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# D. Enable the system sync unit inside the image environment context
systemctl enable aethera-flatpak-sync.service

# E. Enforce system-wide uniform global flatpak override templates
mkdir -p /etc/flatpak/overrides
cat << 'EOF' > /etc/flatpak/overrides/global
[Context]
filesystems=~/.themes:ro;~/.config/gtk-3.0:ro;~/.config/gtk-4.0:ro;

[Environment]
GTK_THEME=adw-gtk3
EOF

# =====================================================================
# 6. SYSTEM CONFIGURATIONS & COMPANION WORKAROUNDS
# =====================================================================
ln -sf /usr/bin/nvim /usr/bin/vi
ln -sf /usr/bin/nvim /usr/bin/vim

systemctl enable greetd
systemctl enable firewalld

if [ -f /usr/share/doc/niri/wiki/Layer‐Shell-Components.md ]; then
    mv /usr/share/doc/niri/wiki/Layer‐Shell-Components.md /usr/share/doc/niri/wiki/Layer-Shell-Components.md
fi

# =====================================================================
# 7. COMPILING STORAGE CLEANUPS
# =====================================================================
dnf clean all
rm -rf /var/cache/*
rm -rf /var/lib/dnf/history.*
rm -rf /var/tmp/*
