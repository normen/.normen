## Linux
```bash
#tar.gz
tar -xvzf myfile.tar.gz
# start process and get PID
myCommand & echo $!
#list disks
lsblk
#format disk
#If you wish to use the MBR format, type this instead:
sudo parted /dev/sda mklabel msdos
sudo parted /dev/sda mklabel gpt
sudo parted -a opt /dev/sda mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L datapartition /dev/sda1

#hard problem fix
sudo mke2fs -n /dev/sda
#adapt sizes below from above output (4k / superblock pos)
sudo fsck -b 163840 -B 4096 /dev/sda

#iptables
iptables -L
#see man iptables-extensions
# -Insert (-Append) to FORWARD chain for -source ip/mask -jump to DROP (ACCEPT)
iptables -I  FORWARD -s 192.168.1.0/255.255.255.0 -j DROP
# -m state --state INVALID, ESTABLISHED, NEW, RELATED or UNTRACKED
# NEW = new connection
# block traffic from WAN local network (add via Admin->Firewall)
#-match plugin state --state NEW connection (not ESTABLISHED)
iptables -I FORWARD -i br0 -d $(nvram get wan_ipaddr)/$(nvram get wan_netmask) -m state --state NEW -j DROP

#convert gz image to zip image (Apple Pi Baker)
gunzip --to-stdout input.gz | zip > output.zip

# find large files
du -k | sort -n -r | head

# ssh keys
#local
ssh-keygen
.ssh/id_rsa.pub -> key file
#remote
key file -> .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
# disable password login
sudo vim /etc/ssh/sshd_config
ChallengeResponseAuthentication no
PasswordAuthentication no

# fsck
sudo tune2fs -l /dev/sda1 | grep "Last checked"
sudo tune2fs -l /dev/mmcblk0p2 | grep "Last checked"
sudo shutdown -r -F now

# logrotate
sudo logrotate --force /etc/logrotate.d/homebridge

# do as other user
sudo -H -u otheruser bash -c 'echo "I am $USER, with uid $UID"' 

# apt-get
sudo apt-get autoremove --purge

# systemd service
# file at /etc/systemd/system/homebridge.service
<<CONTENT
[Unit]
Description=Node.js HomeKit Server 
After=syslog.target network-online.target

[Service]
Type=simple
User=homebridge
#WorkingDirectory=/home/pi/npm-code/landroid-bridge/
#EnvironmentFile=/etc/default/homebridge
# Adapt this to your specific setup (could be /usr/bin/homebridge)
# See comments below for more information
ExecStart=/usr/local/bin/homebridge $HOMEBRIDGE_OPTS
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
CONTENT
sudo systemctl daemon-reload
sudo systemctl enable homebridge
sudo systemctl start homebridge
```
