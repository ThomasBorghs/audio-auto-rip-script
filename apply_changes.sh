#!/bin/bash

echo "copying udev rules"
cp usb_dvdplayer.rules /etc/udev/rules.d/

echo "copying rip script"
cp rip_script.sh /usr/local/bin/

echo "copying abcde config"
cp .abcde.conf ~/
