#!/usr/bin/env python
import sys
import os
import subprocess

# root filesystem
print "${voffset -1}${color0}${font Poky:size=16}H${font}${color}${goto 32}${voffset -9}Root: ${font Liberation Sans:style=Bold:size=8}${color1}${fs_free_perc /}%${color}${font} ${alignr}${color2}${fs_free /}${color}"
# /home folder (if its a separate mount point)
if os.path.ismount("/home"):
	print "${goto 32}Home: ${font Liberation Sans:style=Bold:size=8}${color1}${fs_free_perc /home}%${color}${font} ${alignr}${color2}${fs_free /home}${color}"

# folder in /media
for device in os.listdir("/media/"):
	if (not device.startswith("cdrom")) and (os.path.ismount('/media/'+device)):
		print "${goto 32}"+device.capitalize()+": ${font Liberation Sans:style=Bold:size=8}${color1}${fs_free_perc /media/"+device+"}%${color}${font} ${alignr}${color2}${fs_free /media/"+device+"}${color}"
