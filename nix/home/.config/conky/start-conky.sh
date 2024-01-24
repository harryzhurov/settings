#!/bin/sh

sleep 5

killall conky

conky -c ~/.config/conky/general
conky -c ~/.config/conky/network
conky -c ~/.config/conky/kern-log
conky -c ~/.config/conky/system-log
