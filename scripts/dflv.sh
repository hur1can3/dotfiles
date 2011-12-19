#!/bin/bash
count=$(ls /tmp/Flash* | wc -l)

function cancel
{
if [ "$?" = 1 ]; then
exit 1
fi
}

if [ "$count" = 0 ]
then /usr/bin/zenity –error –title=”ERROR!” –text=”There is no video saved in your /tmp directory. Please wait until it is completely saved.”
exit 1

elif [ "$count" != 1 ]
then /usr/bin/zenity –error –title=”ERROR!” –text=”There are two or more instances of a flash video in your /tmp directory, Nautilus will now open. Please select the video you want to save.”
nautilus /tmp/
else
name=$(/usr/bin/zenity –entry –title=”Name your Video” –height=100 –width=300 –text=”Please name your video “)
cancel
cp /tmp/Fla* ~/Videos/”$name”

fi
