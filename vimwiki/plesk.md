## plesk
#### fix apache reboot
```bash
sed -i -e 's|^\(apache_status_linux_debian\)|_\1|g' /opt/psa/admin/sbin/pleskrc
```

#### GIT
```bash
#Repair if plesk repair fails:
/usr/local/psa/admin/sbin/autoinstaller --select-release-current --reinstall-patch --upgrade-installed-components
#Add a new user:
PSA_PASSWORD=example_password plesk sbin pdmng --add-user --vhost-name=example.com --directory=git@plesk-git --user-name=exampleuser
#Modify already existing user:
PSA_PASSWORD=new_password plesk sbin pdmng --update-user --vhost-name=example.com --directory=git@plesk-git --user-name=exampleuser
#Remove a user:
plesk sbin pdmng --remove-user --vhost-name=example.com --directory=git@plesk-git --user-name=exampleuser
# List existing users:
cat /var/www/vhosts/system/example.com/pd/d..git@plesk-git
```
