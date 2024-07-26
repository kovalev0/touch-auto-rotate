#!/bin/bash

cd "$(dirname $(readlink -e $0))"

# read settings
source $PWD/env.sh

previous_orientation=""
en_rotate_display=0

function do_rotate
{  
  TRANSFORM='Coordinate Transformation Matrix'
    
  case "$current_orientation" in
    normal)
      for dev in "$@";
        do
        [ "$dev" != "None" ]    && xinput set-prop "$dev"  "$TRANSFORM" 1 0 0 0 1 0 0 0 1
      done 
      ;;
    inverted)
      for dev in "$@";
        do
        [ "$dev" != "None" ]    && xinput set-prop "$dev"  "$TRANSFORM" -1 0 1 0 -1 1 0 0 1
      done 
      ;;
    left)
      for dev in "$@"; 
        do
        [ "$dev" != "None" ]    && xinput set-prop "$dev"  "$TRANSFORM" 0 -1 1 1 0 0 0 0 1
      done 
      ;;
    right)
      for dev in "$@";
        do
        [ "$dev" != "None" ]    && xinput set-prop "$dev"  "$TRANSFORM" 0 1 0 -1 0 1 0 0 1
      done 
      ;;
    *)
      # echo "Error: orientataion not recognized!"
      ;;
  esac
}
# wait for modification of the orientation file.
while true
do
    # pause
    sleep 1;

    # Get display name
    XDISPLAY=$(xrandr --current | grep primary | sed -e 's/ .*//g')
    # echo "name XDISPLAY = $XDISPLAY"

    tablet_mode=0
    auto_rotate_en=0
    autorotate_only_tablet=0

    if [ -f "$NAME_VAR_AUTO_ROTATE" ]; then
        auto_rotate_en=$(cat "$NAME_VAR_AUTO_ROTATE")
        if [ "$auto_rotate_en" -ne 0 ] && [ "$auto_rotate_en" -ne 1 ]; then
            # echo "bad auto_rotate_en, value = $auto_rotate_en"
            auto_rotate_en=0
        fi
    fi

    if [ -f "$NAME_VAR_AUTO_ROTATE_ONLY_TABLET" ]; then
        autorotate_only_tablet=$(cat "$NAME_VAR_AUTO_ROTATE_ONLY_TABLET")
        if [ "$autorotate_only_tablet" -ne 0 ] && [ "$autorotate_only_tablet" -ne 1 ]; then
            # echo "bad autorotate_only_tablet, value = $autorotate_only_tablet"
            autorotate_only_tablet=0
        fi        
    fi

    if [ -f "$NAME_VAR_MODE_TABLET" ]; then
        tablet_mode=$(cat "$NAME_VAR_MODE_TABLET")
        if [ "$tablet_mode" -ne 0 ] && [ "$tablet_mode" -ne 1 ]; then
            # echo "bad tablet_mode, value = $tablet_mode"
            tablet_mode=0
        fi         
    fi

    if [ "$autorotate_only_tablet" -eq 1 ] && [ "$tablet_mode" -eq 0 ]; then
        # echo "Block auto rotate"
        auto_rotate_en=0
    fi

    if [ "$auto_rotate_en" -eq 1 ]; then
        current_orientation=$(tail -1 "${NAME_VAR_ORIENTATION}")

        # echo "Auto Rotate enabled"
        en_rotate_display="1"

        # parse orientation
        case "$current_orientation" in
            *"normal"*)
                current_orientation="normal"
            ;;
            *"bottom-up"*)
                current_orientation="inverted"
            ;;
            *"right-up"*)
                current_orientation="right"
            ;;
            *"left-up"*)
                current_orientation="left"
            ;;
            *)
                # echo "event skipped -- no change in orientation"
                continue
            ;;
        esac
    else
        current_orientation=$(xrandr --current | grep "$XDISPLAY connected" | awk '{if ($5 == "(") print "normal"; else print $5}')

        # echo "Auto Rotate disabled"
        en_rotate_display="0"

        # parse orientation
        case "$current_orientation" in
            *"(normal"*)
                current_orientation="normal"
            ;;
            *"inverted"*)
                current_orientation="inverted"
            ;;
            *"right"*)
                current_orientation="right"
            ;;
            *"left"*)
                current_orientation="left"
            ;;
            *)
                # echo "event skipped -- no change in orientation"
                continue
            ;;
        esac        
    fi
    
    # echo "Current screen orientation: $current_orientation"

    if [ "$en_rotate_display" -eq 1 ]; then
        xrandr --output $XDISPLAY --rotate $current_orientation
    fi

    if [ "$current_orientation" != "$previous_orientation" ]; then
        do_rotate "$@"
        previous_orientation=$current_orientation  
    fi

done
