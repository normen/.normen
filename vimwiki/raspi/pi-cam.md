## Pi cam

```bash
sudo apt update
sudo apt upgrade -y
# enable camera
sudo raspi-config
# crontab for video bitrate
crontab -e
@reboot v4l2-ctl --set-ctrl video_bitrate=300000

curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | sudo bash -s lts
npm install homebridge homebridge-camera-ffmpeg ffmpeg-for-homebridge
vim ~/.homebridge/config.json
```

```bash
# alsa mixer
alsamixer -c 1
# save mixer settings
sudo alsactl store 1

## Homebridge

`/etc/systemd/system/homebridge.service`

```
[Unit]
Description=Node.js HomeKit Server 
After=syslog.target network-online.target

[Service]
Type=simple
User=pi
# Adapt this to your specific setup (could be /usr/bin/homebridge)
# See comments below for more information
ExecStart=/usr/local/bin/homebridge
Restart=on-failure
RestartSec=10
KillMode=control-group

[Install]
WantedBy=multi-user.target
```

`~/.homebridge/config.json`

```
{
  "bridge": {
    "name": "Pi-Cam-1_Bridge",
    "username": "DE:24:3D:B0:CD:2B",
    "port": 51826,
    "pin": "123-50-440"
  },
  "platforms": [
    {
      "name": "Camera ffmpeg",
      "videoProcessor": "/usr/local/lib/node_modules/ffmpeg-for-homebridge/ffmpeg",
      "cameras": [
        {
          "name": "Pi-Cam-1",
          "unbridge": false,
          "videoConfig": {
            "sourceX": "-f video4linux2 -input_format h264 -video_size 1280x720 -framerate 30 -i /dev/video0",
            "source": "-f video4linux2 -input_format h264 -video_size 1280x720 -framerate 30 -i /dev/video0 -f alsa -channels 1 -i plughw:1",
            "stillImageSource": "-f video4linux2 -input_format mjpeg -video_size 1280x720 -i /dev/video0 -vframes 1 -r 1 -f mjpeg",
            "returnAudioTarget": "-f alsa plughw:1",
            "audio": true,
            "vcodec": "copy",
            "maxStreams": 1,
            "maxWidth": 1280,
            "maxHeight": 720,
            "maxFPS": 30,
            "debugReturn": false,
            "debug": false
          }
        }
      ],
      "platform": "Camera-ffmpeg"
    }
  ]
}
```

## Start script with/without audio
```bash
#!/usr/bin/env bash
# use jq to change the homebridge-ffmepg-camera settings
# based on the availability of an audio interface
# then start homebridge
set -e

# check if card 1 is available using arecord -l
audio_in=$(arecord -l | grep "card 1" | awk '{print $2}' | sed 's/://g' | head -1)
if [ "$audio_in" == "1" ]; then
  # card 1 input is available
  if [ "$(jq '.platforms[].cameras[].videoConfig.audio' /home/pi/.homebridge/config.json)" != "true" ]; then
    jq '.platforms[].cameras[].videoConfig.audio = true' /home/pi/.homebridge/config.json > /home/pi/.homebridge/config.json.tmp
    mv /home/pi/.homebridge/config.json.tmp /home/pi/.homebridge/config.json
    jq '.platforms[].cameras[].videoConfig.source = "-f video4linux2 -input_format h264 -video_size 1280x720 -framerate 30 -i /dev/video0 -f alsa -channels 1 -i plughw:1"' /home/pi/.homebridge/config.json > /home/pi/.homebridge/config.json.tmp
    mv /home/pi/.homebridge/config.json.tmp /home/pi/.homebridge/config.json
  fi
else
  # card 1 input is not available
  if [ "$(jq '.platforms[].cameras[].videoConfig.audio' /home/pi/.homebridge/config.json)" != "false" ]; then
    jq '.platforms[].cameras[].videoConfig.audio = false' /home/pi/.homebridge/config.json > /home/pi/.homebridge/config.json.tmp
    mv /home/pi/.homebridge/config.json.tmp /home/pi/.homebridge/config.json
    jq '.platforms[].cameras[].videoConfig.source = "-f video4linux2 -input_format h264 -video_size 1280x720 -framerate 30 -i /dev/video0"' /home/pi/.homebridge/config.json > /home/pi/.homebridge/config.json.tmp
    mv /home/pi/.homebridge/config.json.tmp /home/pi/.homebridge/config.json
  fi
fi
audio_out=$(aplay -l | grep "card 1" | awk '{print $2}' | sed 's/://g' | head -1)
if [ "$audio_out" == "1" ]; then
  # card 1 output is available
  jq '.platforms[].cameras[].videoConfig.returnAudioTarget = "-f alsa plughw:1"' /home/pi/.homebridge/config.json > /home/pi/.homebridge/config.json.tmp
  mv /home/pi/.homebridge/config.json.tmp /home/pi/.homebridge/config.json
else
  # card 1 output is not available
  jq 'del(.platforms[].cameras[].videoConfig.returnAudioTarget)' /home/pi/.homebridge/config.json > /home/pi/.homebridge/config.json.tmp
  mv /home/pi/.homebridge/config.json.tmp /home/pi/.homebridge/config.json
fi

/usr/local/bin/homebridge
```
## Build ffmpeg for arm6:
```bash
#!/usr/bin/env bash
# install build tools
sudo apt-get install pkg-config autoconf automake libtool libx264-dev libasound2-dev

# download and build fdk-aac
git clone https://github.com/mstorsjo/fdk-aac.git || echo "Already downloaded fdk-aac"
cd fdk-aac
./autogen.sh
./configure --prefix=/usr/local --enable-shared --enable-static
make
sudo make install
sudo ldconfig
cd ..

# download and build ffmpeg
git clone https://github.com/FFmpeg/FFmpeg.git || echo "Already downloaded ffmpeg"
cd FFmpeg
#./configure --prefix=/usr/local --arch=armel --target-os=linux --enable-omx-rpi --enable-nonfree --enable-gpl --enable-libfdk-aac --enable-mmal --enable-libx264 --enable-decoder=h264 --enable-network --enable-protocol=tcp --enable-demuxer=rtsp
./configure --prefix=/usr/local --enable-nonfree --enable-gpl --enable-libfdk-aac --enable-mmal --enable-libx264 --enable-decoder=h264 --enable-network --enable-protocol=tcp --enable-demuxer=rtsp
make
sudo make install
```
