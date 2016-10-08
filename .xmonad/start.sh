#!/bin/bash

# Start apps that are used on all systems
if [ -x /usr/bin/nm-applet ] ; then
    /usr/bin/nm-applet &
fi

if [ -x /usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd ] ; then
   /usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd &
fi

# Load system specific files
eval "$(hostname)-start.sh"

# Set cursor style
xsetroot -cursor_name left_ptr &

# Set keyboard map
setxkbmap gb &

# Hack to make some programs behave a little better
export _JAVA_AWT_WM_NONREPARENTING=1

# Put xmonad.hs in place
if [ -L ~/.xmonad/xmonad.hs ];
then
  rm ~/.xmonad/xmonad.hs
  ln -s "~/.xmonad/$(hostname)-xmonad.hs" ~/.xmonad/xmonad.hs
fi

# Put xmobarrc in place
if [ -L ~/.xmobarrc ];
then
  rm ~/.xmonad/xmobarrc
  ln -s "~/.$(hostname)-xmobarrc" ~/.xmobarrc
fi

# (Re)compile xmonad if necessary
if [ ! ( -f ~/.xmonad/compile-hostname ) ];
then
  xmonad --recompile
else
  if [ ! ( "$(hostname)" = "$(cat ~/.xmonad/compile-hostname)" ) ];
  then
    xmonad --recompile
  fi
fi

# Let's go!
exec xmonad
