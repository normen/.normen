# Minecraft

## Install
- Ubuntu 24
- docker

## Docker
```bash
sudoedit /etc/docker/daemon.json
```
```json
{"log-driver":"journald","log-opts":{"tag":"{{.Name}}"},"ip":"127.0.0.1"}
```
```bash
# add user to docker group to access docker socket
sudo usermod -a -G docker $USER
```
- 
