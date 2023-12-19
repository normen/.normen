## Pi cam

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
      "cameras": [
        {
          "name": "Pi-Cam-1",
          "unbridge": false,
          "videoConfig": {
            "videoProcessor": "/usr/local/bin/ffmpeg",
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
