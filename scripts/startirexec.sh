#!/bin/bash
# Checks to see if irexec is running and runs it if not already running.

youruser=hur1can3

# Test to see if IRexec is running first, if so kill it, then restart
if ps -ef|grep -v grep|grep -vi start|grep -i irexec
then
ps aux|grep -i $youruser|grep -i irexec |grep -vi start|awk '{print $2}'|xargs kill
else
# Do nothing
echo "irexec already dead!"
fi

#test to see if an instance of irexec is already running
if ps -ef|grep -v grep|grep irexec
then
# do nothing
echo "irexec already running"
else
# start irxevent
irexec -d /home/$youruser/.lircrc &
fi


