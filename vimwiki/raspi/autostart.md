## autostart pi
```bash
# change /boot/cmdline.txt init=
init=/bin/bash -c "mount -t proc proc /proc; mount -t sysfs sys /sys; mount /boot; source /boot/autorun"
# change /boot/autorun
<<CONTENT
#!/bin/sh
# mounting
mount -t tmpfs tmp /run
mkdir -p /run/systemd
mount / -o remount,rw

# change .bashrc
echo "if [ -f '/boot/autorun.sh' ]; then" >> /home/pi/.bashrc
echo "  cp /boot/autorun.sh ~/" >> /home/pi/.bashrc
echo "  sudo rm /boot/autorun.sh ~/" >> /home/pi/.bashrc
echo "  chmod a+x ~/autorun.sh" >> /home/pi/.bashrc
echo "fi" >> /home/pi/.bashrc
echo "if [ -f '/home/pi/autorun.sh' ]; then" >> /home/pi/.bashrc
echo "  ~/autorun.sh" >> /home/pi/.bashrc
echo "fi" >> /home/pi/.bashrc
 
# set init_resize script and reboot
sed -i 's| init=.*| init=/usr/lib/raspi-config/init_resize\.sh|' /boot/cmdline.txt
sync
umount /boot
mount / -o remount,ro
sync
echo 1 > /proc/sys/kernel/sysrq
echo b > /proc/sysrq-trigger
sleep 5
CONTENT
# add /boot/autorun.sh to run on bash login
<<CONTENT
#!/bin/bash
# set wifi country to assure wifi connection..
sudo raspi-config nonint do_wifi_country DE
sudo systemctl restart wpa_supplicant
bash <(curl -s https://raw.githubusercontent.com/normen/.normen/master/install)
# remove script when successful!
rm ~/autorun.sh
CONTENT
```
