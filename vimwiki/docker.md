## docker
```bash
# stat display ("top")
docker stats
# remove all images (keeps used ones)
docker rmi $(docker images -q)
# remove all containers
docker rm $(docker ps -a -q)
```
