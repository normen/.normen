## H264 Encoder
### Settings
#### Quality
- vbr 
- minqp = 1
- maxqp defines bitrate
  - 40 = 10MBit
  - 10 = 45MBit

### FFMPEG Recorder (http)
#### Commands
```bash
ffmpeg -probesize 10000k -analyzeduration 10000k -i http://192.168.2.19:8000/main2 -vcodec copy main2.mp4
```
