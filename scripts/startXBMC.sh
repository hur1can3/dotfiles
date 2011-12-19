#!/bin/sh
#xbmc_harmony.sh
#Start xbmc by remote button press from irexec

LOCK="/tmp/${0##*/}.lock"
[ -e "${LOCK}" ] && exit 0
touch "${LOCK}"

if [ ! "$(pidof xbmc.bin)" ]
then
DISPLAY=:0 xbmc & > /dev/null
sleep 10
rm "${LOCK}"
else
killall xbmc.bin
sleep 10
rm "${LOCK}"
fi
