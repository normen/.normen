## WebPage-RasPi
```bash
sudo apt install xorg --no-install-recommends lightdm x11-xserver-utils
sudo vim /etc/lightdm/lightdm.conf
<<CONTENT
autologin-user=pi
autologin-session=kiosk
CONTENT
sudo vim /usr/share/xsessions/kiosk.desktop
<<CONTENT
[Desktop Entry]
Encoding=UTF-8
Name=kiosk
Type=Application
Exec=/home/pi/start-amiberry
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
# optional - cool boot screen
sudo apt install plymouth plymouth-themes
sudo plymouth-set-default-theme -R glow
```

