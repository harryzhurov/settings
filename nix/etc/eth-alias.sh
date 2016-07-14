#!/bin/sh

modprobe dummy
ifconfig dummy0 hw ether 00:26:18:9b:ab:3c
#ifup dummy0
ip link set name eth0 dev dummy0

