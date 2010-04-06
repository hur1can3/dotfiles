# If an external monitor is connected, place it with xrandr
 
# External output may be "VGA" or "VGA-0" or "DVI-0" or "TMDS-1"
EXTERNAL_OUTPUT="DVI-0"
INTERNAL_OUTPUT="LVDS"

## EXTERNAL_LOCATION may be one of: left, right, above, or below
#EXTERNAL_LOCATION="right"
 
#case "$EXTERNAL_LOCATION" in
#       left|LEFT)
#               EXTERNAL_LOCATION="--left-of $INTERNAL_OUTPUT"
#               ;;
#       right|RIGHT)
#               EXTERNAL_LOCATION="--right-of $INTERNAL_OUTPUT"
#               ;;
#       top|TOP|above|ABOVE)
#               EXTERNAL_LOCATION="--above $INTERNAL_OUTPUT"
#               ;;
#       bottom|BOTTOM|below|BELOW)
#               EXTERNAL_LOCATION="--below $INTERNAL_OUTPUT"
#               ;;
#       *)
#               EXTERNAL_LOCATION="--left-of $INTERNAL_OUTPUT"
#               ;;
#esac
 
xrandr |grep $EXTERNAL_OUTPUT | grep " connected "
if [ $? -eq 0 ]; then
    #xrandr --output $INTERNAL_OUTPUT -off --output $EXTERNAL_OUTPUT --auto 
    # Alternative command in case of trouble:
    (sleep 2; xrandr --output $EXTERNAL_OUTPUT --auto --output $INTERNAL_OUTPUT --off) &
else
    xrandr --output $INTERNAL_OUTPUT --auto --output $EXTERNAL_OUTPUT --off
fi
 
