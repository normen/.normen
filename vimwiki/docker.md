## docker
```bash
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

vim etc/default/ufw
DEFAULT_FORWARD_POLICY="ACCEPT"

vim /etc/ufw/after.rules
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING ! -o docker0 -s 172.19.0.0/16 -j MASQUERADE
COMMIT
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
```
