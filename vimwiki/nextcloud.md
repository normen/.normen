## Nextcloud
#### S3 Strato
- s3.hidrive.strato.com
- europe-central-1
- [✓] SSL
- [✓] Pfad
- [✓] Legacy
#### OCC
```bash
# add iCloud column to iCloud passwords export to allow using as folder
sed 's/$/,iCloud/' passwords.csv > passwords_new.csv
#notification
php occ notification:generate -l "Long Message" normen "Short Message"

# disable workspace
nextcloud config:app:set text workspace_available --value=0
```
