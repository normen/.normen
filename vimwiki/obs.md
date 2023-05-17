## OBS
#### NDI Ethernet
- Disable power save
- Enable Jumbo Frame
- Enable rx/tx flow control
- Set fixed speed 1G
- Set full duplex
#### gstreamer
```bash
cd /D "%~dp0"
cd gstreamer
SET GSTREAMER_1_0_ROOT_MINGW_X86_64=%cd%
cd bin
SET PATH=%cd%
SET GST_PLUGIN_PATH=%cd%

# to see created routes:
SET GST_DEBUG_DUMP_DOT_DIR=%cd%

# example source to video
uridecodebin uri=rtsp://blah ! fakevideosink
# use data to create something like
rtspsrc location=rtsp://blah latency=1000 ! rtph265depay ! nvh265dec ! gldownload ! fakesink

# convert to mp4 for FCP
ffmpeg -i transport.ts -acodec copy -vcodec copy video.mp4
```
