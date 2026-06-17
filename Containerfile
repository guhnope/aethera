FROM scratch AS ctx
COPY build_files /

FROM  quay.io/fedora/fedora-sway-atomic:44
COPY system_files /

RUN dnf remove -y \
vim-minimal vim-enhanced \
firefox firefox-langpacks \
nano nano-default-editor \
sway swaybg swayidle swaylock \
waybar fuzzel gnome-keyring

RUN dnf autoremove -y
RUN dnf clean all

RUN dnf install -y greetd cage greetd-selinux flatpak flatpak-selinux dnf5-plugins \
kernel-modules-extra firewalld tcpdump symlinks appstream cups bluez-cups wget2 \
alsa-firmware alsa-tools-firmware alsa-utils pipewire pipewire-gstreamer  zip unzip  \
pipewire-alsa pipewire-pulseaudio pipewire-utils pipewire-jack-audio-connection-kit \
 NetworkManager-wifi NetworkManager-bluetooth NetworkManager-openvpn libva-intel-media-driver \
NetworkManager-openvpn-gnome openvpn systemd-container systemd-networkd fish ImageMagick \
sane-backends-drivers-cameras sane-backends-drivers-scanners rootfiles dhcp-client \
system-config-printer-udev system-config-printer-libs iwlwifi-mld-firmware iwlwifi-mvm-firmware

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN bootc container lint
