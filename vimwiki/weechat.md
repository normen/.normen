## weechat
```
:layout store
:autojoin --run
:split 20

# add discord autojoin ignore
account discord off
account discord set auto_join_exclude
account discord set auto_join_exclude "new*,list*"
account discord on

#bitlbee
account add <protocol> <username> <password>
for slack: user@example.com%<workspace>.slack.com
acc discord set token_cache xxxxxxxx
acc discord on
chat list discord
chat add discord !1 #mychannel
chat add discord Hom.general #mychannel
channel #mychannel del
:join #mychannel

#ssl issue
#mac
/set weechat.network.gnutls_ca_file "/usr/local/etc/openssl/cert.pem"
#raspi
/set weechat.network.gnutls_ca_file "/etc/ssl/certs/ca-certificates.crt"
```
