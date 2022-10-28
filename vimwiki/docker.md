## docker
```bash
# build from dockerfile (myimage:v3)
docker build -t myimage .
# create container from hub (dockeruser) or local image by running once with interactive shell -it
# example has port forward -p, folder replacement -v and env opt -e
# adding --rm removes the container right away
docker run --name mycontainer --restart unless-stopped -it -p 8080:80 -v /local/folder:/image/folder/to/replace -e ENVOPT="myenv" dockeruser/imagename:latest
# run container (same settings as run)
docker start mycontainer
# run interactive
docker start -i mycontainer
# restart
docker container restart mycontainer
# stat display ("top")
docker stats
# remove all images (keeps used ones)
docker rmi $(docker images -q)
# remove all containers
docker rm $(docker ps -a -q)
#run shell
docker exec -it imagename bash
#update
docker pull my/imagename


# ufw instead of iptables
vim /etc/docker/daemon.json
{"iptables":false}

vim /etc/default/ufw
DEFAULT_FORWARD_POLICY="ACCEPT"

vim /etc/ufw/after.rules
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING ! -o docker0 -s 172.19.0.0/16 -j MASQUERADE
COMMIT

# options for logging
vim /etc/docker/daemon.json
<<CONTENT
{
  "log-driver": "journald",
  "log-opts": {
    "tag": "{{.ImageName}}/{{.Name}}"
  }
}
CONTENT
# install macos:
brew install docker colima
colima start
docker context use colima
export DOCKER_HOST=unix:///Users/normenhansen/.colima/docker.sock
docker run hello-world
```
## create docker alpine
```bash
vim main.pl
<<CONTENT
#!/usr/bin/env perl
print("Hello World");
CONTENT
vim Dockerfile
<<CONTENT
FROM alpine:3.14
RUN apk add --no-cache perl
COPY main.pl /usr/local/bin/
ENTRYPOINT ["main.pl"]
CONTENT
docker build -t perl-test .
docker run perl-test

# with cpanm
<<CONTENT
#!/usr/bin/env perl
use Mojolicious::Lite;
get '/' => sub {
  my ($c) = @_;
  $c->render(text=> "Hello World");
};
app->start("daemon");
CONTENT
<<CONTENT
FROM alpine:3.14
#RUN apk add --no-cache perl curl wget tar make gcc build-base gnupg
RUN apk add --no-cache perl curl wget tar make
RUN curl -LO https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm
RUN chmod +x cpanm
RUN mv cpanm /usr/local/bin/
RUN cpanm -ni Mojolicious::Lite
COPY main.pl /usr/local/bin/
ENTRYPOINT ["main.pl"]
CONTENT

# X11 forwarding
<<Dockerfile
FROM ubuntu
RUN apt update \
    && apt install -y firefox \
                      openssh-server \
                      xauth \
    && mkdir /var/run/sshd \
    && mkdir /root/.ssh \
    && chmod 700 /root/.ssh \
    && ssh-keygen -A \
    && sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

RUN echo "YOUR_PUB_KEY_HERE" >> /root/.ssh/authorized_keys

ENTRYPOINT ["sh", "-c", "/usr/sbin/sshd && tail -f /dev/null"]
Dockerfile
docker build -t ubuntu-x11 .
docker run --name ubuntu-x11 -it --rm -p 2150:22 ubuntu-x11
docker start ubuntu-x11
vim ~/.ssh/config
<<CONTENT
Host ubuntu-x11
  Hostname localhost
  Port 2150
  user root
  ForwardX11 yes
  ForwardX11Trusted yes
CONTENT
ssh -X ubuntu-x11 firefox
```
