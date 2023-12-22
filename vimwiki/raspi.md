# Raspberry Pi
## Configured Boxes
* [raspi/homebridge](raspi/homebridge.md)
* [raspi/makerpi](raspi/makerpi.md)
* [raspi/friesenrack](raspi/friesenrack.md)
* [raspi/cncjs](raspi/cncjs.md)
* [raspi/analyzer](raspi/analyzer.md)
* [raspi/ipad](raspi/ipad.md)
* [raspi/webpage](raspi/webpage.md)
* [raspi/timemachine](raspi/timemachine.md)
* [raspi/printserver](raspi/printserver.md)
* [raspi/amiga](raspi/amiga.md)
* [raspi/autostart](raspi/autostart.md)
* [raspi/audiorec](raspi/audiorec.md)
* [raspi/pi-cam](raspi/pi-cam.md)

## Quick Setup Pi (Pi Imager does this)
```bash
python3 -m pip install tflite-runtime
#first boot direct
touch ssh
vim wpa_supplicant.conf
<<CONTENT
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=DE

network={
    ssid="wifi_ssid"
    psk="wifi_password"
}
CONTENT
# add ssh key
scp ~/.ssh/authorized_keys pi@raspberrypi:~/.ssh/
# install .normen
perl <(curl -s https://raw.githubusercontent.com/normen/.normen/master/install.pl)
```

## BACKUP TO NAS
```bash
sudo apt install smbclient cifs-utils
sudo mkdir /backup
sudo vim /etc/fstab
<<CONTENT
//hausrouter/backup /backup cifs defaults,noauto,nofail,vers=2.0,credentials=/home/pi/.smblogin,x-systemd.automount,x-systemd.requires=network-online.target    0    0
//hausrouter/backup /backup cifs defaults,uid=pi,file_mode=0777,dir_mode=0777,noauto,nofail,vers=2.0,credentials=/home/pi/.smblogin,x-systemd.automount,x-systemd.requires=network-online.target    0    0
CONTENT
# add uid=pi,file_mode=0777,dir_mode=0777 for universal access
sudo vim /home/pi/.smblogin
<<CONTENT
username=backup
password=password
workgroup=WORKGROUP
CONTENT
```

## RaspiBackup
```bash
curl -o install -L https://raw.githubusercontent.com/framps/raspiBackup/master/installation/install.sh; sudo bash ./install
#Restore on some connected raspi with SD inserted (USB on /dev/sda)
#find device
lsblk 
sudo raspiBackup -d /dev/sda /backup/homebridge/homebridge-tar-backup-xxx/
```

## USB Over IP / dd-wrt
```bash
# usb-over ip from dd-wrt
# dd-wrt: enable usb-over-ip
usbip list -l
# dd-wrt add startup script:
usbip bind -b 2-2

# raspberry pi
sudo apt install usbip hwdata
# enable driver
sudoedit /etc/modules
<<CONTENT
vhci_hcd
CONTENT

# start "mount" withs service
sudoedit /etc/systemd/system/usbip-client.service
<<CONTENT
[Unit]
Description=usbip client daemon
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/sbin/usbip attach -r studiorouter -b 2-2
ExecStop=/usr/sbin/usbip detach -p 00
RemainAfterExit=yes
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
CONTENT

# make sure its mounted when router reboots:
sudo crontab -e
0 * * * * /usr/sbin/usbip attach -r studiorouter -b 2-2
```

## Random Hardware
```bash
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

#reboot button pin 5/6 (/boot/config.txt)
dtoverlay=gpio-shutdown,gpio_pin=3

# mount disk for pi
sudo fdisk -l
sudo mount /dev/sda2 /mnt/record  -o uid=pi,gid=pi

# turn off USB+ethernet
echo '1-1'|sudo tee /sys/bus/usb/drivers/usb/unbind
# turn on
echo '1-1'|sudo tee /sys/bus/usb/drivers/usb/bind
# Turn OFF HDMI output
sudo /opt/vc/bin/tvservice -o
# Turn ON HDMI output
sudo /opt/vc/bin/tvservice -p
# turn off wifi/bt (/boot/config.txt)
dtoverlay=pi3-disable-wifi
dtoverlay=pi3-disable-bt
#turn off leds
dtparam=act_led_trigger=none
dtparam=act_led_activelow=on

# rpiplay
https://github.com/FD-/RPiPlay/issues/296#issuecomment-981210609

#bluetooth keyboard
sudo bluetoothctla
agent on
default-agent
scan on
scan off
trust 50:E6:66:2E:59:EB
connect 50:E6:66:2E:59:EB
```

## Desktop install
```bash
#install desktop
sudo apt install raspberrypi-ui-mods
#for startx
sudo apt install --no-install-recommends xinit

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
```

## Random
```bash
#image to disk osx:
df -h
#/dev/disk2s1 -> /dev/rdisk2
sudo dd of=/dev/rdisk2 if=./2019-04-08-raspbian-stretch.img bs=1m conv=sync status=progress

#POWER GOOD?
vcgencmd get_throttled

#readonly
sudo raspi-config

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
        http-request replace-path /(.*)   /\1
        option forwardfor
        server octoprint1 127.0.0.1:5000

backend webcam
        http-request replace-path /webcam/(.*)   /\1
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

```
