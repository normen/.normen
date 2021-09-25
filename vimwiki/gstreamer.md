## gstreamer
```bash
# compile
gcc -Wall main.c -o main $(pkg-config --cflags --libs gstreamer-1.0 gstreamer-plugins-base-1.0 gstreamer-net-1.0 gstreamer-rtsp-1.0 gstreamer-rtp-1.0)

# windows
# install mingw-version + devel
# compile c file:
cl main.c /I "c:\gstreamer\1.0\mingw_x86_64\include\gstreamer-1.0" /I "c:\gstreamer\1.0\mingw_x86_64\include\glib-2.0" /I "C:\gstreamer\1.0\mingw_x86_64\lib\glib-2.0\include" "C:\gstreamer\1.0\mingw_x86_64\lib\*.lib"

# compile gst-ndi
# install rust
# add lib/pkgconfig to PKG_CONFIG_PATH
# add ndi dlls to path
cargo build --release
```
