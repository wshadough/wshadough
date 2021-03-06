# debugging
set -x

# load variables we defined
source "/etc/libvirt/hooks/kvm.conf"

# stop display manager
systemctl stop display-manager.service && pkill plasma_session # wayland sessions seem to not stop when the display manager is killed, this holds the GPU hostage and causes the libvirt script to hang; this is a dirty workaround, do not do this

sleep 1

# UNBIND VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# UNBIND EFI-framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# avoid race condition
sleep 10

# unload nvidia
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia
modprobe -r drm_kms_helper
#modprobe -r i2c_nvidia_gpu
modprobe -r drm

# unbind gpu
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO
virsh nodedev-detach $VIRSH_HD_AUDIO
virsh nodedev-detach $VIRSH_USB_CONTROLLER

# load vfio
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
