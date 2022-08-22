## Audio Rec Raspi
```bash
# realtime raspios
git clone https://github.com/remusmp/rpi-rt-kernel
cd rpi-rt-kernel
# start colima (macos)
colima start
docker context use colima
export DOCKER_HOST=unix:///Users/normenhansen/.colima/docker.sock
# make raspi image with RT kernel
make

# install base apps
sudo apt install git build-essential udev-dev i2c-tools

# install x32recorder
sudo apt install udev-dev i2c-tools arecord ffmpeg
wget https://project-downloads.drogon.net/wiringpi-latest.deb
sudo dpkg -i wiringpi-latest.deb
git clone https://git.bitwaves.de/normen/av-scripts
git clone https://git.bitwaves.de/normen/x32recorder
cd x32recorder/lib
git clone https://github.com/hallard/ArduiPi_OLED
cd ..
make


```
