#/bin/bash
# Switch to TV

sudo cp -rvf /etc/X11/xorg.conf.tv xorg.conf &
sudo /etc/init.d/gdm restart &
sleep 30 && /home/hur1can3/Scripts/switchUI.sh
