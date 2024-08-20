#!/bin/bash -x

cd "$(dirname $(readlink -e $0))"

# # install xinput, iio-sensor-proxy
# apt-get install xinput iio-sensor-proxy

# read settings
source $PWD/env.sh

if [ -z "$1" ]; then
    echo "Usage:   $0 <touchscreen_name>"
    echo "Set default: $NAME_TOUCHSCREEN"
else
    NAME_TOUCHSCREEN="$1"
fi

XINPUT_LIST=$(xinput list | grep "$NAME_TOUCHSCREEN")
if [ -z "$XINPUT_LIST" ]; then
    echo "Touchscreen '$NAME_TOUCHSCREEN' not found in xinput list."
    exit 1
fi

sed -i "s|^NAME_TOUCHSCREEN=.*|NAME_TOUCHSCREEN=\"$NAME_TOUCHSCREEN\"|" "$PWD/env.sh"

# create directories
echo "$DIR_NAME scripts  in ${DIR_DATA} directory"
echo "$DIR_NAME variables in ${DIR_VAR} directory"

mkdir -p $DIR_DATA
mkdir -p $DIR_VAR

# move exec scripts to data directory
echo "Copying scripts to $DIR_DATA directory..."
cp -f  $PWD/$NAME_WRITER $PWD/$NAME_LISTENER $PWD/env.sh $DIR_DATA

# en/dis scripts:
cp -f  $PWD/$NAME_AUTOROTATE_EN $PWD/$NAME_AUTOROTATE_DIS $DIR_DATA
cp -f  $PWD/$NAME_AUTOROTATE_ONLY_TABLET_EN $PWD/$NAME_AUTOROTATE_ONLY_TABLET_DIS $DIR_DATA

touch $NAME_VAR_AUTO_ROTATE $NAME_VAR_AUTO_ROTATE_ONLY_TABLET
chmod a+w $NAME_VAR_AUTO_ROTATE $NAME_VAR_AUTO_ROTATE_ONLY_TABLET


# root does not have access rights to the X server,
# so let's take the first available one

found=false
for home in ${HOME_DIRS[@]}; do
  if [ -d "$home" ]; then
    if [ -f "$home/.Xauthority" ]; then
      USER_NAME=$(basename "$home")
      XAUTHORITY_VALUE="$home/.Xauthority"
      echo "User: $USER_NAME"
      echo "DISPLAY: $DISPLAY_VALUE"
      echo "XAUTHORITY: $XAUTHORITY_VALUE"
      found=true
      break
    fi
  fi
done

if [ "$found" = false ]; then
  echo "No .Xauthority file found for any user. Exiting with error."
  exit 1
fi

# move service files to systemd directory
echo "Copying files to systemd ${DIR_SERVICES} directory..."
cp -f $PWD/$NAME_WRITER_SERVICE $PWD/$NAME_LISTENER_SERVICE $DIR_SERVICES

echo "Configurating service..."
echo -e "\nExecStart=/bin/bash $DIR_DATA/$NAME_WRITER " | tee -a $DIR_SERVICES/$NAME_WRITER_SERVICE
sed -i "/\[Service\]/a Environment=\"XAUTHORITY=$XAUTHORITY_VALUE\"" "$DIR_SERVICES/$NAME_LISTENER_SERVICE"
echo -e "\nExecStart=/bin/bash $DIR_DATA/$NAME_LISTENER \"$NAME_TOUCHSCREEN\" " | tee -a $DIR_SERVICES/$NAME_LISTENER_SERVICE

# enable systemd services
echo "Enabling service root..."
systemctl enable --now $NAME_WRITER_SERVICE
systemctl enable --now $NAME_LISTENER_SERVICE

# enable autorotate for all modes
source $PWD/$NAME_AUTOROTATE_EN
source $PWD/$NAME_AUTOROTATE_ONLY_TABLET_DIS

echo "Done."
