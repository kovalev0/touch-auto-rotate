#!/bin/bash -x

DIR_NAME="touch-auto-rotate"
DIR_DATA="/usr/local/bin/$DIR_NAME/"
DIR_SERVICES="/etc/systemd/system/"
DIR_VAR="/var/lib/"

# store display orientation from monitor-sensor
NAME_VAR_ORIENTATION="$DIR_VAR/orientation.txt"

# 0 - disable, 1 - enable
NAME_VAR_AUTO_ROTATE="$DIR_VAR/autorotate.txt"

# 0 - all mode, 1 - only tablet
NAME_VAR_AUTO_ROTATE_ONLY_TABLET="$DIR_VAR/autorotate_only_tablet.txt"

# depends sw-tablet-mode-iio
# 0 - laptop,  1 - tablet
NAME_VAR_MODE_TABLET="$DIR_VAR/sw-tablet-mode.txt"

# scripts
NAME_WRITER="device-rotation-writer.sh"
NAME_LISTENER="device-rotation-listener.sh"
NAME_AUTOROTATE_EN="autorotate_en.sh"
NAME_AUTOROTATE_DIS="autorotate_dis.sh"
NAME_AUTOROTATE_ONLY_TABLET_EN="autorotate_only_tablet_en.sh"
NAME_AUTOROTATE_ONLY_TABLET_DIS="autorotate_only_tablet_dis.sh"

# services
NAME_WRITER_SERVICE="device-orientation-updater.service"
NAME_LISTENER_SERVICE="touch-screen-rotator.service"

# list of touchscreen's
NAME_TOUCHSCREEN_LIST="list-touchscreens.conf"

# for acces to X server
HOME_DIRS=$(find /home -mindepth 1 -maxdepth 1 -type d)
XAUTHORITY_VALUE=""
USER_NAME="user"
