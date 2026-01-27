#!/usr/bin/bash 

set -eoux pipefail

echo ":::group::: Installing Nvidia Akmods"
# Nvidia AKMODS
# Fetch Nvidia RPMs
skopeo copy --retry-times 3 docker://ghcr.io/ublue-os/akmods-nvidia-open:coreos-stable-"$(rpm -E %fedora)" dir:/tmp/akmods-rpms
NVIDIA_TARGZ=$(jq -r '.layers[].digest' </tmp/akmods-rpms/manifest.json | cut -d : -f 2)
tar -xvzf /tmp/akmods-rpms/"$NVIDIA_TARGZ" -C /tmp/
mv /tmp/rpms/* /tmp/akmods-rpms/

# Exclude the Golang Nvidia Container Toolkit in Fedora Repo
# Exclude for non-beta.... doesn't appear to exist for F42 yet?
dnf5 config-manager setopt excludepkgs=golang-github-nvidia-container-toolkit

echo "----------------------"
echo "Installing Nvidia RPMs"
echo "----------------------"
# Install Nvidia RPMs
curl "https://raw.githubusercontent.com/ublue-os/main/main/build_files/nvidia-install.sh" -o /tmp/nvidia-install.sh
chmod +x /tmp/nvidia-install.sh
IMAGE_NAME="silverblue-main" RPMFUSION_MIRROR="" /tmp/nvidia-install.sh
rm -f /usr/share/vulkan/icd.d/nouveau_icd.*.json
ln -sf libnvidia-ml.so.1 /usr/lib64/libnvidia-ml.so
tee /usr/lib/bootc/kargs.d/00-nvidia.toml <<EOF
kargs = ["rd.driver.blacklist=nouveau", "modprobe.blacklist=nouveau", "nvidia-drm.modeset=1", "initcall_blacklist=simpledrm_platform_driver_init"]
EOF
echo ":::endgroup:::"
