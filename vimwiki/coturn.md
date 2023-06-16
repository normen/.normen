## Coturn
```bash
# add user
turnadmin -a -u <username> -p <password> -r <realm>
# delete user
turnadmin -d -u <username> -r <realm>
sudo vim /etc/turnserver.conf
<<CONTENT
cert=/usr/local/etc/turn_server_cert.pem
pkey=/usr/local/etc/turn_server_pkey.pem
server-name=turn.bitwaves.de
realm=bitwaves.de
listening-ip=81.169.199.199
listening-ip=2a01:238:428e:e800:94a6:da26:6640:2
listening-port=3478
min-port=49160
max-port=49200
fingerprint
verbose
no-cli
lt-cred-mech
CONTENT
```
