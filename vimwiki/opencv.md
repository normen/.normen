## opencv
```
https://blog.mixable.de/opencv-python-eigene-haar-cascade-erstellen/

# convert mjpeg to single jpg
ffmpeg -i 28493_video.mjpeg -vcodec copy jpg/frame%d+1.jpg

# annotate
opencv_annotation -i=p -a=p.txt

# create vector
opencv_createsamples -info p.txt -bg n.txt -vec vector.vec

# train
opencv_traincascade -data cascade -vec vector.vec -bg n.txt -numPos 936 -numNeg 1926 -numStages 20 -mem 1000 -maxHitRate 0.95 -w 24 -h 24

less numpos!
```
