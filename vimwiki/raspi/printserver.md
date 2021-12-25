## Print Server
```bash
sudo apt install cups
# add pi to cups admin group
sudo usermod -a -G lpadmin pi
# allow remote access
sudo cupsctl --remote-any
sudo systemctl restart cups
# install avahi for airprint
sudo apt install avahi-daemon
# install samba for windows
sudo apt install samba
sudo vi /etc/samba/smb.conf
<<APPEND
# CUPS printing.  
[printers]
comment = All Printers
browseable = no
path = /var/spool/samba
printable = yes
guest ok = yes
read only = yes
create mask = 0700

# Windows clients look for this share name as a source of downloadable
# printer drivers
[print$]
comment = Printer Drivers
path = /var/lib/samba/printers
browseable = yes
read only = no
guest ok = no
APPEND
sudo systemctl restart smbd
# configure in web
open http://printserver:631
```
