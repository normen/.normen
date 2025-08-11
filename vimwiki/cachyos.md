## CachyOS

### Install (pacman)
```bash
sudo pacman -S timeshift
sudo pacman -S touchegg
# run on login:
touchegg --client
```

### Install (yay)
```bash
yay -S input-remapper-bin
yay -S realvnc-vnc-viewer
# run on login:
input-remapper-control --command autoload
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

#### Update Script (snapshot)
```bash
update_date=$(date)
sudo timeshift --create --comment "System Update on $update_date"
sudo pacman -Suy
```

#### Boot screen no text
```bash
sudoedit /boot/loader/entries/linux-cachyos.conf
# append: splash quiet bgrt_disable
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
sudo pacman -S limine limine-snapper-sync
sudo systemctl enable limine-snapper-sync
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
# start pipewire-aes67
pipewire-aes67
```
