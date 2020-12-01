# bitwaves.de
```
# dyndns
homebridge server runs crontab!
```
```bash
#!/bin/bash
set -e
IP=`curl --ipv4 -s http://icanhazip.com/`
IP6=`curl --ipv6 -s http://icanhazip.com/`
OLD_IP=`cat ~/.curip`
if [ "$IP" != "$OLD_IP" ]; then
  echo "Set new IP: $IP"
  echo "$IP">~/.curip
  curl "https://bitwaves.de:password@dyndns.strato.com/nic/update?hostname=local.bitwaves.de&myip=$IP,$IP6"
else
  echo "IP still the same: $IP"
fi
```
## nginx rtmp
```
worker_processes  auto;
#error_log  logs/error.log;

events {
    worker_connections  1024;
}

# RTMP configuration
rtmp {
  server {
    listen 1935; # Listen on standard RTMP port
    chunk_size 4000; 
    ping 30s;
    notify_method get;

    # This application is to accept incoming stream
    application live {
      live on; # Allows live input
      deny play all; # disable consuming the stream from nginx as rtmp
      on_publish http://localhost:8080/auth;
      push rtmp://localhost:1935/show;
    }

    # This is the HLS application
    application show {
      live on; # Allows live input from above application
      deny play all; # disable consuming the stream from nginx as rtmp
      allow publish 127.0.0.1; # only allow localhost to publish (app above)
      deny publish all; # deny all others to publish

      hls on; # Enable HTTP Live Streaming
      hls_fragment 3;
      hls_playlist_length 10;
      hls_path /mnt/hls/;  # hls fragments path
            
      # MPEG-DASH
      dash on;
      dash_path /mnt/dash/;  # dash fragments path
      dash_fragment 3;
      dash_playlist_length 10;      
    }
  }
}


http {
  sendfile off;
  tcp_nopush on;
  directio 512;
  # aio on;
  
  # HTTP server required to serve the player and HLS fragments
  server {
    listen 8080;
    
    # Serve HLS fragments
    location /hls {
      types {
        application/vnd.apple.mpegurl m3u8;
        video/mp2t ts;
      }
      
      root /mnt;

      add_header Cache-Control no-cache; # Disable cache
      
      # CORS setup
      add_header 'Access-Control-Allow-Origin' '*' always;
      add_header 'Access-Control-Expose-Headers' 'Content-Length';
            
      # allow CORS preflight requests
      if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Origin' '*';
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Content-Type' 'text/plain charset=UTF-8';
        add_header 'Content-Length' 0;
        return 204;
      }
    }
    
    # Serve DASH fragments
    location /dash {
      types {
        application/dash+xml mpd;
        video/mp4 mp4;
      }

      root /mnt;
      
      add_header Cache-Control no-cache; # Disable cache


      # CORS setup
      add_header 'Access-Control-Allow-Origin' '*' always;
      add_header 'Access-Control-Expose-Headers' 'Content-Length';

      # Allow CORS preflight requests
      if ($request_method = 'OPTIONS') {
          add_header 'Access-Control-Allow-Origin' '*';
          add_header 'Access-Control-Max-Age' 1728000;
          add_header 'Content-Type' 'text/plain charset=UTF-8';
          add_header 'Content-Length' 0;
          return 204;
      }
    }   
    
    # This URL provides RTMP statistics in XML
    location /stat {
      rtmp_stat all;
      rtmp_stat_stylesheet stat.xsl; # Use stat.xsl stylesheet 
    }

    location /stat.xsl {
      # XML stylesheet to view RTMP stats.
      root /usr/local/nginx/html;
    }

    #auth for publishing
    location /auth {
      #auth_basic "Streaming Area";
      #auth_basic_user_file /usr/local/nginx/.htpasswd; 
      if ($arg_token = "password") {
        return 200;
      }
      return 403;
    }
  }
}
```
## ufw
```
Status: Aktiv

Zu                         Aktion      Von
--                         ------      ---
80                         ALLOW       Anywhere                   # http
22                         ALLOW       Anywhere                   # ssh
443                        ALLOW       Anywhere                   # https
8443                       ALLOW       Anywhere                   # plesk web
8447                       ALLOW       Anywhere                   # plesk updates
21/tcp                     ALLOW       Anywhere                   # ftp
115/tcp                    ALLOW       Anywhere                   # sftp
25/tcp                     ALLOW       Anywhere                   # smtp
110                        ALLOW       Anywhere                   # pop3
143                        ALLOW       Anywhere                   # imap
4443/tcp                   ALLOW       Anywhere                   # jitsi tcp-rtp
10000/udp                  ALLOW       Anywhere                   # jitsi udp-rtp
3306 on docker0            ALLOW       Anywhere                   # docker mysql
60000:60002/udp            ALLOW       Anywhere                   # mosh
6667                       ALLOW       Anywhere                   # irc
1935                       ALLOW       Anywhere                   # rtmp
8090                       ALLOW       Anywhere                   # yacy
8444                       ALLOW       Anywhere                   # yacy
53                         ALLOW       Anywhere                   # DNS
80 (v6)                    ALLOW       Anywhere (v6)              # http
22 (v6)                    ALLOW       Anywhere (v6)              # ssh
443 (v6)                   ALLOW       Anywhere (v6)              # https
8443 (v6)                  ALLOW       Anywhere (v6)              # plesk web
8447 (v6)                  ALLOW       Anywhere (v6)              # plesk updates
21/tcp (v6)                ALLOW       Anywhere (v6)              # ftp
115/tcp (v6)               ALLOW       Anywhere (v6)              # sftp
25/tcp (v6)                ALLOW       Anywhere (v6)              # smtp
110 (v6)                   ALLOW       Anywhere (v6)              # pop3
143 (v6)                   ALLOW       Anywhere (v6)              # imap
4443/tcp (v6)              ALLOW       Anywhere (v6)              # jitsi tcp-rtp
10000/udp (v6)             ALLOW       Anywhere (v6)              # jitsi udp-rtp
3306 (v6) on docker0       ALLOW       Anywhere (v6)              # docker mysql
60000:61000/udp (v6)       ALLOW       Anywhere (v6)              # mosh
6667 (v6)                  ALLOW       Anywhere (v6)              # irc
1935 (v6)                  ALLOW       Anywhere (v6)              # rtmp
8090 (v6)                  ALLOW       Anywhere (v6)              # yacy
8444 (v6)                  ALLOW       Anywhere (v6)              # yacy
53 (v6)                    ALLOW       Anywhere (v6)              # DNS
```
