## TimeMachine
```bash
# format disk
sudo fdisk -l
sudo parted /dev/sda mklabel gpt
sudo parted -a opt /dev/sda mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L datapartition /dev/sda1
# mount on boot
sudo mkir /mnt/timemachine
sudo vim /etc/fstab
<<CONTENT
/dev/sda1  /mnt/timemachine  ext4  defaults,nofail  0  2
CONTENT
# needs Raspbian buster at least
sudo apt install samba
sudo mkdir -m 1777 /mnt/timemachine/macos
sudo smbpasswd -a pi
sudo vim /etc/samba/smb.conf
<<CONTENT
[timemachine]
  comment = Time Machine
  path = /mnt/timemachine/macos
  browseable = yes
  writeable = yes
  create mask = 0600
  directory mask = 0700
; spotlight = yes
  vfs objects = catia fruit streams_xattr
  fruit:aapl = yes
  fruit:time machine = yes
CONTENT
# add icon for macos
sudo vim /etc/avahi/services/samba.service
<<CONTENT
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">%h</name>
  <service>
    <type>_smb._tcp</type>
    <port>445</port>
  </service>
  <service>
    <type>_device-info._tcp</type>
    <port>9</port>
    <txt-record>model=TimeCapsule8,119</txt-record>
  </service>
  <service>
    <type>_adisk._tcp</type>
    <port>9</port>
    <txt-record>dk0=adVN=timemachine,adVF=0x82</txt-record>
    <txt-record>sys=adVF=0x100</txt-record>
  </service>
</service-group>
CONTENT
```
