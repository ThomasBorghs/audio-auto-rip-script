#!/bin/bash

MEDIA_DIR="/media/cdrom" # Mount location of dvd
DEVICE_DIR="/dev/cdrom" # DVD Device
LOCK_FILE="/home/knuppel/rip/ripdvd.lock" # Lock File

VOB_DIR="/home/knuppel/rip/vob" # Location to store vobs
DVD_RIP_DEST_DIR="/home/knuppel/share/rip/dvd" # Location to place ATV2 encoded videos

function ripDVD {
        DVD_NAME="$(vobcopy -I 2>&1 > /dev/stdout | grep DVD-name | sed -e 's/.*DVD-name: //')"

        sudo -u knuppel vobcopy -m -o "${VOB_DIR}"
        if [ $? -ne 0 ]; then
                # vobcopy failed
                echo "*** Error during vob copy" 
                rm -rf "${VOB_DIR}/${DVD_NAME}"
                rm "${LOCK_FILE}"
                exit 1
        fi      

        FILE_NAME="${DVD_NAME}"
        INC=""
        while [ -f "${DVD_RIP_DEST_DIR}/${FILE_NAME}${INC}.mp4" ]; do ((INC=INC+1)); done;
        if [ -n "${INC}" ]; then MP4_NAME="${FILE_NAME}${INC}"; fi

        sudo -u knuppel HandBrakeCLI -i "${VOB_DIR}/${DVD_NAME}/" -o "${DVD_RIP_DEST_DIR}/${FILE_NAME}.mp4" --preset="AppleTV 2"
        if [ $? -ne 0 ]; then
                # encoding failed
                echo "*** Error during encoding"
                rm -rf "${VOB_DIR}/${DVD_NAME}"
                rm "${DVD_RIP_DEST_DIR}/${MP4_NAME}.mp4"
                rm "${LOCK_FILE}"
                exit 2
        fi      

        rm -rf "${VOB_DIR}/${DVD_NAME}"

        echo "\n\nRip of ${DVD_NAME} completed.\nEncoded to ${DVD_RIP_DEST_DIR}/${MP4_NAME}.mp4 and ${IPAD_DIR}/${MP4_NAME}.mp4"
}

function ripCD {
	sudo -u username abcde -nX
}

# Only run if not already running
if [ -f "${LOCK_FILE}" ]; then
   echo "*** Lock file present"
   exit 3
fi

touch "${LOCK_FILE}"

mount | grep "${MEDIA_DIR}" || mount "${DEVICE_DIR}" "${MEDIA_DIR}"
if [ $? -ne 0 ]; then
   # disk not mounted
   echo "*** DISK not mounted"
   rm "${LOCK_FILE}"
   exit 4
fi

sleep 10;

if [ -d "${MEDIA_DIR}/VIDEO_TS" ]; then
    ripDVD   
else ripCD
fi

umount "${MEDIA_DIR}" && eject "${DEVICE_DIR}"
rm "${LOCK_FILE}"
