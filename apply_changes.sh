#!/bin/bash

echo "copying udev rules"
cp usb_dvdplayer.rules /etc/udev/rules.d/
udevadm control -R

echo "copying rip script"
cp rip_media.sh /usr/local/bin/

echo "copying abcde config"
sudo -u knuppel cp .abcde.conf ~/
