#!/bin/sh
#boxee_harmony.sh
#Start boxxy by remote button press from irexec

LOCK="/tmp/${0##*/}.lock"
[ -e "${LOCK}" ] && exit 0
touch "${LOCK}"
if [ ! "$(pidof boxee)" ]
then
DISPLAY=:0 boxee & > /dev/null
sleep 10
rm "${LOCK}"
else
killall boxee
sleep 10
rm "${LOCK}"
fi
