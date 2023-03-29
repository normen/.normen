# FHEM
```
telnet localhost 7072
inform on
inform log
set CULMAX0 pairmode 60
-> pair on device
shutdown restart
```
## nanoCUL flashen
```bash
wget http://culfw.de/culfw-1.67.tar.gz
tar -xf culfw-1.67.tar.gz
cd culfw-1.67
vim clib/rf_send.h
#-> #define MAX_CREDIT 3600
cd Devices/nanoCul
vim board.h
#-> comment out 433MHz
make
avrdude -D -p atmega328p -P /dev/serial/by-path/platform-3f980000.usb-usb-0:1.2:1.0-port0 -b 115200 -c arduino    -U flash:w:nanoCUL.hex
wget https://www.nanocul.de/upload/a-culfw_nanoCUL433_1.26.06.zip
unzip a-culfw_nanoCUL433_1.26.06.zip
avrdude -D -p atmega328p -P /dev/serial/by-path/platform-3f980000.usb-usb-0:1.4:1.0-port0 -b 115200 -c arduino    -U flash:w:a-culfw-1.26.06-nanoCUL433.hex
```
