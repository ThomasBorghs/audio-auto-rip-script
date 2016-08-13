#!/bin/bash

MEDIA=
RIP_LOG_LOCATION="/var/log/rip/rip.log"

sleep 2
( set -o posix ; set ) >> "/var/log/rip/rip_posix_debug.log"
cd /home/knuppel/workspace/auto-rip-script

if [ "$ID_CDROM_MEDIA_BD" = "1" ]
then
        MEDIA=bluray
        (
        echo "$MEDIA" >> /var/log/rip/DiscTypeTest.log
        ) &
elif [ "$ID_CDROM_MEDIA_DVD" = "1" ]
then
        MEDIA=dvd
        (
        echo "$MEDIA" >> /var/log/rip/DiscTypeTest.log
        ) &
elif [ "$ID_CDROM_MEDIA_CD" = "1" ]
then
	echo "ripping audio cd" >> "$RIP_LOG_LOCATION"
	echo "sudo -u knuppel ./rip_audio_cd.sh" | at now
fi
exit 0
