#/bin/bash
# Switch to LCD

sudo cp -rvf /etc/X11/xorg.conf.lcd xorg.conf &
sudo /etc/init.d/gdm restart &
sleep 30 && /home/hur1can3/Scripts/switchUI.sh
