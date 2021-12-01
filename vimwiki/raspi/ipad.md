## iPad-Raspi

```bash
sudo apt install dnsmasq -y
sudo chmod ugo+rwx /boot/config.txt
sudo chmod ugo+rwx /boot/cmdline.txt
sudo chmod ugo+rwx /etc/modules
sudo chmod ugo+rwx /etc/dhcpcd.conf

# In /boot/config.txt add the following to the end of the file
dtoverlay=dwc2
# In /boot/cmdline.txt add the following to the end of the file (make sure there is a space between the existing commands and this)
modules-load=dwc2
# In /etc/modules add the following to the end of the file
libcomposite
# In /etc/dhcpcd.conf add the following to the end of the file
denyinterfaces usb0

sudo vim /etc/dnsmasq.d/usb
<<CONTENT
interface=usb0
dhcp-range=10.55.0.2,10.55.0.6,255.255.255.248,1h
dhcp-option=3
leasefile-ro
CONTENT

sudo vim /etc/network/interfaces.d/usb0
<<CONTENT
auto usb0
allow-hotplug usb0
iface usb0 inet static
  address 10.55.0.1
  netmask 255.255.255.248
CONTENT

sudo vim /root/usb.sh
<<CONTENT
#!/bin/bash
cd /sys/kernel/config/usb_gadget/
mkdir -p pi4
cd pi4
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
echo 0xEF > bDeviceClass
echo 0x02 > bDeviceSubClass
echo 0x01 > bDeviceProtocol
mkdir -p strings/0x409
echo "fedcba9876543211" > strings/0x409/serialnumber
echo "John Doe" > strings/0x409/manufacturer
echo "PI4 USB Device" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower
# Add functions here
# see gadget configurations below
# End functions
mkdir -p functions/ecm.usb0
HOST="00:dc:c8:f7:75:14" # "HostPC"
SELF="00:dd:dc:eb:6d:a1" # "BadUSB"
echo $HOST > functions/ecm.usb0/host_addr
echo $SELF > functions/ecm.usb0/dev_addr
ln -s functions/ecm.usb0 configs/c.1/
udevadm settle -t 5 || :
ls /sys/class/udc > UDC
ifup usb0
service dnsmasq restart
CONTENT
sudo chmod +x /root/usb.sh

sudo vim /etc/rc.local
<<CONTENT
sh /root/usb.sh
CONTENT

sudo reboot
```
