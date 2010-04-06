#!/bin/bash
#
# pbrisbin 2009
#
# http://pbrisbin.com:8080/bin/mzen.sh
#
#
###

# dzen2-svn required for xft font
#FONT='-xos4-terminus-*-*-*-*-12-*-*-*-*-*-*-*'
FONT='Verdana-8'
FG='#606060'     # light grey
BG='#303030'     # dark grey

# sets up a status bar across the 
# bottom of my 1920x1080 screen
W=1920
H=15
X=0
Y=$((1080-H))

# gdbar
bar_FG='#909090' # really light grey
bar_BG='#606060'
bar_W=200
bar_H=4

# emphasis color
color='#909090'

while true; do
  stat=($(mpc --format "" | head -n2 | grep -Po "(^\[.*\]|[0-9]{1,3}%)" | sed 's/%//g;s/\[//g;s/\]//g'))
  IFS='+'
  music=($(mpc --format "%title%+%artist%+%album%" | head -n1))
  unset IFS

  echo -n "   mpd: [ ^fg($color)${stat[0]} ^fg()] :: ^fg($color)${music[0]} ^fg()by ^fg($color)${music[1]} ^fg()on [ ^fg($color)${music[2]} ^fg()]  " 
  echo "${stat[1]} 100" | gdbar -h $bar_H -w $bar_W -fg $bar_FG -bg $bar_BG | sed -r 's/\ [0-9]{1,2}%//g;s/100%//g;s/\ \ \ /\ \ /g'
  sleep 1
done | dzen2 -ta l -h $H -tw $W -x $X -y $Y -fg $FG -bg $BG -fn $FONT -e "button1=exec:mpc --no-status toggle;button2=exec:mpc --no-status prev;button3=exec:mpc --no-status next;button4=exec:ossvol -i 1;button5=exec:ossvol -d 1"
