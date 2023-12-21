## Homebridge

### Update 2023
#### Apps'n'Servers
- mosquitto
- FHEM
- Homebridge
- ps4-waker
- playactor
- ffmpeg
- nut
- haproxy
- miio

```bash
!!------------------------!!
!! GPIO 0+2 of RPi Broken !!
!!------------------------!!

#node update
sudo n 10.15.3

#Need compile/reinstall after node update:
sudo npm install -g --unsafe-perm homebridge homebridge-apple-tv homebridge-config-ui-x
#miio ps4-waker ?

#Need compile after node update (npm-code)
sudo npm rebuild --unsafe-perm
#in folders:
homebridge-433-arduino homebridge-roomba-arduino

---- Good general Info ---

https://www.npmjs.com/package/homebridge-hue

sudo systemctl restart avahi-daemon

---- Typical Commands ----

sudo npm outdated -g --depth=0

sudo npm update -g --unsafe-perm <library names>

---- Other Devices -------

MiLight web user/pass: admin/admin

--------------------------
INSTALLATION:
--------------------------
sudo apt upgrade
sudo apt-get update
sudo apt upgrade

raspi-config

# static IP, edit in /etc/dhcpcd.conf
interface eth0
static ip_address=192.168.2.100/24
static routers=192.168.2.1
static domain_name_servers=192.168.2.1

# WLAN -> put in /boot/wpa_supplicant.conf
/etc/wpa_supplicant/wpa_supplicant.conf
<<CONTENT
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=SE

network={
	ssid="My Home SSID"
	psk="My Passkey In Plain Text"
	key_mgmt=WPA-PSK
}
CONTENT

#power save off?
iw wlan0 get power_save
sudo iw wlan0 set power_save off
/etc/network/interfaces
<<CONTENT
iface wlan0 inet dhcp
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
  post-up iw wlan0 set power_save off
CONTENT

# rpi-update, updates firmware
sudo apt install rpi-update
sudo rpi-update

sudo apt install git make

sudo apt install wiringpi

[[# wiringPi library / executable
git clone git://git.drogon.net/wiringPi
cd wiringPi
./build
sudo gpio
]]

[[# node.js ble (noble)
sudo apt install libudev-dev
#enable access to BLE for node process
sudo apt install libcap2-bin
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
]]

# boot/config.txt
#shutdown button on gpio 3 (actual pin 5, 6 is ground)
dtoverlay=gpio-shutdown
#send powe  r off signal on gpio 26 (e.g. turn off power supply)
dtoverlay=gpio-poweroff

# crontab, shut down wlan on boot and restart server monday 6:05
sudo crontab -e
-> @reboot sudo ifdown wlan0
-> 5 6 * * Mon sudo /etc/init.d/homebridge restart

# -> net command
sudo apt install samba-common-bin 
-> net rpc -S gamepc -U normen%password shutdown -t 1 -f

sudo apt install libavahi-compat-libdnssd-dev

sudo apt install libuv-dev

# install Node.JS
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt install -y nodejs

# so npm is not slow (rpi1)
npm set progress=false
npm config set registry http://registry.npmjs.org/
# npm has issues? use npm@4.6.1 instead of 5.0.3


#for appletv plugin rebuild after
sudo npm install -g --unsafe-perm sodium

sudo npm install --unsafe-perm -g homebridge homebridge-433-arduino homebridge-bravia homebridge-milight homebridge-camera-ffmpeg homebridge-platform-maxcube homebridge-cmdswitch2 homebridge-dummy homebridge-http-switch homebridge-videodoorbell homebridge-config-ui-x homebridge-http-motion-sensor

# for doorbridge
sudo npm install --unsafe-perm -g homebridge homebridge-gpio-device homebridge-config-ui-x


#(insert changed homebridge modules)

#(copy homebridge to etc/init.d)

sudo update-rc.d homebridge defaults

sudo npm install --unsafe-perm -g ps4-waker

sudo ps4-waker (to get PS4 credentials)

sudo homebridge (to get SonyTV credentials)

# logrotate
sudo touch /etc/logrotate.d/homebridge
<<CONTENT (once for each log)
/var/log/homebridge.log {
    rotate 5
    weekly
    compress
    missingok
    notifempty
}
CONTENT


# for omx to work
GPU mem >= 64, best 256 for decoding and encoding
sudo usermod -aG video pi //user access to video

# Compile ffmpeg/cam stuffs -> takes 5+ hours on Pi1!! See deb below.
# install build tools
sudo apt install pkg-config autoconf automake libtool libx264-dev

# download and build fdk-aac
git clone https://github.com/mstorsjo/fdk-aac.git
cd fdk-aac
./autogen.sh
./configure --prefix=/usr/local --enable-shared --enable-static
make -j4
sudo make install
sudo ldconfig
cd ..

# download and build ffmpeg
git clone https://github.com/FFmpeg/FFmpeg.git
cd FFmpeg
./configure --prefix=/usr/local --arch=armel --target-os=linux --enable-omx-rpi --enable-nonfree --enable-gpl --enable-libfdk-aac --enable-mmal --enable-libx264 --enable-decoder=h264 --enable-network --enable-protocol=tcp --enable-demuxer=rtsp
make -j4
sudo make install


# add homebridge user (optional)
sudo adduser homebridge
sudo usermod -L homebridge #no login
sudo usermod -a -G tty homebridge #USB access
sudo usermod -a -G dialout homebridge #USB access
sudo usermod -aG video homebridge #add GPU access
sudo chsh homebridge -s /usr/sbin/nologin #no shell
sudo passwd -d -l homebridge #remove password



# busybox style readonly server
https://kofler.info/raspbian-lite-fuer-den-read-only-betrieb/
https://hallard.me/raspberry-pi-read-only/

# NUT (UPS)
sudo apt-get install nut nut-client nut-server usbutils
vim /etc/nut/ups.conf
<< CONTENT
[eaton]
     driver = usbhid-ups
     port = auto
     productid = ffff
     desc = "Eaton Ellipse Pro 650"
CONTENT
vim /etc/nut/nut.conf
MODE=netserver
vim /etc/not/upsd.conf
LISTEN 127.0.0.1
sudo systemctl disable nut-client

#--------------------------
#RANDOM HOMEBRIDGE INFO
#--------------------------

#WATCHDOG

sudo apt install watchdog
sudo modprobe bcm2835_wdt
sudo vim /etc/watchdog.conf
<<CONTENT
watchdog-device = /dev/watchdog
max-load-1 = 24
CONTENT

sudo vim /lib/systemd/system/watchdog.service
<<CONTENT
[Install]
WantedBy=multi-user.target
CONTENT
sudo systemctl enable watchdog
sudo systemctl start watchdog.service

# watchdog ping doesn't work 2018, see DIY below

sudo vim /usr/local/bin/network_status.sh
<<CONTENT
#!/bin/bash

gateway="192.168.2.1"
interface="wlan0"

ping -c4 $gateway > /dev/null
if [ $? != 0 ] 
then
#  ifdown $interface
#  sleep 3
#  ifup --force $interface
  reboot now
fi
CONTENT

sudo chmod +x /usr/local/bin/network_status.sh

sudo vim /etc/systemd/system/network_status.service
<<CONTENT
[Unit]
Description=Check Network Status

[Service]
Type=simple
ExecStart=/usr/local/bin/network_status.sh
CONTENT

sudo vim /etc/systemd/system/network_status.timer
<<CONTENT
[Unit]
Description=Runs Check Network Status every 2 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=2min
Unit= network_status.service

[Install]
WantedBy=multi-user.target
CONTENT

sudo systemctl enable network_status.timer
sudo systemctl start network_status.timer

# noble
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)






#DEBUG kworker:
sudo apt install linux-tools
sudo apt install linux-tools-4.4

# Get stack traces for 10s.
sudo perf record -e cpu-clock -g -a sleep 10

# Analyze.
sudo perf report

```
#### random info
```
{
            "accessory": "HttpAdvancedAccessory",
            "service": "Switch",
            "name": "Roomba780",
            "forceRefreshDelay": 60,
            "debug": false,
            "optionCharacteristic": [],
            "urls": {
                "getOn": {
                    "url": "http://roomba780/active",
                    "mappers": [
                        {
                            "type": "jpath",
                            "parameters": {
                                "jpath": "$.active"
                            }
                        }
                    ]
                },
                "setOn": {
                    "url": "http://roomba780/command?command=${value==1?\"clean\":\"home\"}"
                }
            }
        },
        {
            "accessory": "HttpAdvancedAccessory",
            "service": "BatteryService",
            "name": "Roomba780Battery",
            "forceRefreshDelay": 60,
            "debug": false,
            "optionCharacteristic": [],
            "urls": {
                "getBatteryLevel": {
                    "url": "http://roomba780/batteryLevel",
                    "mappers": [
                        {
                            "type": "jpath",
                            "parameters": {
                                "jpath": "$.batteryLevel"
                            }
                        }
                    ]
                },
                "getChargingState": {
                    "url": "http://roomba780/chargingState",
                    "mappers": [
                        {
                            "type": "jpath",
                            "parameters": {
                                "jpath": "$.chargingState"
                            }
                        }
                    ]
                },
                "getStatusLowBattery": {
                    "url": "http://roomba780/lowBattery",
                    "mappers": [
                        {
                            "type": "jpath",
                            "parameters": {
                                "jpath": "$.lowBattery"
                            }
                        }
                    ]
                }
            }
        },

-> bcm2835 (GPIO)

RF Codes:

Doorbell:
3459 / 320

315 ON/OFF
1 - 21811 / 21820
2 - 21955 / 21964
3 - 22275 / 22284
4 - 23811 / 23820
5 - 29955 / 29964


310 ON/OFF
1 - 4478259 / 4478268
2 - 4478403 / 4478412
3 - 4478723 / 4478732
4 - 4480259 / 4480268
5 - 4486403 / 4486412

315 Plugs change to:
{4461875, 4461884}, /* Outlet 1 */ -> Changed
{4462019, 4462028}, /* Outlet 2 */ -> Changed
{4462339, 4462348}, /* Outlet 3 */
{4463875, 4463884}, /* Outlet 4 */ -> Changed
{4470019, 4470028}, /* Outlet 5 */ -> Changed

To Program: 
^—- @188

YWT-8500
1052693 / 1052692 @ 353-356
1376277 / 1376276 

# BLACK OUTDOOR
ALL @ 101
#A
ON:  9168560 8678960 8410176 8503408
OFF: 9205008 9427088 8960416 8520224
#B
ON:  8678964 9168564 8503412 8410180
OFF: 9427092 9205012 8520228 8960420
#C
ON:  8678972 9168572 8410188 8678972
OFF: 9205020 8520236 8960428 9427100
#D
ON:  8519680 9205010 9427090 8912896
OFF: 8503410 9168562 8678962 8410178


sudo vcdbg log msg


Looking at cli.js this part seems to capture these signals:

var signals = { 'SIGINT': 2, 'SIGTERM': 15 };
  Object.keys(signals).forEach(function (signal) {
    process.on(signal, function () {
      log.info("Got %s, shutting down Homebridge...", signal);

      // Save cached accessories to persist storage.
      server._updateCachedAccessories();

      process.exit(128 + signals[signal]);
    });
  });
Indeed, after commenting this section, homebridge will shutdown correctly. However, this is not a structural solution.


"accessories": [
    {
      "accessory": "SonyTV",
      "name": "Living Room TV",
      "mac": "48-E2-44-23-13-D1",
      "ip": "192.168.2.103",
      "compatibilityMode": "false"
    } 
]

The sources can be retrived from the TV with get_source('extInput:hdmi').
hi gerard33 on my tv the inputs are coded as follow
Playing: HDMI 1 TV model: KDL-42W805A Volume: 19 Source list: [{'title': 'HDMI 1', 'index': 0, 'uri': 'extInput:hdmi?port=1'}, {'title': 'HDMI 2/MHL', 'index': 1, 'uri': 'extInput:hdmi?port=2'}, {'title': 'HDMI 3', 'index': 2, 'uri': 'extInput:hdmi?port=3'}, {'title': 'HDMI 4', 'index': 3, 'uri': 'extInput:hdmi?port=4'}]


/usr/local/lib/node_modules/homebridge-sonytvremote/


curl -v -XPOST http://192.168.2.103/sony/system -d '{"method":"getMethodTypes","params":[""],"id":1,"version":"1.0"}'

http://192.168.2.103/sony/appControl

{"results":[["getApplicationList",[],["{\"title\":\"string\", \"uri\":\"string\", \"icon\":\"string\", \"data\":\"string\"}*"],"1.0"],["getApplicationStatusList",[],["{\"name\":\"string\", \"status\":\"string\"}*"],"1.0"],["getWebAppStatus",[],["{\"active\":\"bool\", \"url\":\"string\"}"],"1.0"],["setActiveApp",["{\"uri\":\"string\", \"data\":\"string\"}"],[],"1.0"],["setTextForm",["string"],["int"],"1.0"],["terminateApps",[],[],"1.0"],["getMethodTypes",["string"],["string","string*","string*","string"],"1.0"],["getVersions",[],["string*"],"1.0"]],"id":1}

http://192.168.2.103/sony/audio

{"results":[["getSpeakerSettings",["{\"target\":\"string\"}"],["{\"target\":\"string\", \"currentValue\":\"string\", \"deviceUIInfo\":\"string\", \"title\":\"string\", \"titleTextID\":\"string\", \"type\":\"string\", \"isAvailable\":\"bool\", \"candidate\":\"SpeakerSettingsCandidate[]\"}*"],"1.0"],["getVolumeInformation",[],["{\"target\":\"string\", \"volume\":\"int\", \"mute\":\"bool\", \"maxVolume\":\"int\", \"minVolume\":\"int\"}*"],"1.0"],["setAudioMute",["{\"status\":\"bool\"}"],["int"],"1.0"],["setAudioVolume",["{\"target\":\"string\", \"volume\":\"string\"}"],["int"],"1.0"],["setSpeakerSettings",["{\"settings\":\"SpeakerSettings[]\"}"],[],"1.0"],["getMethodTypes",["string"],["string","string*","string*","string"],"1.0"],["getVersions",[],["string*"],"1.0"]],"id":1}

http://192.168.2.103/sony/avContent

{"results":[["deleteContent",["{\"uri\":\"string\"}"],[],"1.0"],["getContentCount",["{\"source\":\"string\", \"type\":\"string\"}"],["{\"count\":\"int\"}"],"1.0"],["getContentList",["{\"source\":\"string\", \"stIdx\":\"int\", \"cnt\":\"int\", \"type\":\"string\"}"],["{\"uri\":\"string\", \"title\":\"string\", \"index\":\"int\", \"dispNum\":\"string\", \"originalDispNum\":\"string\", \"tripletStr\":\"string\", \"programNum\":\"int\", \"programMediaType\":\"string\", \"directRemoteNum\":\"int\", \"startDateTime\":\"string\", \"durationSec\":\"int\", \"channelName\":\"string\", \"fileSizeByte\":\"int\", \"isProtected\":\"bool\", \"isAlreadyPlayed\":\"bool\"}*"],"1.0"],["getCurrentExternalInputsStatus",[],["{\"uri\":\"string\", \"title\":\"string\", \"connection\":\"bool\", \"label\":\"string\", \"icon\":\"string\"}*"],"1.0"],["getParentalRatingSettings",[],["{\"ratingTypeAge\":\"int\", \"ratingTypeSony\":\"string\", \"ratingCountry\":\"string\", \"ratingCustomTypeTV\":\"string*\", \"ratingCustomTypeMpaa\":\"string\", \"ratingCustomTypeCaEnglish\":\"string\", \"ratingCustomTypeCaFrench\":\"string\", \"unratedLock\":\"bool\"}"],"1.0"],["getPlayingContentInfo",[],["{\"uri\":\"string\", \"source\":\"string\", \"title\":\"string\", \"dispNum\":\"string\", \"originalDispNum\":\"string\", \"tripletStr\":\"string\", \"programNum\":\"int\", \"programTitle\":\"string\", \"startDateTime\":\"string\", \"durationSec\":\"int\", \"mediaType\":\"string\", \"playSpeed\":\"string\", \"bivl_serviceId\":\"string\", \"bivl_assetId\":\"string\", \"bivl_provider\":\"string\"}"],"1.0"],["getSchemeList",[],["{\"scheme\":\"string\"}*"],"1.0"],["getSourceList",["{\"scheme\":\"string\"}"],["{\"source\":\"string\"}*"],"1.0"],["setDeleteProtection",["{\"uri\":\"string\", \"isProtected\":\"bool\"}"],[],"1.0"],["setFavoriteContentList",["{\"favSource\":\"string\", \"contents\":\"string*\"}"],[],"1.0"],["setPlayContent",["{\"uri\":\"string\"}"],[],"1.0"],["setPlayTvContent",["{\"channel\":\"string\"}"],[],"1.0"],["setTvContentVisibility",["{\"uri\":\"string\", \"epgVisibility\":\"string\", \"channelSurfingVisibility\":\"string\", \"visibility\":\"string\"}*"],[],"1.0"],["getMethodTypes",["string"],["string","string*","string*","string"],"1.0"],["getVersions",[],["string*"],"1.0"]],"id":1}

http://192.168.2.103/sony/system

{"results":[["getCurrentTime",[],["string"],"1.0"],["getDeviceMode",["{\"value\":\"string\"}"],["{\"isOn\":\"bool\"}"],"1.0"],["getInterfaceInformation",[],["{\"productCategory\":\"string\", \"productName\":\"string\", \"modelName\":\"string\", \"serverName\":\"string\", \"interfaceVersion\":\"string\"}"],"1.0"],["getLEDIndicatorStatus",[],["{\"mode\":\"string\", \"status\":\"string\"}"],"1.0"],["getNetworkSettings",["{\"netif\":\"string\"}"],["{\"netif\":\"string\", \"hwAddr\":\"string\", \"ipAddrV4\":\"string\", \"ipAddrV6\":\"string\", \"netmask\":\"string\", \"gateway\":\"string\", \"dns\":\"string*\"}*"],"1.0"],["getPowerSavingMode",[],["{\"mode\":\"string\"}"],"1.0"],["getPowerStatus",[],["{\"status\":\"string\"}"],"1.0"],["getRemoteControllerInfo",[],["{\"bundled\":\"bool\", \"type\":\"string\"}","{\"name\":\"string\", \"value\":\"string\"}*"],"1.0"],["getRemoteDeviceSettings",["{\"target\":\"string\"}"],["{\"target\":\"string\", \"currentValue\":\"string\", \"deviceUIInfo\":\"string\", \"title\":\"string\", \"titleTextID\":\"string\", \"type\":\"string\", \"isAvailable\":\"bool\", \"candidate\":\"RemoteDeviceSettingsCandidate[]\"}*"],"1.0"],["getSystemInformation",[],["{\"product\":\"string\", \"region\":\"string\", \"language\":\"string\", \"model\":\"string\", \"serial\":\"string\", \"macAddr\":\"string\", \"name\":\"string\", \"generation\":\"string\", \"area\":\"string\", \"cid\":\"string\"}"],"1.0"],["getSystemSupportedFunction",[],["{\"option\":\"string\", \"value\":\"string\"}*"],"1.0"],["getWolMode",[],["{\"enabled\":\"bool\"}"],"1.0"],["requestReboot",[],[],"1.0"],["setDeviceMode",["{\"value\":\"string\", \"isOn\":\"bool\"}"],[],"1.0"],["setLanguage",["{\"language\":\"string\"}"],[],"1.0"],["setPowerSavingMode",["{\"mode\":\"string\"}"],[],"1.0"],["setPowerStatus",["{\"status\":\"bool\"}"],[],"1.0"],["setWolMode",["{\"enabled\":\"bool\"}"],[],"1.0"],["getMethodTypes",["string"],["string","string*","string*","string"],"1.0"],["getVersions",[],["string*"],"1.0"]],"id":1}


CASACONTROL:

pilight-send -p raw --code="666 222 222 888 666 222 222 888 666 444 222 888 222 888 222 888 666 222 222 888 666 222 666 444 222 888 222 888 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 444 222 888 666 222 222 888 666 444 222 888 666 444 666 444 222 888 222 888 222 888 666 444 222 888 222 888 222 888 222 7548"

pilight-send -p raw --code="666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 444 222 888 666 222 666 222 222 888 222 888 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 222 888 666 222 222 888 222 888 222 888 222 7548"

[b]Aon[/b]
time:           Wed Jul 29 16:59:09 2015
hardware:       433gpio
pulse:          157
rawlen:         82
pulselen:       222

Raw code:
[666 222 222 888 666 222 222 888 666 444 222 888 222 888 222 888 666 444 222 888 666 444 666 222 222 888 222 888 222 888 222 888 666 444 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 666 444 222 888 222 888 222 888 666 222 222 888 222 888 222 34854 222 7548]
666 222 222 888 666 222 222 888 666 444 222 888 222 888 222 888 666 444 222 888 666 444 666 222 222 888 222 888 222 888 222 888 666 444 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 666 444 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 7548
--[RESULTS]--

[b]Aoff[/b]
time:           Wed Jul 29 17:00:08 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222
Raw code:
666 222 222 888 666 222 222 888 666 444 222 888 222 888 222 888 666 444 222 888 666 222 666 222 222 888 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 222 888 666 444 222 888 222 888 222 888 222 7548

--------------------------------------------------------------------------------------

[b]Bon[/b]
time:           Wed Jul 29 17:01:49 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222

Raw code:
666 222 222 888 666 222 222 888 666 444 222 888 222 888 222 888 666 222 222 888 666 222 666 444 222 888 222 888 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 444 222 888 666 222 222 888 666 444 222 888 666 444 666 444 222 888 222 888 222 888 666 444 222 888 222 888 222 888 222 7548
--[RESULTS]--

[b]Boff[/b]
time:           Wed Jul 29 17:02:30 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222

Raw code:
666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 444 222 888 666 222 666 222 222 888 222 888 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 222 888 666 222 222 888 222 888 222 888 222 7548

--------------------------------------------------------------------------------------


[b]Con[/b]
time:           Wed Jul 29 17:08:54 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222

Raw code:
666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 444 222 888 666 222 666 222 222 888 222 888 222 888 222 888 666 444 666 222 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 444 222 888 666 222 222 888 666 444 0 1110 666 444 666 222 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 7548

[b]Coff[/b]
time:           Wed Jul 29 17:09:20 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222

Raw code:
666 444 222 888 666 222 222 888 666 444 222 888 222 888 222 888 666 222 222 888 666 222 666 444 222 888 222 888 222 888 222 888 666 444 666 444 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 444 222 888 666 444 222 888 666 444 222 888 666 222 222 888 666 444 222 888 222 888 666 222 222 888 222 888 222 888 222 7548

--------------------------------------------------------------------------------------


[b]Don[/b]
time:           Wed Jul 29 17:21:05 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222

Raw code:
666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 222 222 888 666 222 666 222 222 888 222 888 222 888 222 888 222 888 222 888 666 444 222 888 222 888 222 888 222 888 222 888 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 666 444 222 888 222 888 222 888 666 444 222 888 222 888 222 888 222 7548
--[RESULTS]--

[b]Doff[/b]
time:           Wed Jul 29 17:21:26 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222

Raw code:
666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 222 222 888 666 222 666 222 222 888 222 888 222 888 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 888 222 888 222 888 666 444 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 444 222 888 222 888 666 222 222 888 222 888 222 888 222 7548
--[RESULTS]--

--------------------------------------------------------------------------------------


[b]Eon[/b]
time:           Wed Jul 29 17:22:03 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222

Raw code:
666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 222 222 888 666 222 666 222 222 888 222 888 222 888 222 888 666 222 222 888 666 222 222 888 222 888 222 888 222 888 222 888 222 888 666 444 222 888 666 222 222 888 666 222 222 888 666 222 666 222 222 888 222 888 222 888 666 222 222 888 222 888 222 888 222 7548
--[RESULTS]--

[b]Eoff[/b]
time:           Wed Jul 29 17:22:25 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222

Raw code:
666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 222 222 888 666 222 666 222 222 888 222 888 222 888 222 888 666 444 222 888 666 222 222 888 222 888 222 888 222 888 222 888 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 222 888 666 222 222 888 222 888 222 888 222 7548
--[RESULTS]--

--------------------------------------------------------------------------------------

[b]all on[/b]
time:           Wed Jul 29 17:09:49 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222
Raw code:
666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 222 222 888 666 222 666 444 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 666 444 222 888 666 222 222 888 666 444 222 888 666 222 666 222 222 888 222 888 222 888 222 888 666 222 222 888 222 888 222 7548

[b]all off[/b]
time:           Wed Jul 29 17:10:12 2015
hardware:       433gpio
pulse:          4
rawlen:         82
pulselen:       222
Raw code:
666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 222 222 888 666 444 666 222 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 222 888 444 444 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 666 222 222 888 222 888 222 888 666 444 222 888 222 888 222 7548


Footerpulse/Pulse_Divisor= pulselen, e.q.: 7548/34=222
with pulse = 1: 1*222 = 222
With pulse = 2: 2*222 = 444
With pulse = 3: 3*222 = 666
With pulse = 4: 4*222 = 888



,
        {
            "platform": "AppleTV",
            "name": "Apple TV",
            "showPairSwitches": false,
            "hideWelcomeMessage": true,
            "devices": [
                {
                    "id": "Apple TV",
                    "name": "Apple TV",
                    "credentials": "F7F13505-7091-4F68-9662-02DF80BA23CF:44354246444235322d374130442d344444372d383944392d464136413232443035333838:66306266376632382d343164652d343463312d613161622d333638643531643434373335:a618c368961f5c5b5992e4a467a1a189559443133b0132291a9d23998f1fdbbe:3c1a3dfac475d99a5096fc529e5465eac2e381eba12eedd9ba4d209818fd2a51",
                    "credentials_new": "F7F13505-7091-4F68-9662-02DF80BA23CF:44354246444235322d374130442d344444372d383944392d464136413232443035333838:30646536353133302d353937332d343137642d623530392d613130636433306132643830:a618c368961f5c5b5992e4a467a1a189559443133b0132291a9d23998f1fdbbe:843d72de1048716bfd6411653b2b77159d47889c824738789bd50f4527f596a8"
                }
            ],
            "accessories": [
                {
                    "deviceID": "Apple TV",
                    "name": "TV Next",
                    "command": [
                        {
                            "command": "tv",
                            "repeat": 4,
                            "interval": 1,
                            "pause": 1
                        },
                        "select"
                    ]
                },
                {
                    "deviceID": "Apple TV",
                    "name": "Kamin",
                    "command": [
                        {
                            "command": "tv",
                            "repeat": 4,
                            "interval": 1,
                            "pause": 1
                        },
                        {
                            "command": "right",
                            "pause": 1
                        },
                        {
                            "command": "select",
                            "pause": 2
                        },
                        {
                            "command": "select",
                            "pause": 1
                        },
                        {
                            "command": "menu",
                            "pause": 1
                        },
                        "select"
                    ]
                }
            ]
        }
```
