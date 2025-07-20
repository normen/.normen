## btrfs
```bash
# general commands
# show all devices
btrfs device scan
# show all btrfs filesystems
btrfs filesystem show

# create btrfs (and raid)
# make FS (add -f to force)
mkfs.btrfs -L "My Disk" /dev/sda
# mount filesystem
mount /dev/sda /mnt/Disk
# add disk(s)
btrfs device add /dev/sdb /mnt/Disk
# balance to raid1 (add -mconvert to also convert meta to raid)
btrfs filesystem balance start -convert=raid1 /mnt/Disk

# fix when broken
# mount in degraded mode
mount -o degraded /dev/sda /mnt/Disk
# replace missing disk with /dev/sdb
btrfs replace start missing /dev/sdb /mnt/Disk
# show progress
btrfs replace status /mnt/Disk
```
