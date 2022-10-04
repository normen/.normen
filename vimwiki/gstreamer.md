## gstreamer
```bash
# install on raspi
# install a missing dependency
sudo apt-get install libx264-dev libjpeg-dev
# install the remaining plugins
sudo apt-get install libgstreamer1.0-dev \
     libgstreamer-plugins-base1.0-dev \
     libgstreamer-plugins-bad1.0-dev \
     gstreamer1.0-plugins-ugly \
     gstreamer1.0-tools \
     gstreamer1.0-gl \
     gstreamer1.0-gtk3 
# if you have Qt5 install this plugin
sudo apt-get install gstreamer1.0-qt5
# install if you want to work with audio
sudo apt-get install gstreamer1.0-pulseaudio

# compile
gcc -Wall main.c -o main $(pkg-config --cflags --libs gstreamer-1.0 gstreamer-plugins-base-1.0 gstreamer-net-1.0 gstreamer-rtsp-1.0 gstreamer-rtp-1.0)

# windows
# install mingw-version + devel
# compile c file:
cl main.c /I "c:\gstreamer\1.0\mingw_x86_64\include\gstreamer-1.0" /I "c:\gstreamer\1.0\mingw_x86_64\include\glib-2.0" /I "C:\gstreamer\1.0\mingw_x86_64\lib\glib-2.0\include" "C:\gstreamer\1.0\mingw_x86_64\lib\*.lib"

# compile gst-ndi
# install rust
# on Pi:
curl https://sh.rustup.rs -sSf | sh
# add lib/pkgconfig to PKG_CONFIG_PATH
# install NDI SDK
# add ndi dlls to path
# add ndi lib to build folder (or PKG_CONFIG_PATH?)
cargo build --release
```
