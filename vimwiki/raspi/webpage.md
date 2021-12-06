## WebPage-RasPi
```bash
# edit /boot/cmdline.txt !! every thing need to be in one line!!
<<CONTENT
dwc_otg.lpm_enable=0 console=serial0,115200 console=tty3 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet vt.global_cursor_default=0 logo.nologo loglevel=3
CONTENT
# then edit /boot/config.txt and append the following lines on the end:
<<CONTENT
disable_overscan=1
disable_splash=1
hdmi_force_hotplug=1
CONTENT
# instead of the black boot screen you can run a theme, show a logo or play a vid. for this install plymouth
apt-get install plymouth plymouth-themes
# set a theme and change the initrd.img:
plymouth-set-default-theme -R glow
# with this settings your raspberry will boot without showing output and present a custom boot screen.

# if you dont want something else on raspberry that a browser and your web page in kiosk mode, raspbian-lite with Matchbox as window manager is sufficient.
sudo -i
apt-get update
apt-get install xorg --no-install-recommends gdm3 matchbox x11-xserver-utils Iceweasel
apt-get install -f
# now you need to config the display manager /etc/gdm3/daemon.conf and let the pi unser log in automatically
<<CONTENT
[daemon]
# Enabling automatic login
AutomaticLoginEnable = true
AutomaticLogin = pi
CONTENT
# for the user pi the following session settings will be defined in /home/pi/.xsession
<<CONTENT
#!/bin/bash
xset -dpms     
xset s off    
xset s noblank
matchbox-window-manager -use_cursor no -use_titlebar no &
while true; do
    rm -rf /home/pi/.cache/
    rm -rf /home/pi/.config/
    iceweasel http://yourwebsite.com
    sleep 1
done
CONTENT
# with chmod a+x /home/pi/.xsession the script will be executable.
```

