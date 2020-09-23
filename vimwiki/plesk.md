## plesk
#### fix apache reboot
```bash
sed -i -e 's|^\(apache_status_linux_debian\)|_\1|g' /opt/psa/admin/sbin/pleskrc
```
