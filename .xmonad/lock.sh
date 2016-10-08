#!/bin/bash

sleep 1 && xset dpms force off &

if [ -x /usr/bin/cinnamon-screensaver-command ];
then
  /usr/bin/cinnamon-screensaver-command -la
else
  /usr/bin/xtrlock
fi
