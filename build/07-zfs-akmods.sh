#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="
set -eoux pipefail

# ZFS for gts/stable
# Fetch ZFS RPMs
skopeo copy --retry-times 3 docker://ghcr.io/ublue-os/akmods-zfs:coreos-stable-"$(rpm -E %fedora)" dir:/tmp/akmods-zfs
ZFS_TARGZ=$(jq -r '.layers[].digest' </tmp/akmods-zfs/manifest.json | cut -d : -f 2)
tar -xvzf /tmp/akmods-zfs/"$ZFS_TARGZ" -C /tmp/
mv /tmp/rpms/* /tmp/akmods-zfs/

# Get the installed kernel version (not build host)
KERNEL_VERSION=$(rpm -q kernel --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' | tail -n1)

# Declare ZFS RPMs
ZFS_RPMS=(
    /tmp/akmods-zfs/kmods/zfs/kmod-zfs-"${KERNEL_VERSION}"-*.rpm
    /tmp/akmods-zfs/kmods/zfs/libnvpair[0-9]-*.rpm
    /tmp/akmods-zfs/kmods/zfs/libuutil[0-9]-*.rpm
    /tmp/akmods-zfs/kmods/zfs/libzfs[0-9]-*.rpm
    /tmp/akmods-zfs/kmods/zfs/libzpool[0-9]-*.rpm
    /tmp/akmods-zfs/kmods/zfs/python3-pyzfs-*.rpm
    /tmp/akmods-zfs/kmods/zfs/zfs-*.rpm
    pv
)

# Install
dnf5 -y install "${ZFS_RPMS[@]}"

# Depmod and autoload
depmod -a -v "${KERNEL_VERSION}"
echo "zfs" > /usr/lib/modules-load.d/zfs.conf

echo "::endgroup::"
