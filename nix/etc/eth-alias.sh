#!/bin/sh

modprobe dummy numdummies=1
ip link add eth0 type dummy
ifconfig eth0 hw ether 00:26:18:9b:ab:3c
#ifconfig dummy0 hw ether 00:26:18:9b:ab:3c
#ifup dummy0
#ip link set name eth0 dev dummy0

