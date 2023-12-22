## Maker Pi
```bash
#https://github.com/foosel/OctoPrint/wiki/Controlling-a-relay-board-from-your-RPi

# replaced plugins
- https://github.com/mdziekon/OctoPrint-SpoolManager/zip/refs/heads/master
- https://github.com/9mrcookie9/OctoPrint-TouchUI/zip/refs/heads/master

# upgrade sfter dist-upgrade
cd OctoPrint
python3 -m venv --upgrade venv

# compile camera-streamer:
git clone https://github.com/ayufan-research/camera-streamer.git --recursive
apt-get -y install libavformat-dev libavutil-dev libavcodec-dev libcamera-dev liblivemedia-dev v4l-utils pkg-config xxd build-essential cmake libssl-dev
cd camera-streamer/
make
sudo make install
sudoedit /etc/systemd/system/camera-streamer.service
<<CONTENT
[Unit]
Description=camera-streamer web camera for Pi Camera v2.1 8MP on Raspberry PI
After=network.target

[Service]
ExecStart=/usr/local/bin/camera-streamer \
  --camera-video.disabled \
  --http-listen=0.0.0.0

DynamicUser=yes
SupplementaryGroups=video i2c
Restart=always
RestartSec=10
Nice=10
IOSchedulingClass=idle
IOSchedulingPriority=7
CPUWeight=20
AllowedCPUs=1-2
MemoryMax=250M

[Install]
WantedBy=multi-user.target
CONTENT

# updated buster
cd OctoPrint
virtualenv -p python3 venv
venv/bin/pip3 install OctoPrint
venv/bin/octoprint serve
sudo vim /etc/systemd/system/octoprint.service
<<CONTENT
[Unit]
Description=The snappy web interface for your 3D printer
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=pi
ExecStart=/home/pi/OctoPrint/venv/bin/octoprint

[Install]
WantedBy=multi-user.target
CONTENT
sudo systemctl daemon-reload
sudo systemctl enable octoprint
sudo systemctl start octoprint

#Octoprint
sudo apt install python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential
git clone https://github.com/foosel/OctoPrint.git
cd OctoPrint
virtualenv venv
./venv/bin/pip install pip --upgrade
./venv/bin/python setup.py install
mkdir ~/.octoprint


sudo usermod -a -G tty pi
sudo usermod -a -G dialout pi

#webcam support
sudo apt install subversion libjpeg62-turbo-dev imagemagick ffmpeg libv4l-dev cmake
git clone https://github.com/jacksonliam/mjpg-streamer.git
cd mjpg-streamer/mjpg-streamer-experimental
export LD_LIBRARY_PATH=.
make -j4

#autostart
sudo cp ~/OctoPrint/scripts/octoprint.init /etc/init.d/octoprint
sudo chmod +x /etc/init.d/octoprint
sudo cp ~/OctoPrint/scripts/octoprint.default /etc/default/octoprint
sudo update-rc.d octoprint defaults

#port 80
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

#~/.octoprint/config.yaml make the server bind only to the loopback interface:
<<CONTENT
server:
    host: 127.0.0.1
CONTENT

#Restart the server. OctoPrint should still be available on port 80, including the webcam feed (if enabled).



port 5000: OctoPi
port 8000: cncjs

# list node.js servers (cncjs)
p2m list
```

## Recreate octoprint + venv from backup
```bash
pip3 env -p python3 venv
venv/bin/pip3 install OctoPrint
venv/bin/octoprint plugin backup:restore backupname.zip
```
```


