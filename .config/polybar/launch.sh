#!/usr/bin/zsh

# Terminate already running instances
killall -q polybar

# Launch bar1
echo "---" | tee - /tmp/polybar.log
polybar example >>/tmp/polybar.log 2>&1 &
