#!/bin/bash

# Start apps that are used on all systems
if [ -x /usr/bin/nm-applet ] ; then
    /usr/bin/nm-applet &
fi

if [ -x /usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd ] ; then
   /usr/lib/x86_64-linux-gnu/xfce4/notifyd/xfce4-notifyd &
fi

# Load system specific files
startfile="${HOME}/.xmonad/$(hostname -s)-start.sh"
eval "$(cat $startfile)"

# Make sure we use the updated dmenu_{run,path} if available
PATH=${HOME}/.zsh.d/bin:${PATH}

# Set cursor style
xsetroot -cursor_name left_ptr &

# Set keyboard map
setxkbmap gb &

# Hack to make some programs behave a little better
export _JAVA_AWT_WM_NONREPARENTING=1

# Put xmonad.hs in place
if [ -L ${HOME}/.xmonad/xmonad.hs ];
then
  rm ${HOME}/.xmonad/xmonad.hs
  ln -s "${HOME}/.xmonad/$(hostname -s)-xmonad.hs" ${HOME}/.xmonad/xmonad.hs
fi

# Put xmobarrc in place
if [ -L ${HOME}/.xmobarrc ];
then
  rm ${HOME}/.xmobarrc
  ln -s "${HOME}/.$(hostname -s)-xmobarrc" ${HOME}/.xmobarrc
fi

# (Re)compile xmonad if necessary
if [ ! -f ${HOME}/.xmonad/compile-hostname ];
then
  xmonad --recompile
  echo "$(hostname -s)" > ${HOME}/.xmonad/compile-hostname
else
  if [ ! "$(hostname -s)" = "$(cat ${HOME}/.xmonad/compile-hostname)" ];
  then
    xmonad --recompile
    echo "$(hostname -s)" > ${HOME}/.xmonad/compile-hostname
  fi
fi

# Let's go!
exec xmonad
