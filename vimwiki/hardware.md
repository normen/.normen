# Various Hardware
## Microcontrollers
* [hardware/ESP8266](hardware/ESP8266.md)
* [hardware/LinkItSmart7688](hardware/LinkItSmart7688.md)
* [hardware/Roomba](hardware/Roomba.md)
* [hardware solar](hardware/solar.md)

## Home Device Infos
```bash
# CAMS

#Denver
- reboot after enabling motion detection!

#TFTP revive edimax
#https://github.com/kestassf/Edimax-IC-3015Wn
#set IP of eth to base (192.168.1.2)
ping -t 192.168.1.6
#hold reset while powering
#install tftp on win through add/remove -> system
#when ping upload tftp
tftp -i 192.168.1.6 PUT c:\blah.bin

#quigg switches
{"type":"quigg_gt1000","message":{"id":0,"unit":0}}
id: 0-15 unit: 0-3
```
