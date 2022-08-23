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

#### 32bit kernel
```diff
diff --git a/Dockerfile b/Dockerfile
index a1461d7..d4b233f 100644
--- a/Dockerfile
+++ b/Dockerfile
@@ -8,7 +8,7 @@ RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
 
 RUN apt-get update
 RUN apt-get install -y git make gcc bison flex libssl-dev bc ncurses-dev kmod
-RUN apt-get install -y crossbuild-essential-arm64
+RUN apt-get install -y crossbuild-essential-armhf
 RUN apt-get install -y wget zip unzip fdisk nano curl xz-utils
 
 WORKDIR /rpi-kernel
@@ -19,11 +19,11 @@ RUN export PATCH=$(curl -s https://mirrors.edge.kernel.org/pub/linux/kernel/proj
     curl https://mirrors.edge.kernel.org/pub/linux/kernel/projects/rt/${LINUX_KERNEL_VERSION}/${PATCH}.patch.gz --output ${PATCH}.patch.gz && \
     gzip -cd /rpi-kernel/linux/${PATCH}.patch.gz | patch -p1 --verbose
 
-ENV KERNEL=kernel8
-ENV ARCH=arm64
-ENV CROSS_COMPILE=aarch64-linux-gnu-
+ENV KERNEL=kernel
+ENV ARCH=arm
+ENV CROSS_COMPILE=arm-linux-gnueabihf-
 
-RUN make bcm2711_defconfig
+RUN make bcmrpi_defconfig
 RUN ./scripts/config --disable CONFIG_VIRTUALIZATION
 RUN ./scripts/config --enable CONFIG_PREEMPT_RT
 RUN ./scripts/config --disable CONFIG_RCU_EXPERT
@@ -34,10 +34,10 @@ RUN make Image modules dtbs
 
 WORKDIR /raspios
 RUN apt -y install
-RUN export DATE=$(curl -s https://downloads.raspberrypi.org/raspios_lite_arm64/images/ | sed -n 's:.*raspios_lite_arm64-\(.*\)/</a>.*:\1:p' | tail -1) && \
-    export RASPIOS=$(curl -s https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-${DATE}/ | sed -n 's:.*<a href="\(.*\).xz">.*:\1:p' | tail -1) && \
+RUN export DATE=$(curl -s https://downloads.raspberrypi.org/raspios_lite_armhf/images/ | sed -n 's:.*raspios_lite_armhf-\(.*\)/</a>.*:\1:p' | tail -1) && \
+    export RASPIOS=$(curl -s https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-${DATE}/ | sed -n 's:.*<a href="\(.*\).xz">.*:\1:p' | tail -1) && \
     echo "Downloading ${RASPIOS}.xz" && \
-    curl https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-${DATE}/${RASPIOS}.xz --output ${RASPIOS}.xz && \
+    curl https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-${DATE}/${RASPIOS}.xz --output ${RASPIOS}.xz && \
     xz -d ${RASPIOS}.xz
 
 RUN mkdir /raspios/mnt && mkdir /raspios/mnt/disk && mkdir /raspios/mnt/boot
diff --git a/build.sh b/build.sh
index 0195a02..20592ef 100755
--- a/build.sh
+++ b/build.sh
@@ -10,10 +10,10 @@ make INSTALL_MOD_PATH=/raspios/mnt/disk modules_install
 make INSTALL_DTBS_PATH=/raspios/mnt/boot dtbs_install
 cd -
 
-cp /rpi-kernel/linux/arch/arm64/boot/Image /raspios/mnt/boot/$KERNEL\_rt.img
-cp /rpi-kernel/linux/arch/arm64/boot/dts/broadcom/*.dtb /raspios/mnt/boot/
-cp /rpi-kernel/linux/arch/arm64/boot/dts/overlays/*.dtb* /raspios/mnt/boot/overlays/
-cp /rpi-kernel/linux/arch/arm64/boot/dts/overlays/README /raspios/mnt/boot/overlays/
+cp /rpi-kernel/linux/arch/arm/boot/Image /raspios/mnt/boot/$KERNEL\_rt.img
+cp /rpi-kernel/linux/arch/arm/boot/dts/broadcom/*.dtb /raspios/mnt/boot/
+cp /rpi-kernel/linux/arch/arm/boot/dts/overlays/*.dtb* /raspios/mnt/boot/overlays/
+cp /rpi-kernel/linux/arch/arm/boot/dts/overlays/README /raspios/mnt/boot/overlays/
 
 cp /raspios/config.txt /raspios/mnt/boot/
 touch /raspios/mnt/boot/ssh
 ```
