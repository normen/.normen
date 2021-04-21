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
ffmpeg -i http://192.168.2.19:8000/main2 -analyzeduration 100 -vcodec copy main2.mp4
```
