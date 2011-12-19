#!/bin/bash
dropbox start

status=$(dropbox status)

declare -i attempt=0
declare -i ATTEMPT_MAX=900	# 900 attempts gives us about 2 minutes
				# to get a connection. Also used to debug.
sleep 3

# Withing 3 seconds of invoking 'dropbox start', the status should be
# at least 'Connecting...' or beyond. In this loop, we give dropbox 2
# minutes to leave that state, otherwise we assume a problem and exit.
while test "$status" = 'Connecting...'

do
  (( attempt++ ))
  status=$(dropbox status)
  echo $attempt
  if [ "$attempt" -eq "$ATTEMPT_MAX" ]
  then
    dropbox stop
    killall dropbox
    echo "No connection after 2 minutes of trying.. giving up."
    exit 0
  fi
done

sleep 2

# After the 'Connecting...' phase, many other status' are possible.
# Instead of testing for them all, we just wait for 'Idle'. But to
# be safe, we also need to check for 'Connecting...', 'Dropbox isn't
# running!' or 'Dropbox isn't responding!'  as dropbox can regress
# if it doesn't connect. For these latter cases we want to exit also. 
status=$(dropbox status)
attempt=0
echo "Waiting on Idle status"
while test "$status" != 'Idle'

do
  ((   attempt++ ))			#Just used for debugging.
  status=$(dropbox status)
  if [ "$status" = 'Connecting...' ]
  then
      dropbox stop
      killall dropbox
      echo "No connection.. giving up."
      exit 0
  elif [ "$status" = "Dropbox isn't running!" ]
  then
    dropbox stop
    killall dropbox
    echo "Dropbox not running - reported."
    exit 0
  elif [ "$status" = "Dropbox isn't responding!" ]
  then
    killall dropbox
    echo "Dropbox isn't responding to us anymore. Exiting.."
    exit 0
  fi
  echo "$attempt"
done

dropbox stop

echo "Idle again.. exiting."	
