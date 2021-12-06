## Amiga Rpi
```bash
# raspbian 11 - bullseye
# base update
sudo apt update
sudo apt upgrade
sudo apt install git
# compile amiberry
sudo apt install libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libflac-dev libmpg123-dev libpng-dev libmpeg2-4-dev
cd ~/
mkdir src
cd src
git clone https://github.com/midwan/amiberry
cd amiberry
make -j4 PLATFORM=rpi4-sdl2
# run amiberry in folder with subfolders
mkdir ~/amiberry
cp -r ~/src/amiberry/conf ~/amiberry
cp -r ~/src/amiberry/controllers ~/amiberry
cp -r ~/src/amiberry/data ~/amiberry
cp -r ~/src/amiberry/kickstarts ~/amiberry
cp -r ~/src/amiberry/savestates ~/amiberry
cp -r ~/src/amiberry/screenshots ~/amiberry
cp -r ~/src/amiberry/whdboot ~/amiberry
mkdir ~/src/amiberry/disks
# minimal UI
sudo apt install xorg --no-install-recommends lightdm openbox x11-xserver-utils
sudo vim /etc/lightdm/lightdm.conf
<<CONTENT
autologin-user=pi
user-session=openbox
CONTENT
mkdir /home/pi/.config/openbox
vim /home/pi/.config/openbox/autostart
chmod a+x /home/pi/.config/openbox/autostart
<<CONTENT
#!/bin/bash
# disable screen save etc
xset s off
xset s noblank
xset -dpms
cd ~/amiberry
./amiberry
CONTENT
# remove cursor
sudo vim /etc/lightdm/lightdm.conf
<<CONTENT
xserver-command=X -nocursor
CONTENT
# nice boot screen
sudo vim /boot/cmdline.txt 
# change console=tty3 and append:
<<CONTENT
loglevel=3 quiet logo.nologo
CONTENT
sudo vim /boot/config.txt
<<CONTENT
disable_overscan=1
disable_splash=1
hdmi_force_hotplug=1
CONTENT
```
