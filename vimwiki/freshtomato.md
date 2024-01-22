## FreshTomato
```bash
# install entware on external USB drive (ENTWARE, mounted)
fdisk -l
fdisk /dev/sdb
mkfs.ext3 -L ENTWARE /dev/sdb1
mount -o bind /mnt/ENTWARE/opt /opt
entware-install.sh

# driver for USB Serial from extras (CP210x)
curl https://freshtomato.org/downloads/freshtomato-arm/2023/2023.5/extras-arm.tar.gz > extras.tar.gz
cd /opt
tar xcvf extras.tar.gz
modprobe usbserial
insmod /opt/extras/cp210x.ko

# ser2net
opkg install ser2net usbutils
vi /opt/etc/ser2net/ser2net.yaml
<<CONTENT
connection: &con00
  accepter: tcp,20108
  connector: serialdev,/dev/ttyUSB0,115200n81,local
CONTENT
/opt/etc/init.d/S50ser2net restart

# in zigbee2mqtt.yaml:
# serial:
#   port: tcp://192.168.2.3:20108

# run init script:
echo "LABEL=ENTWARE /opt ext3 rw,noatime 1 1" >> /etc/fstab

# run all on mount:
mount /opt
modprobe usbserial
insmod /opt/extras/cp210x.ko
sleep 10
/opt/etc/init.d/rc.unslung start

```
