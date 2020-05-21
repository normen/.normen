# Raspberry Pi
## Configured Boxes
* [raspi/homebridge](raspi/homebridge.md)
* [raspi/makerpi](raspi/makerpi.md)
* [raspi/friesenrack](raspi/friesenrack.md)
* [raspi/cncjs](raspi/cncjs.md)

## General Raspi Info
```bash
#first boot direct
touch ssh
vim wpa_supplicant.conf
<<CONTENT
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="wifi_ssid"
    psk="wifi_password"
}
CONTENT

# add ssh key
rsync -azv ~/.ssh/authorized_keys pi@raspberrypi:~/.ssh/

# install .normen
bash <(curl -s https://raw.githubusercontent.com/normen/.normen/master/install)

#1024x600 HDMI:
#/boot/config.txt
<<CONTENT
max_usb_current=1
hdmi_drive=1
disable_overscan=1
hdmi_cvt=1024 600 60 6 0 0 0
hdmi_group=2
hdmi_mode=87
CONTENT

#desktop autostart
sudo vim ~/.config/autostart/MeinAutostart.desktop
<<CONTENT
[Desktop Entry]
Name=Autostart-Script
Comment=Kommentar
Type=Application
Exec=Mein-Script.sh
Terminal=false
CONTENT

#disable password login
sudo vim /etc/ssh/sshd_config
ChallengeResponseAuthentication no
PasswordAuthentication no

#image to disk osx:
df -h
#/dev/disk2s1 -> /dev/rdisk2
sudo dd of=/dev/rdisk2 if=./2019-04-08-raspbian-stretch.img bs=1m conv=sync status=progress

#POWER GOOD?
vcgencmd get_throttled

#readonly
sudo raspi-config
#wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/read-only-fs.sh
#sudo bash read-only-fs.sh
#sudo vim /etc/fstab
#tmpfs /usr/lib/node_modules/cncjs/dist/cnc/app/sessions tmpfs nodev,nosuid 0 0
#tmpfs /home/pi/cncdata tmpfs nodev,nosuid 0 0

# COMMANDS
#find version
cat /etc/os-release

#node installation
git clone https://github.com/tj/n
cd n
sudo make install
sudo n 10

#Need compile after node update (in each module folder)
sudo npm rebuild --unsafe-perm

# BACKUP TO NAS
sudo apt install smbclient cifs-utils
sudo mkdir /backup
sudo vim /etc/fstab
<<CONTENT
//hausrouter/backup /backup cifs defaults,noauto,nofail,vers=2.0,credentials=/home/pi/.smblogin,x-systemd.automount,x-systemd.requires=network-online.target    0    0
CONTENT
sudo vim /home/pi/.smblogin
<<CONTENT
username=backup
password=password
workgroup=WORKGROUP
CONTENT
curl -s -L -O https://www.linux-tips-and-tricks.de/raspiBackupInstallUI.sh && sudo bash raspiBackupInstallUI.sh
raspiBackup.sh

#Restore on some connected raspi with SD inserted (USB on /dev/sda)
#find device
lsblk 
sudo raspiBackup.sh -d /dev/sda /backup/homebridge/homebridge-tar-backup-xxx/

# HAPROXY
#-> Port 80
sudo apt install haproxy
#/etc/haproxy/haproxy.cfg
<<CONTENT
frontend public
        bind :::80 v4v6
        use_backend webcam if { path_beg /webcam/ }
        default_backend octoprint

backend octoprint
        reqrep ^([^\ :]*)\ /(.*)     \1\ /\2
        option forwardfor
        server octoprint1 127.0.0.1:5000

backend webcam
        reqrep ^([^\ :]*)\ /webcam/(.*)     \1\ /\2
        server webcam1  127.0.0.1:8080
CONTENT

#modify /etc/default/haproxy and enable HAProxy by setting ENABLED to 1.
sudo service haproxy start

# LATEST KERNEL
sudo rpi-update
#only use rpi-update for kernel
sudo apt-mark hold libraspberrypi0 libraspberrypi-bin raspberrypi-kernel raspberrypi-bootloader
#reinstall stable kernel (unhold above to use apt again)
sudo apt install --reinstall raspberrypi-bootloader raspberrypi-kernel
#alternative
sudo BRANCH=stable rpi-update

# UPGRADE
# /etc/apt/sources.list and /etc/apt/sources.list.d/raspi.list
# change jessie -> stretch

sudo apt update
sudo apt -y dist-upgrade
sudo apt -y purge "pulseaudio*"
sudo apt autoremove

# SYNC FILES
#dest is parent folder!
#to server
rsync -azr --delete /Users/normenhansen/Documents/NodeCode/homebridge/npm-code pi@homebridge.local:/home/pi/
#from server
rsync -azr --delete pi@homebridge.local:/home/pi/npm-code /Users/normenhansen/Documents/NodeCode/homebridge

# Time Machine
# needs Raspbian buster
sudo apt install samba
sudo mkdir -m 1777 /data
sudo smbpasswd -a pi
sudo vim /etc/samba/smb.conf
<<CONTENT
[timemachine]
  comment = Time Machine
  path = /data
  browseable = yes
  writeable = yes
  create mask = 0600
  directory mask = 0700
; spotlight = yes
  vfs objects = catia fruit streams_xattr
  fruit:aapl = yes
  fruit:time machine = yes
CONTENT

```
