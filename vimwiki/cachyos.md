## CachyOS

### Install (pacman)
```bash
sudo pacman -S timeshift
```

### Install (yay)
```bash
yay -S input-remapper
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

#### Update Script (snapshot)
```bash
update_date=$(date)
sudo timeshift --create --comment "System Update on $update_date"
sudo pacman -Suy
```
