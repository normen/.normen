# IPv6
```bash
# get IPv6 addresses
ifconfig | grep inet6

# log RA messages
sudo tcpdump -i any -v 'icmp6 && ip6[40] == 134'

# log DHCPv6 messages
sudo tcpdump -i any -vv 'ip6[40] == 143'

# vdsl router:
# enable dhcpv6 and radvd + ULAs
# disable igmp proxy and mld proxy on WAN
# enable igmp snooping
# block igmp
# block icmpv6
```
