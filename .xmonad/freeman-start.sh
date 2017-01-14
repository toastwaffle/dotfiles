#!/bin/bash

xset +dpms
xset dpms 0 0 900

# Startup apps
if [ -x /usr/bin/gnome-keyring-daemon ]; then
    for line in $(/usr/bin/gnome-keyring-daemon --start); do
        eval "export $line"
    done
fi

if [ -x /usr/bin/udiskie ] ; then
    /usr/bin/udiskie &
fi

if [ -x /usr/lib/gnome-settings-daemon/gnome-settings-daemon ] ; then
    /usr/lib/gnome-settings-daemon/gnome-settings-daemon &
fi

if [ -x /opt/dropbox/dropbox ] ; then
	/opt/dropbox/dropbox start &
fi

xsetroot -cursor_name left_ptr &

setxkbmap gb &

envfile="$HOME/.gnupg/gpg-agent.env"
if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
    eval "$(cat "$envfile")"
else
    eval "$(gpg-agent --daemon --enable-ssh-support --write-env-file "$envfile")"
fi
export GPG_AGENT_INFO  # the env file does not contain the export statement
export SSH_AUTH_SOCK   # enable gpg-agent for ssh

feh --bg-tile /home/samuel/.backgrounds/1920x1080.png

stalonetray --background '#444444' --geometry '5x1+1820' --icon-size 20 --icon-gravity NE --max-geometry '96x1' &
