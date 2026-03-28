# OpenMediaVault
```bash
# use docker-compose with podman (compose plugin breaks pod installs firewall)
apt install podman-compose
cd /srv/dev-disk-by.../docker-compose/mcp-server
podman-compose -f mcp-server.yml up -d
```
