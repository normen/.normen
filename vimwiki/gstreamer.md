## gstreamer
```bash
# debug DOT file of connections
GST_DEBUG_DUMP_DOT_DIR="xxx" gst-launch-1.0 ...
# use graphviz to convert dump to svg
dot -Tsvg xxx.dot > xxx.svg
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
# Windows:
# Add NDI runtime to PATH
# Set GST_PLUGIN_PATH and put plugin there
# copy Processing.NDI.Lib.x64.lib from NDI SDK to project folder
# MacOS:
# Add to build.rs main():
#    println!("cargo:rustc-link-lib=dylib=ndi");
#    println!("cargo:rustc-link-search=native=/Library/NDI SDK for Apple/lib/macOS");
cargo build --release

# Windows:
# add gstreamer/bin to PATH!

# obs-gstreamer on mac:
# add paths to meson.build:
# -obs_dep = dependency('libobs', required : false)
# +#obs_dep = dependency('libobs', required : false)
# +obs_dep = declare_dependency(
# +  link_args : ['-L' + '/Users/normenhansen/Dev/gstreamer/obs-studio/build/libobs/', '-l' + 'obs'],
# +  include_directories : include_directories('/Users/normenhansen/Dev/gstreamer/obs-studio/')
# +  )

# gst-list
alias gst-list="gst-inspect-1.0 |fzf|awk '{print substr(\$2, 1, length(\$2)-1)}' | xargs gst-inspect-1.0"

# macos install / remove (do once for dependencies)
brew install gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
brew remove gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav libnice

# compile on macos
# needed for rust plugins (-Drs=enabled)
brew install cargo-c
meson --buildtype=release -Dgpl=enabled -Dintrospection=disabled -Dorc=enabled -Dtests=disabled -Dexamples=disabled -Dgst-examples=disabled -Dgst-plugins-bad:openexr=disabled -Dgst-plugins-bad:rsvg=disabled -Dgst-plugins-bad:fluidsynth=disabled build
ninja -C build
sudo ninja install -C build
# uninstall
sudo ninja uninstall -C build
```
