## docker
```bash
# stat display ("top")
docker stats
# remove all images (keeps used ones)
docker rmi $(docker images -q)
# remove all containers
docker rm $(docker ps -a -q)
#run shell
docker exec -it imagename bash

# ufw instead of iptables
vim /etc/docker/daemon.json
{"iptables":false}

vim etc/default/ufw
DEFAULT_FORWARD_POLICY="ACCEPT"

vim /etc/ufw/after.rules
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING ! -o docker0 -s 172.19.0.0/16 -j MASQUERADE
COMMIT
```
