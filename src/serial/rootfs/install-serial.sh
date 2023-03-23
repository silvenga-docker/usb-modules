#!/bin/bash

set -e

echo "Building modules..."

rsync -a --delete /source/usb /build/

cd /build/usb/serial
make \
    -C /lib/modules/`uname -r`/build \
    M=$PWD \
    CONFIG_USB_SERIAL=m \
    CONFIG_USB_SERIAL_GENERIC=m \
    CONFIG_USB_SERIAL_SIMPLE=m \
    CONFIG_USB_SERIAL_FTDI_SIO=m

echo "Caching serial modules..."
mkdir /build/modules -p
cp /build/usb/serial/usbserial.ko /build/modules/
cp /build/usb/serial/usb-serial-simple.ko /build/modules/
cp /build/usb/serial/ftdi_sio.ko /build/modules/

echo "Installing cached modules..."
insmod /build/modules/usbserial.ko
insmod /build/modules/usb-serial-simple.ko
insmod /build/modules/ftdi_sio.ko

echo "Done! Waiting for exit signal before unloading modules..."

cleanup()
{
  echo "Unloading modules..."
  rmmod /build/modules/ftdi_sio.ko
  rmmod /build/modules/usb-serial-simple.ko
  rmmod /build/modules/usbserial.ko
  echo "Done! Bye!"
  exit
}
trap cleanup 1 2 3 6 15

while true
do
    sleep 1
done
