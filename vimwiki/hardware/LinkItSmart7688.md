# LinkIt Smart 7688
```
# ssh
- install openssh-sftp-server for sftp

# config
-> /etc/config/*
reload_config -> reloads services etc.

# service
- create /etc/init.d/xxx

-->
#!/bin/sh /etc/rc.common

START=80 #after network
STOP=20 #before network

USE_PROCD=1

start_service() {
  procd_open_instance [rest-server]
  procd_set_param command /usr/bin/node /root/npm-code/rest-server/index.js
  procd_set_param file /root/npm-code/rest-server/index.js
  procd_set_param stdout 1 # forward stdout of the command to logd
  procd_set_param stderr 1 # same for stderr
  procd_set_param respawn
  procd_close_instance
}
<--

/etc/initd./xxxx enable
/etc/initd./xxxx start

# node.js REST
npm install -g express

-->
#!/usr/bin/env node
var express = require('express');
var app = express();

app.post('/set_status', function (req, res) {
   console.log(req.query);
   res.end("1");
})

var server = app.listen(8081, function () {
  var host = server.address().address
  var port = server.address().port
})
<--

# LUCI config page
https://github.com/openwrt/luci/blob/master/documentation/ModulesHowTo.md

# PS3 Eye
opkg update
opkg install usbutils kmod-usb2 kmod-usb-core kmod-usb-ohci kmod-usb-uhci
opkg install kmod-video-gspca-ov534
```
