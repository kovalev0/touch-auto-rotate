# touch-auto-rotate
Based on the fork https://github.com/DanielMehlber/mate-touch-rotate

Systemd service to identify orientation of device in order to rotate display and touchscreen.

## Install

```
su-
apt-get install  xinput iio-sensor-proxy
cd /path/to/dir/touch-auto-rotate
chmod +x ./*.sh
./install.sh [DEVICES]    # default "FTSC1000:00 2808:5682" touchscreen for Aquarius
```

You can find out the names or ids of your devices by using

```
xinput --list
```

## ENABLE auto rotate

```
./autorotate_en.sh
```
If only in tablet mode, then additionally:

```
./autorotate_only_tablet_en.sh
```
Cancel this auto-rotation restriction:
```
./autorotate_only_tablet_dis.sh
```

## DISABLE auto rotate
```
./autorotate_dis.sh
```

## Uninstall 
Just run uninstall.sh

...
su -
./uninstall.sh
...
