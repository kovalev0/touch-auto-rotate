# touch-auto-rotate
Based on the fork https://github.com/DanielMehlber/mate-touch-rotate

Systemd service to identify orientation of device in order to rotate display and touchscreen.

Tested on ALT linux distro

## Install

```
su-
apt-get install  xinput iio-sensor-proxy
cd /path/to/dir/touch-auto-rotate
chmod +x ./*.sh
bash ./install.sh [DEVICE]    # default search in conf.d/list-touchscreens.conf
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

```
su -
bash ./uninstall.sh
```

## License
This project is licensed under the GNU General Public License v3.0. See the LICENSE file for details.
