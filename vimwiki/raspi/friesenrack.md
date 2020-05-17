## Friesenrack
```bash
# RASPBIAN stretch
sudo apt update
sudo apt upgrade
sudo apt install build-essential libudev-dev libasound2-dev libbluetooth-dev bluetooth bluez libi2c-dev pigpio

# NODE.js
git clone https://github.com/tj/n
cd n
sudo make install
sudo n 9
#so node can access bluetooth (or run as root)
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
cd /home/pi/midi-ble
npm install

# MIDI-BLE
sudo vim /etc/systemd/system/midi-ble.service
<<CONTENT
[Unit]
Description=Midi-BLE Bridge 
After=syslog.target bluetooth.target network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/node /home/pi/midi-ble/index.js
Restart=always
RestartSec=3
KillMode=process

[Install]
WantedBy=multi-user.target
CONTENT
sudo systemctl daemon-reload
sudo systemctl enable midi-ble
sudo systemctl start midi-ble

# BRIDGE
sudo apt install hostapd bridge-utils
sudo systemctl stop hostapd
sudo vim /etc/dhcpcd.conf
#Add denyinterfaces wlan0 and denyinterfaces eth0 to the end of the file 
sudo brctl addbr br0
sudo brctl addif br0 eth0
sudo vim /etc/network/interfaces
<<CONTENT
#Bridge setup
auto br0
iface br0 inet static
bridge_ports eth0 wlan0
address 192.168.1.1
netmask 255.255.255.0
CONTENT

# ACCESS POINT
sudo vim /etc/hostapd/hostapd.conf
#wifi scan for access point channel:
# channel = acs_survey
#5GHz
# hw_mode=a
<<CONTENT
interface=wlan0
bridge=br0
#driver=nl80211
ssid=Friesenrack
hw_mode=g
channel=6
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=Password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
CONTENT
sudo vim /etc/default/hostapd
#DAEMON_CONF="/etc/hostapd/hostapd.conf"

#if hostapd fails on acs_survey:
sudo systemctl edit hostapd
[Service]
Restart=on-failure
RestartSec=30
# hostapd fails with exit code 0 when ACS is enabled
RestartForceExitStatus=0

# DHCP
sudo apt install dnsmasq 
sudo systemctl stop dnsmasq
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo vim /etc/dnsmasq.conf
<<CONTENT
interface=br0
  dhcp-range=192.168.1.100,192.168.1.199,255.255.255.0,24h
CONTENT

# READONLY
wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/read-only-fs.sh
sudo bash read-only-fs.sh
#needed for hostapd / dnsmasq
sudo vim /etc/fstab
tmpfs /var/lib/misc tmpfs nodev,nosuid 0 0
tmpfs /var/cache/unbound tmpfs nodev,nosuid 0 0

# COMMANDS
#disable bridge (commands ap-mode / lan-mode)
sudo vim /etc/network/interfaces
#comment address/netmask , make manual
sudo systemctl disable dnsmasq

#rw mode (commands rw / ro)
sudo mount -o remount,rw /
sudo mount -o remount,rw /boot/
sudo mount -o remount,ro /
sudo mount -o remount,ro /boot/

# MIDI
```
