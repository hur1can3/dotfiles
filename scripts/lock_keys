#!/bin/bash
icon="/usr/share/icons/gnome/48x48/devices/keyboard.png"
case $1 in
 'scrl')
 mask=3
 key="Scroll"
 ;;
 'num')
 mask=2
 key="Num"
 ;;
 'caps')
 mask=1
 key="Caps"
 ;;
esac
value=$(xset q | grep "LED mask" | sed -r "s/.*LED mask:\s+[0-9a-fA-F]+([0-9a-fA-F]).*/\1/")
if [ $(( 0x$value & 0x$mask )) == $mask ]
then
 output="$key Lock"
 output2="On"
else
 output="$key Lock"
 output2="Off"
fi
notify-send -i $icon "$output" "$output2" -t 1000
