## CachyOS

### Touch Pad (pacman)
```bash
sudo pacman -S touchegg
yay -S touche
# run on login:
touchegg --client
```

### Input Remap (Ctrl-Ä)
```bash
sudo pacman -S keyd
sudoedit /etc/keyd/default.conf
<<CONTENT
[ids]
*

[main]
capslock = layer(control)

[control]
' = esc
CONTENT
sudo systemctl enable keyd
sudo systemctl start keyd
```

### Font
```bash
sudo pacman -S ttf-liberation-mono-nerd
``` 

### Firefox Setup
- Vimium
- NC Passwords

### Pacman
```bash
# install

# update
sudo pacman -Suy
# remove with deps and dependents(!)
sudo pacman -Rcs
# remove with deps
sudo pacman -Rus
# show non-repo installs
sudo pacman -Qm
# remove unneeded
sudo pacman -Rns $(pacman -Qdtq)
```

#### Debtap (install .deb packages)
```bash
yay -S debtap
sudo debtap -u
debtap package.deb
sudo pacman -U package.pkg
```

#### Fingerprint login
```bash
sudo cp /usr/lib/pam.d/polkit-1 /etc/pam.d/
vim /etc/pam.d/polkit-1
<<CONTENT
auth [success=1 default=ignore] pam_succeeded_if.so service in sudo:su:su-1 tty in :unknown
auth sufficient pam_fprintd.so
CONTENT
```

#### Limine (Snapshots)
```bash
sudo pacman -S limine-mkinitcpio-hook
sudo pacman -S limine-snapper-sync
sudo systemctl enable limine-snapper-sync
sudoedit /etc/kernel/cmdline
# append: splash quiet bgrt_disable
```

#### Systemd-Boot
```bash
sudo lsblk
sudo blkid /dev/sdb
vim /boot/loader/entries/sdcard.conf
<<CONTENT
title Linux Cachyos
options root=UUID=af0ef3d4-0374-4f1e-b816-a0af7218e925 rw
linux /vmlinuz-linux-cachyos
initrd /initramfs-linux-cachyos.img
CONTENT
#### Boot screen no text
sudoedit /boot/loader/entries/linux-cachyos.conf
# append: splash quiet bgrt_disable
```

#### AES67
```bash
# install linuxptp
yay -S linuxptp
# copy config from /usr/share/pipewire/pipewire-aes67.conf to ~/.config/pipewire/pipewire-aes67.conf
cp /usr/share/pipewire/pipewire-aes67.conf ~/.config/pipewire/pipewire-aes67.conf
# change the interface name in the config file
vim ~/.config/pipewire/pipewire-aes67.conf
# add udev rule to access ptp device
sudoedit /etc/udev/rules.d/90-pipewire-aes67-ptp.rules
<<CONTENT
KERNEL=="ptp[0-9]*", MODE="0644"
CONTENT
sudo udevadm control --reload-rules
# start ptp4l (root)
sudo ptp4l -i enp0s31f6  -s -l 7 -m -q
# alt: use aes67.conf for ptp4l
<<CONTENT
[global]
# Avoid becoming the Grandmaster
priority1 255
# Converge faster when time jumps
step_threshold 1
## AES67 Profile options
# Send Sync messages more often
logSyncInterval -3
# QoS
dscp_event 46
dscp_general 34
CONTENT
ptp4l -mq -i enp0s31f6 -f aes67.conf
# start pipewire-aes67
pipewire-aes67

# systemd service for ptp4l
sudoedit /etc/systemd/system/ptp4l.service
<<CONTENT
[Unit]
Description=PTP4L Service
After=network.target
[Service]
Type=simple
ExecStart=/usr/bin/ptp4l -i enp0s31f6 -s
Restart=always
[Install]
WantedBy=multi-user.target
CONTENT
sudo systemctl enable ptp4l.service
sudo systemctl start ptp4l.service
```

#### JACK (Pipewire)
```bash
# install pipewire-jack
sudo pacman -S pipewire-jack
# install qpwgraph
sudo pacman -S qpwgraph
# run ardour8 with 128 samples / 44100 Hz
pw-jack -s 44100 -p 128 ardour8
# or use pw-metadata (until restart)
pw-metadata -n settings 0 clock force-quantum 128
pw-metadata -n settings 0 clock force-rate 44100
# OR set globally for pipewire
mkdir -p ~/.config/pipewire/pipewire.conf.d
vim ~/.config/pipewire/pipewire.conf.d/custom.conf
<<CONTENT
context.properties = {
  default.clock.quantum = 128
  default.clock.rate = 44100
}
CONTENT

# ardour plugins
sudo pacman -S lsp-plugins-lv2

#airplay
sudo pacman -S pipewire-zeroconf
vim ~/.config/pipewire/pipewire.conf.d/custom.conf
<<CONTENT
context.modules = [
  {
    name = libpipewire-module-raop-discover
    args = { }
  }
]
CONTENT
# open ufw ports 6001/6002
sudo ufw allow 6001/udp comment AirPlay
sudo ufw allow 6002/udp comment AirPlay
sudo ufw allow 5353/udp comment "mDNS AirPlay" 
sudo ufw allow 319/udp comment "AirPlay"
sudo ufw allow 320/udp comment "AirPlay"
# start airplay temporarily
pactl load-module module-raop-discover
```

### Emulation (qemu)
```bash
sudo pacman -S qemu-full virt-manager virt-viewer
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```

### VNC (krfb)
```bash
sudo pacman -S krfb
# add to autostart, set user password
vim ~/.config/krfbrc
<<CONTENT
[MainWindow]
startMinimized=true
CONTENT
# client: tigervnc
sudo pacman -S tigervnc
```
