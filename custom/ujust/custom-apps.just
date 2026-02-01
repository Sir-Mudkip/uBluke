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
install-flatpaks:
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
        "org.virt_manager.virt-viewer"
        "org.keepassxc.KeePassXC"
        "org.signal.Signal"
    )
    for flatpak in "${flatpaks[@]}"; do
        flatpak install flathub "$flatpak" -y
    done

    # Then configure desktop to have tools in appropriate folders
    echo "Organizing apps into folders"

    # Create folder structure
    dconf write /org/gnome/desktop/app-folders/folder-children "['Internet', 'Utilities', 'Graphics', 'System', 'Development', 'Media']"

    # Internet folder
    dconf write /org/gnome/desktop/app-folders/folders/Internet/name "'Internet'"
    dconf write /org/gnome/desktop/app-folders/folders/Internet/apps "['net.waterfox.waterfox.desktop', 'org.mozilla.Thunderbird.desktop', 'org.signal.Signal.desktop', 'org.qbittorrent.qBittorrent.desktop']"

    # Utilities folder
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/name "'Utilities'"
    dconf write /org/gnome/desktop/app-folders/folders/Utilities/apps "['org.gnome.Calculator.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Characters.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.DejaDup.desktop', 'org.gnome.FileRoller.desktop', 'org.gnome.Maps.desktop', 'org.gnome.Papers.desktop', 'org.gnome.SimpleScan.desktop', 'org.gnome.baobab.desktop', 'org.gnome.clocks.desktop', 'org.gnome.font-viewer.desktop']"

    # Graphics folder
    dconf write /org/gnome/desktop/app-folders/folders/Graphics/name "'Graphics'"
    dconf write /org/gnome/desktop/app-folders/folders/Graphics/apps "['com.github.PintaProject.Pinta.desktop', 'org.gnome.Loupe.desktop', 'page.codeberg.Imaginer.Refine.desktop', 'be.alexandervanhee.gradia.desktop']"

    # Media folder
    dconf write /org/gnome/desktop/app-folders/folders/Media/name "'Media'"
    dconf write /org/gnome/desktop/app-folders/folders/Media/apps "['com.github.rafostar.Clapper.desktop']"

    # System folder
    dconf write /org/gnome/desktop/app-folders/folders/System/name "'System'"
    dconf write /org/gnome/desktop/app-folders/folders/System/apps "['org.gnome.Connections.desktop', 'org.gnome.Firmware.desktop', 'com.github.tchx84.Flatseal.desktop', 'com.mattjakeman.ExtensionManager.desktop', 'io.github.flattool.Warehouse.desktop', 'io.github.flattool.Ignition.desktop', 'io.gitlab.adhami3310.Impression.desktop', 'io.github.fabrialberio.pinapp.desktop', 'ca.desrt.dconf-editor.desktop', 'org.kde.kleopatra.desktop', 'com.ranfdev.Distrobox.desktop']"

    # Development folder
    dconf write /org/gnome/desktop/app-folders/folders/Development/name "'Development'"
    dconf write /org/gnome/desktop/app-folders/folders/Development/apps "['com.sublimetext.three.desktop', 'me.iepure.devtoolbox.desktop', 'org.virt_manager.virt-viewer.desktop', 'io.github.kolunmi.Bazaar.desktop']"

    echo "Done! Apps organized into folders."

    # Make apps appear on first page
    echo "Ensuring apps appear on the first page"
    # Force layout order so folders + KeePassXC + Terminal land on page 1
    dconf write /org/gnome/shell/app-picker-layout "[{'Internet': <{'position': <0>}>, 'Utilities': <{'position': <1>}>, 'Graphics': <{'position': <2>}>, 'Media': <{'position': <3>}>, 'System': <{'position': <4>}>, 'Development': <{'position': <5>}>, 'org.keepassxc.KeePassXC.desktop': <{'position': <6>}>, 'Terminal': <{'position': <7>}>}]"

    echo "Flatpaks Installed and Organised!"

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
