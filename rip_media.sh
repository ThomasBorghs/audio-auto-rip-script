#!/bin/bash

sleep 2

if [ "$ID_CDROM_MEDIA_CD" = "1" ]
then
	echo "sudo -u knuppel /home/knuppel/workspace/auto-rip-script/rip_audio_cd.sh" | at now
fi
exit 0
