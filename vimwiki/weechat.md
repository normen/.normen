## weechat
```
:layout store
:autojoin --run
:split 20

#bitlbee
account add <protocol> <username> <password>
for slack: user@example.com%<workspace>.slack.com
chat list discord
chat add !1 #mychannel
:join #mychannel

#ssl issue
#mac
/set weechat.network.gnutls_ca_file "/usr/local/etc/openssl/cert.pem"
#raspi
/set weechat.network.gnutls_ca_file "/etc/ssl/certs/ca-certificates.crt"
```
