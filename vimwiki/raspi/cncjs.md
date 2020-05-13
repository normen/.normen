## cncjs
```bash
invert spindle enable pin

#raspbian jessie! (PS3 Controller doesn't work on stretch?)
sudo raspi-config
sudo apt-get update
sudo apt-get upgrade

# install Node.js 8
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt install -y nodejs

# install cncjs
sudo npm install --unsafe-perm -g cncjs
cncjs

#vim ~/.cncrc ->
<<CONTENT
  "watchDirectory": "/home/pi/cncdata",
  "accessTokenLifetime": "30d",
  "allowRemoteAccess": true,
  "controller": "Grbl",
  "state": {
    "checkForUpdates": false
  },
CONTENT

#port 80
sudo apt-get install haproxy
#sudo vim /etc/haproxy/haproxy.cfg
<<CONTENT
frontend public
        bind :::80 v4v6
        use_backend webcam if { path_beg /webcam/ }
        default_backend cncjs

backend cncjs
        reqrep ^([^\ :]*)\ /(.*)     \1\ /\2
        option forwardfor
        server cncjs1 127.0.0.1:8000

backend webcam
        reqrep ^([^\ :]*)\ /webcam/(.*)     \1\ /\2
        server webcam1  127.0.0.1:8080
CONTENT

sudo systemctl enable haproxy

#modify /etc/default/haproxy and enable HAProxy by setting ENABLED to 1.
sudo service haproxy start

# systemd service
# sudo vim /etc/systemd/system/cncjs.service
<<CONTENT
[Unit]
Description=cncjs Server 
After=syslog.target network-online.target

[Service]
Type=simple
User=pi
ExecStart=/usr/bin/cncjs
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
CONTENT

sudo systemctl daemon-reload
sudo systemctl enable cncjs
sudo systemctl start cncjs

#joystick:
sudo apt-get install -y bluetooth libbluetooth3 libusb-dev
sudo systemctl enable bluetooth.service
sudo usermod -G bluetooth -a pi
#pair
wget https://github.com/lakkatv/sixpair
gcc -o sixpair sixpair.c -lusb
### Connect DualShock 3 over USB
sudo ./sixpair
bluetoothctl
agent on
power on
discoverable on
### Press the PlayStation button
### Disconnect DualShock 3 from USB
connect 60:38:0E:2F:EC:21 00:19:C1:8A:1F:44
trust 60:38:0E:2F:EC:21 00:19:C1:8A:1F:44

default-agent

quit

#cncjs-pendant-ps3 https://github.com/cncjs/cncjs-pendant-ps3
sudo apt-get install -y libudev-dev libusb-1.0-0 libusb-1.0-0-dev build-essential
sudo npm install -g cncjs-pendant-ps3 --unsafe-perm
cd /usr/lib/node_modules/cncjs-pendant-ps3/
sudo npm install node-hid --driver=hidraw --build-from-source --unsafe-perm

# Run as Root
sudo su

# You will need to create a udev rule to be able to access the hid stream as a non root user.
sudo touch /etc/udev/rules.d/61-dualshock.rules
sudo cat <<EOT >> /etc/udev/rules.d/61-dualshock.rules
KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0268", MODE="0666"
KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
EOT

# Reload the rules, then disconnect/connect the controller.
sudo udevadm control --reload-rules

exit

sudo vim /usr/lib/node_modules/cncjs-pendant-ps3/index.js
-> remove output to controller
-> set distances

# sudo vim /etc/systemd/system/cncjs-pendant-ps3.service
<<CONTENT
[Unit]
Description=cncjs-pendant-ps3 Server 
After=syslog.target network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/cncjs-pendant-ps3 -p "/dev/ttyACM0"
Restart=on-failure
RestartSec=10
KillMode=control-group

[Install]
WantedBy=multi-user.target
CONTENT

sudo systemctl daemon-reload
sudo systemctl enable cncjs-pendant-ps3
sudo systemctl start cncjs-pendant-ps3


#[[
sudo usermod -a -G input pi
sudo usermod -a -G plugdev pi
#]]

#camera
sudo apt-get install build-essential libjpeg62-turbo-dev imagemagick libv4l-dev libav-tools cmake -y

git clone https://github.com/jacksonliam/mjpg-streamer.git
cd mjpg-streamer/mjpg-streamer-experimental
make -j 4
sudo make install

# vim /home/pi/mjpg-streamer.sh
<<CONTENT
#!/bin/bash
# chmod +x mjpg-streamer.sh
# Crontab: @reboot /home/pi/mjpg-streamer/mjpg-streamer.sh start
# Crontab: @reboot /home/pi/mjpg-streamer/mjpg-streamer-experimental/mjpg-streamer.sh start

MJPG_STREAMER_BIN="/usr/local/bin/mjpg_streamer"  # "$(dirname $0)/mjpg_streamer"
MJPG_STREAMER_WWW="/usr/local/share/mjpg-streamer/www"
MJPG_STREAMER_LOG_FILE="/var/log/mjpg-streamer.log"#"${0%.*}.log"  # "$(dirname $0)/mjpg-streamer.log"
RUNNING_CHECK_INTERVAL="2" # how often to check to make sure the server is running (in seconds)
HANGING_CHECK_INTERVAL="3" # how often to check to make sure the server is not hanging (in seconds)

VIDEO_DEV="/dev/video0"
FRAME_RATE="5"
QUALITY="80"
RESOLUTION="1280x720"  # 160x120 176x144 320x240 352x288 424x240 432x240 640x360 640x480 800x448 800x600 960x544 1280x720 1920x1080 (QVGA, VGA, SVGA, WXGA)   #  lsusb -s 001:006 -v | egrep "Width|Height" # https://www.textfixer.com/tools/alphabetical-order.php  # v4l2-ctl --list-formats-ext  # Show Supported Video Formates
PORT="8081"
YUV="yes"

################INPUT_OPTIONS="-r ${RESOLUTION} -d ${VIDEO_DEV} -f ${FRAME_RATE} -q ${QUALITY} -pl 60hz"
INPUT_OPTIONS="-r ${RESOLUTION} -d ${VIDEO_DEV} -q ${QUALITY} -pl 60hz --every_frame 2"  # Limit Framerate with  "--every_frame ", ( mjpg_streamer --input "input_uvc.so --help" )


if [ "${YUV}" == "true" ]; then
	INPUT_OPTIONS+=" -y"
fi

OUTPUT_OPTIONS="-p ${PORT} -w ${MJPG_STREAMER_WWW}"

# ==========================================================
function running() {
    if ps aux | grep ${MJPG_STREAMER_BIN} | grep ${VIDEO_DEV} >/dev/null 2>&1; then
        return 0

    else
        return 1

    fi
}

function start() {
    if running; then
        echo "[$VIDEO_DEV] already started"
        return 1
    fi

    export LD_LIBRARY_PATH="$(dirname $MJPG_STREAMER_BIN):."

	echo "Starting: [$VIDEO_DEV] ${MJPG_STREAMER_BIN} -i \"input_uvc.so ${INPUT_OPTIONS}\" -o \"output_http.so ${OUTPUT_OPTIONS}\""
    ${MJPG_STREAMER_BIN} -i "input_uvc.so ${INPUT_OPTIONS}" -o "output_http.so ${OUTPUT_OPTIONS}" >> ${MJPG_STREAMER_LOG_FILE} 2>&1 &

    sleep 1

    if running; then
        if [ "$1" != "nocheck" ]; then
            check_running & > /dev/null 2>&1 # start the running checking task
            check_hanging & > /dev/null 2>&1 # start the hanging checking task
        fi

        echo "[$VIDEO_DEV] started"
        return 0

    else
        echo "[$VIDEO_DEV] failed to start"
        return 1

    fi
}

function stop() {
    if ! running; then
        echo "[$VIDEO_DEV] not running"
        return 1
    fi

    own_pid=$$

    if [ "$1" != "nocheck" ]; then
        # stop the script running check task
        ps aux | grep $0 | grep start | tr -s ' ' | cut -d ' ' -f 2 | grep -v ${own_pid} | xargs -r kill
        sleep 0.5
    fi

    # stop the server
    ps aux | grep ${MJPG_STREAMER_BIN} | grep ${VIDEO_DEV} | tr -s ' ' | cut -d ' ' -f 2 | grep -v ${own_pid} | xargs -r kill

    echo "[$VIDEO_DEV] stopped"
    return 0
}

function check_running() {
    echo "[$VIDEO_DEV] starting running check task" >> ${MJPG_STREAMER_LOG_FILE}

    while true; do
        sleep ${RUNNING_CHECK_INTERVAL}

        if ! running; then
            echo "[$VIDEO_DEV] server stopped, starting" >> ${MJPG_STREAMER_LOG_FILE}
            start nocheck
        fi
    done
}

function check_hanging() {
    echo "[$VIDEO_DEV] starting hanging check task" >> ${MJPG_STREAMER_LOG_FILE}

    while true; do
        sleep ${HANGING_CHECK_INTERVAL}

        # treat the "error grabbing frames" case
        if tail -n2 ${MJPG_STREAMER_LOG_FILE} | grep -i "error grabbing frames" > /dev/null; then
            echo "[$VIDEO_DEV] server is hanging, killing" >> ${MJPG_STREAMER_LOG_FILE}
            stop nocheck
        fi
    done
}

function help() {
    echo "Usage: $0 [start|stop|restart|status]"
    return 0
}

if [ "$1" == "start" ]; then
    start && exit 0 || exit -1

elif [ "$1" == "stop" ]; then
    stop && exit 0 || exit -1

elif [ "$1" == "restart" ]; then
    stop && sleep 1
    start && exit 0 || exit -1

elif [ "$1" == "status" ]; then
    if running; then
        echo "[$VIDEO_DEV] running"
        exit 0

    else
        echo "[$VIDEO_DEV] stopped"
        exit 1

    fi

else
    help

fi
CONTENT


chmod +x /home/pi/mjpg-streamer.sh
#vim /etc/rc.local
<<CONTENT
sudo modprobe bcm2835-v4l2
sudo /home/pi/mjpg-streamer.sh start
CONTENT

#readonly
wget https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/read-only-fs.sh
sudo bash read-only-fs.sh

#sudo vim /etc/fstab
tmpfs /usr/lib/node_modules/cncjs/dist/cnc/app/sessions tmpfs nodev,nosuid 0 0
tmpfs /home/pi/cncdata tmpfs nodev,nosuid 0 0

#fix time?
sudo apt-get install ntpdate
#sudo vim /etc/rc.local ->
sudo /usr/sbin/ntpdate -b 0.de.pool.ntp.org

#1.9.15:
remove mkdir from /usr/lib/node_modules/cncjs/dist/cnc/app/index.js

#commands (or gpio 21 all the way at the ports)
##
sudo mount -o remount,rw /
##
sudo mount -o remount,ro /
##
sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf << EOF
network={
	ssid="Name"
	psk="Password"
}
EOF
##
sudo mount -o remount,rw /
sudo mount -o remount,rw /boot/
sudo apt-get update
sudo apt-get upgrade
sudo npm install -g --unsafe-perm cncjs
sudo mount -o remount,ro /
sudo mount -o remount,ro /boot/
##
sudo systemctl restart cncjs

```
