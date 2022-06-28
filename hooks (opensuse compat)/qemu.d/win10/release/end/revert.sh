# debug
set -x

# load variables
source "/etc/libvirt/hooks/kvm.conf"

# unload vfio-pci
modprobe -r vfio_virqfd
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

# rebind gpu
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO
virsh nodedev-reattach $VIRSH_HD_AUDIO
virsh nodedev-reattach $VIRSH_USB_CONTROLLER

# rebind vtconsoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# read nvidia x config
sleep 2
nvidia-xconfig --query-gpu-info > /dev/null 2>&1

# bind efi framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

# load nvidia
modprobe nvidia
modprobe nvidia_uvm
modprobe nvidia_modeset
modprobe nvidia_drm
modprobe drm
modprobe drm_kms_helper

# restart display manager
systemctl start display-manager.service
systemctl restart display-manager.service

# set tuned profile
tuned-adm profile desktop

