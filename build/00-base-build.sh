#!usr/bin/bash

echo "Foundations"
echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/

# Consolidate Just Files
mkdir -p /usr/share/ublue-os/ujust/
find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy Flatpak Preinstall Service
cp /ctx/system/flatpak-preinstall.service /usr/lib/systemd/system/

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Building Image..."

# Install Packages
/ctx/build/10-packages.sh

# Install Brave
/ctx/build/15-brave.sh

/ctx/build/20-sysconfig.sh

# Clean Scripts
/ctx/build/50-clean.sh

# Validate Repos
/ctx/build/55-validate-repos.sh

echo "::endgroup::"

echo "Finalising build"
