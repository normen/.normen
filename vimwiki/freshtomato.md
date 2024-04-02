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
tar -xzvf extras.tar.gz
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
# manual:
# mount -o bind /mnt/data/opt /opt

# run all on mount:
mount /opt
modprobe usbserial
insmod /opt/extras/cp210x.ko
sleep 10
/opt/etc/init.d/rc.unslung start

# unmount:
#!/bin/sh
/opt/etc/init.d/rc.unslung stop
sleep 15
for i in `cat /proc/mounts | awk '/ext3/{print($1)}'` ; do
  mount -o remount,ro $i
done

# VPN firewall:
# allow forwarding for VPN
iptables -I FORWARD 1 --source 10.6.0.0/24 -j ACCEPT
# masquerading for VPN
iptables -t nat -A POSTROUTING -s 10.6.0.0/24 -o br0 -j MASQUERADE
# freshtomato: disable DNS advertising

```

#### Samba

```bash
# samba users + mounts per user
# make init script:

#!/bin/sh
# Check to see if there are any FTP users.  If there are then create a Samba user for each one
# Put these commands in the background so the system isn't waiting for this script to finish
(
  FTPUSERS=`nvram get ftp_users`
  if [ -n "$FTPUSERS" ]
  then
    # Now we can wait for the sysup flag...
    while [ ! -f /var/notice/sysup ]; do sleep 2; done
    OLDIFS=$IFS
    IFS='>'
    USERID=100
    for USER in $FTPUSERS
    do
      USERNAME=`echo $USER | cut -d'<' -f1`
      PASSWORD=`echo $USER | cut -d'<' -f2`
      USERID=$(($USERID + 100))
      echo $USERNAME:x:$USERID:$USERID:user:/dev/null:/dev/null >> /etc/passwd.custom
      /usr/bin/smbpasswd $USERNAME $PASSWORD
    done
    IFS=$OLDIFS
    service samba restart
  fi
)&

# add mounts to samba custom config:
<<CONTENT
[User2Folder]
comment =
path = /tmp/mnt/Folder/Folder/User2Folder
writable = yes
delete readonly = yes
valid users = username2

[User3Folder]
comment =
path = /tmp/mnt/Folder/Folder/User3Folder
writable = yes
delete readonly = yes
valid users = username3
CONTENT
```

