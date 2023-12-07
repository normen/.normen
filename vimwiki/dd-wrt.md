## dd-wrt
```bash
http://dd-wrt.com/

# HAUSROUTER Netgear R6400 v2
# netgear 6400v2 download:
https://ftp.dd-wrt.com/dd-wrtv2/downloads/betas/2023/12-04-2023-r54420/netgear-r6400v2/

# GASTROUTER Linksys WRT54GL v1.1
# linksys 54g download:
https://ftp.dd-wrt.com/dd-wrtv2/downloads/betas/2023/12-04-2023-r54420/broadcom/
# block traffic from WAN local network (add via Admin->Firewall)
#-match plugin state --state NEW connection (not ESTABLISHED)
iptables -I FORWARD -i br0 -d $(nvram get wan_ipaddr)/$(nvram get wan_netmask) -m state --state NEW -j DROP

# update firmware tftp (192.168.1.1)
tftp 192.168.1.1
binary
rexmt 1
timeout 60
trace
put dd-wrt.v24_micro_generic.bin

# VLANS sensibly
#https://www.flashrouters.com/blog/2015/04/06/what-is-a-vlan-how-to-setup-vlan-ddwrt/
#set VLANS, set unbridged per port, set IP per port
#add multiple dhcp servers (Networking)
# -Insert (-Append) to FORWARD chain for -source ip/mask -jump to DROP (ACCEPT)
iptables -I  FORWARD -s 192.168.1.0/255.255.255.0 -j DROP
iptables -I  FORWARD -s 192.168.2.0/255.255.255.0 -j DROP
iptables -I  FORWARD -s 192.168.3.0/255.255.255.0 -j DROP
iptables -I  FORWARD -s 192.168.4.0/255.255.255.0 -j DROP

# jffs enable (admin panel)
# opt (commands -> startup script)
mount -o bind /jffs/opt /opt

#opkg:
#http://bin.entware.net/armv7sf-k3.2/Packages.html
#https://wiki.dd-wrt.com/wiki/index.php/Installing_Entware
cd /opt
wget http://bin.entware.net/armv7sf-k3.2/installer/generic.sh
sh generic.sh

#shutdown drive (some)
hdparm -y /dev/sda

#USB hd shutdown
opkg install sdparm
sdparm --flexible --command=stop /dev/sda

# restart web interface
stopservice httpd
startservice httpd

# copy firmware (ssh enabled!)
scp -rp firmware_name.bin root@192.168.2.1:/tmp/
telnet 192.168.2.1
cd /tmp
md5sum firmware_name.bin
write firmware_name.bin linux
reboot now

##random iptables
#Enable NAT on the WAN port to correct a bug in builds over 17000
iptables -t nat -I POSTROUTING -o `get_wanface` -j SNAT --to `nvram get wan_ipaddr`

#Allow br1 access to br0, the WAN, and any other subnets (required if SPI firewall is on)
iptables -I FORWARD -i br1 -m state --state NEW -j ACCEPT
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

#Restrict br1 from accessing br0
iptables -I FORWARD -i br1 -o br0 -m state --state NEW -j DROP

#Restrict br1 from accessing the WAN subnet
iptables -I FORWARD -i br1 -d `nvram get wan_ipaddr`/`nvram get wan_netmask` -m state --state NEW -j DROP

#Restrict br1 from accessing the router's local sockets
iptables -I INPUT -i br1 -m state --state NEW -j DROP

#Allow br1 to access DHCP on the router
iptables -I INPUT -i br1 -p udp --dport 67 -j ACCEPT

#Allow br1 to access DNS on the router
iptables -I INPUT -i br1 -p udp --dport 53 -j ACCEPT
iptables -I INPUT -i br1 -p tcp --dport 53 -j ACCEPT

#Block br1 from accessing Skype authentication servers
iptables -I FORWARD -i br1 -d 111.221.74.0/24 -j DROP
iptables -I FORWARD -i br1 -d 111.221.77.0/24 -j DROP
iptables -I FORWARD -i br1 -d 157.55.130.0/24 -j DROP
iptables -I FORWARD -i br1 -d 157.55.235.0/24 -j DROP
iptables -I FORWARD -i br1 -d 157.55.56.0/24 -j DROP
iptables -I FORWARD -i br1 -d 157.56.52.0/24 -j DROP
iptables -I FORWARD -i br1 -d 194.165.188.0/24 -j DROP
iptables -I FORWARD -i br1 -d 195.46.253.0/24 -j DROP
iptables -I FORWARD -i br1 -d 213.199.179.0/24 -j DROP
iptables -I FORWARD -i br1 -d 63.245.217.0/24 -j DROP
iptables -I FORWARD -i br1 -d 64.4.23.0/24 -j DROP
iptables -I FORWARD -i br1 -d 65.55.223.0/24 -j DROP
```
