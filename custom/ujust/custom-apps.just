# vim: set ft=make :
####################
### custom-apps.just
####################
## Example application installation commands
## These are simplified examples adapted from Bluefin

# Install all Brewfiles at once
[group('Apps')]
install-brew-tools:
    #!/usr/bin/env bash
    echo "Installing all applications from Brewfiles..."
    brew bundle --file /usr/share/ublue-os/homebrew/default.Brewfile
    brew bundle --file /usr/share/ublue-os/homebrew/development.Brewfile
    brew bundle --file /usr/share/ublue-os/homebrew/fonts.Brewfile

# Install all Flatpaks at once
[group('Apps')]
install-all-flatpaks:
    #!/usr/bin/env bash
    echo "Installing GUI tools"
    flatpaks=(
        "net.waterfox.waterfox"
        "org.mozilla.Thunderbird"
        "org.gnome.Calculator"
        "org.gnome.Calendar"
        "org.gnome.Characters"
        "org.gnome.Connections"
        "org.gnome.Contacts"
        "org.gnome.DejaDup"
        "org.gnome.FileRoller"
        "org.gnome.Firmware"
        "org.gnome.Loupe"
        "org.gnome.Maps"
        "org.gnome.NautilusPreviewer"
        "org.gnome.Papers"
        "org.gnome.SimpleScan"
        "org.gnome.baobab"
        "org.gnome.clocks"
        "org.gnome.font-viewer"
        "org.qbittorrent.qBittorrent"
        "com.github.PintaProject.Pinta"
        "com.github.rafostar.Clapper"
        "com.github.tchx84.Flatseal"
        "com.mattjakeman.ExtensionManager"
        "io.github.flattool.Warehouse"
        "io.github.flattool.Ignition"
        "io.missioncenter.MissionCenter"
        "io.gitlab.adhami3310.Impression"
        "io.github.fabrialberio.pinapp"
        "ca.desrt.dconf-editor"
        "be.alexandervanhee.gradia"
        "me.iepure.devtoolbox"
        "org.kde.kleopatra"
        "com.sublimetext.three"
        "com.ranfdev.Distrobox"
        "io.github.kolunmi.Bazaar"
        "page.codeberg.Imaginer.Refine"
        "org.gtk.Gtk3theme.adw-gtk3"
        "org.gtk.Gtk3theme.adw-gtk3-dark"
        "org.keepassxc.KeePassXC"
        "org.signal.Signal"
    )
    for flatpak in "${flatpaks[@]}"; do
        flatpak install flathub "$flatpak" -y
    done

# Install JetBrains Toolbox for managing JetBrains IDEs
[group('Apps')]
install-jetbrains-toolbox:
    #!/usr/bin/env bash
    echo "Installing JetBrains Toolbox..."
    pushd "$(mktemp -d)"
    echo "Fetching latest version..."
    curl -sSfL -o releases.json "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release"
    BUILD_VERSION=$(jq -r '.TBA[0].build' ./releases.json)
    DOWNLOAD_LINK=$(jq -r '.TBA[0].downloads.linux.link' ./releases.json)
    CHECKSUM_LINK=$(jq -r '.TBA[0].downloads.linux.checksumLink' ./releases.json)
    echo "Installing JetBrains Toolbox ${BUILD_VERSION}"
    curl -sSfL -O "${DOWNLOAD_LINK}"
    curl -sSfL "${CHECKSUM_LINK}" | sha256sum -c
    tar zxf jetbrains-toolbox-"${BUILD_VERSION}".tar.gz
    mkdir -p $HOME/.local/share/JetBrains/ToolboxApp/
    mv jetbrains-toolbox-"${BUILD_VERSION}"/* $HOME/.local/share/JetBrains/ToolboxApp/
    popd
    echo "Launching JetBrains Toolbox..."
    $HOME/.local/share/JetBrains/ToolboxApp/bin/jetbrains-toolbox

# Shortcut for install-jetbrains-toolbox
[group('Apps')]
jetbrains-toolbox:
    @ujust install-jetbrains-toolbox

# Install a Flatpak application from Flathub
[group('Apps')]
install-flatpak APP_ID:
    #!/usr/bin/bash
    echo "Installing {{ APP_ID }} from Flathub..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub {{ APP_ID }}

# Example: Install VSCode via Flatpak
[group('Apps')]
install-vscode:
    ujust install-flatpak com.visualstudio.code

# Example: Install GIMP via Flatpak
[group('Apps')]
install-gimp:
    ujust install-flatpak org.gimp.GIMP
