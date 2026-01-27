#!usr/bin/bash

echo "Foundations"
echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/

# Consolidate Just Files
mkdir -p /usr/share/ublue-os/ujust/
find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Building Image..."

# Install Kernel Akmods
# /ctx/build/05-install-kernel-akmods.sh

# Install Nvidia Akmods
# /ctx/build/06-nvidia-akmods.sh

# Install ZFS
# /ctx/build/07-zfs-akmods.sh

# Install Packages
/ctx/build/10-packages.sh

# Install Brave
/ctx/build/15-brave.sh

# Clean Scripts
/ctx/build/50-clean.sh

# Validate Repos
/ctx/build/55-validate-repos.sh
