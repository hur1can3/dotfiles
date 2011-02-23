#!/usr/bin/env python
import sys
import os
import subprocess

# root filesystem
print "${voffset -2}${color0}${font Poky:size=15}y${font}${color}${offset 6}${voffset -7}Root: ${font Droid Sans:style=Bold:size=8}${color1}${fs_free_perc /}%${color}${font}"
print "${voffset 2}${color0}${fs_bar 4,20 /}${color}${offset 8}${voffset -2}F: ${font Droid Sans:style=Bold:size=8}${color2}${fs_free /}${color}${font} U: ${font Droid Sans:style=Bold:size=8}${color2}${fs_used /}${color}${font} "

# /home folder (if its a separate mount point)
if os.path.ismount("/home"):
	print "${voffset -2}${color0}${font Poky:size=15}y${font}${color}${offset 6}${voffset -7}Home: ${font Droid Sans:style=Bold:size=8}${color1}${fs_free_perc /home}%${color}${font}"
	print "${voffset 2}${color0}${fs_bar 4,20 /home}${color}${offset 8}${voffset -2}F: ${font Droid Sans:style=Bold:size=8}${color2}${fs_free /home}${color}${font} U: ${font Droid Sans:style=Bold:size=8}${color2}${fs_used /home}${color}${font} "

# folder in /media
for device in os.listdir("/media/"):
	if (not device.startswith("cdrom")) and (os.path.ismount('/media/'+device)):
		print "${voffset -2}${color0}${font Poky:size=15}y${font}${color}${offset 6}${voffset -7}"+device.capitalize()+": ${font Droid Sans:style=Bold:size=8}${color1}${fs_free_perc /media/"+device+"}%${color}${font}"
		print "${voffset 2}${color0}${fs_bar 4,20 /media/"+device+"}${color}${offset 8}${voffset -2}F: ${font Droid Sans:style=Bold:size=8}${color2}${fs_free /media/"+device+"}${color}${font} U: ${font Droid Sans:style=Bold:size=8}${color2}${fs_used /media/"+device+"}${color}${font} "
