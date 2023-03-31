#!/usr/bin/env bash

# shellcheck disable=SC2164
cd /var/lib/vz/template/iso

URL=https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
IMAGE_NAME="ubuntu-2204-cloudinit-template"
VM_ID=9001

wget ${URL} -O "${IMAGE_NAME}.img"

qm create ${VM_ID} --name ${IMAGE_NAME} --memory 2048 --net0 virtio,bridge=vmbr1

mv "${IMAGE_NAME}.img" "${IMAGE_NAME}.qcow2"

qm importdisk ${VM_ID} "${IMAGE_NAME}.qcow2" local-zfs

qm set $VM_ID --sata0 local-zfs:vm-${VM_ID}-disk-0

qm set $VM_ID --ide2 local-zfs:cloudinit

qm set $VM_ID --boot c --bootdisk sata0

qm set $VM_ID --serial0 socket --vga serial0

qm template $VM_ID
