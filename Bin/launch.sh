#!/bin/bash
#
# sorts dmenu entries by usage
#
###

if [ -f $HOME/.dmenurc ]; then
  . $HOME/.dmenurc
else
  DMENU='dmenu -i'
fi

CACHE="$HOME/.dmenu_cache_recent"

touch $CACHE

MOST_USED=$(LC_ALL="C"; sort $CACHE | uniq -c | sort -r | colrm 1 8)

RUN="$((echo "$MOST_USED"; dmenu_path | grep -vx "$MOST_USED") | $DMENU)"

if [ -n "$RUN" ]; then
  (echo $RUN; head -n99 $CACHE) > $CACHE.$$ && mv $CACHE.$$ $CACHE

  $RUN &
fi
