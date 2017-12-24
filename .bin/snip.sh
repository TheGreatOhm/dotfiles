#!/bin/sh

sleep 0.2
notify-send 'Snip mode active.'
scrot -s -e 'mv $f ~/images/screenshots/; notify-send "Screenshot $f"'
