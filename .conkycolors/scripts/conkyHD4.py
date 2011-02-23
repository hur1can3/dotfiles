#!/usr/bin/env python
import sys
import os
import subprocess

# root filesystem
print "${voffset -1}${color0}${font Poky:size=16}H${font}${color}${goto 32}${voffset -9}Root: ${font Droid Sans:style=Bold:size=8}${color1}${fs_free_perc /}%${color}${font} ${alignr}${color2}${font Droid Sans:style=Bold:size=8}${fs_free /}${color}${font} "
# /home folder (if its a separate mount point)
if os.path.ismount("/home"):
	print "${goto 32}Home: ${font Droid Sans:style=Bold:size=8}${color1}${fs_free_perc /home}%${color}${font} ${alignr}${font Droid Sans:style=Bold:size=8}${color2}${fs_free /home}${color}${font} "

# folder in /media
for device in os.listdir("/media/"):
	if (not device.startswith("cdrom")) and (os.path.ismount('/media/'+device)):
		print "${goto 32}"+device.capitalize()+": ${font Droid Sans:style=Bold:size=8}${color1}${fs_free_perc /media/"+device+"}%${color}${font} ${alignr}${font Droid Sans:style=Bold:size=8}${color2}${fs_free /media/"+device+"}${color}${font} "
