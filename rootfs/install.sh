#!/bin/bash

set -e

echo "Building modules..."

rsync -a --delete /source/usb /build/

cd /build/usb/usbip
make \
    -C /lib/modules/`uname -r`/build \
    M=$PWD \
    CONFIG_USBIP_CORE=m \
    CONFIG_USBIP_VHCI_HCD=m \
    CONFIG_USBIP_VHCI_HC_PORTS=8 \
    CONFIG_USBIP_VHCI_NR_HCS=1 \
    CONFIG_USBIP_HOST=n \
    CONFIG_USBIP_DEBUG=n

echo "Caching usbip modules..."
mkdir /build/modules -p
cp /build/usb/usbip/usbip-core.ko /build/modules/
cp /build/usb/usbip/vhci-hcd.ko /build/modules/

echo "Installing cached modules..."
insmod /build/modules/usbip-core.ko
insmod /build/modules/vhci-hcd.ko

echo "Done! Waiting for exit signal before unloading modules..."

cleanup()
{
  echo "Unloading modules..."
  rmmod /build/modules/vhci-hcd.ko
  rmmod /build/modules/usbip-core.ko
  echo "Done! Bye!"
  exit
}
trap cleanup 1 2 3 6

while true
do
    sleep 1
done
