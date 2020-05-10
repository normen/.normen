## macos
```
# log iCloud Drive activity
brctl log -wt //--wait --shorten
brctl log -wtl 6 //no debug

# soft fix icloud sync
chown -R normenhansen:staff ~/Library/Mobile\ Documents/
chmod -R 755 ~/Library/Mobile\ Documents/

# hard fix icloud sync loop
killall bird
cd ~/Library/Application\ Support
sudo rm -rf CloudDocs
sudo reboot


# brew -> see brew doc

# disk permissions
#erst im finder home resetten (Apfel-I, schloss)
#ab mojave terminal in sicherheit auf festplattenvollzugriff
diskutil resetUserPermissions / `id -u`
#chmod .ssh/id !

```
