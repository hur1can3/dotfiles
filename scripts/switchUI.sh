#/bin/bash
# Switch between XBMC and Boxee
if ps ax | grep -v grep | grep xbmc.bin > /dev/null
then
	echo "XBMC running, killing process"
	kill `pidof xbmc.bin`
	sleep 7
	echo "running Boxee"
	/usr/bin/runBoxee &
elif ps ax | grep -v grep | grep Boxee > /dev/null
then
	echo "Boxee running, killing process"
	kill `pidof Boxee`
	sleep 7
	echo "running XBMC"
	/usr/bin/runXBMC &
else
	echo "No UI running, starting XBMC"
	/usr/bin/runXBMC &

