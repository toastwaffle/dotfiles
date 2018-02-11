#!/bin/bash

xset +dpms
xset dpms 0 0 900

# Startup apps
if [ -x /usr/bin/udiskie ] ; then
    /usr/bin/udiskie &
fi

if [ -x /opt/dropbox/dropbox ] ; then
	/opt/dropbox/dropbox start &
fi

xsetroot -cursor_name left_ptr &

setxkbmap gb &

feh --no-fehbg --bg-tile /home/samuel/.backgrounds/1920x1080.png

stalonetray --background '#444444' --geometry '5x1+1820' --icon-size 20 --icon-gravity NE --max-geometry '96x1' &
