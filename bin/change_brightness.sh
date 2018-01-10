#!/bin/bash

backlight_dir="/sys/class/backlight/intel_backlight"
current_brightness=$(cat $backlight_dir/brightness)
max_brightness=$(cat $backlight_dir/max_brightness)

if [ -z "$1" ]; then
		echo "No argument given"
		exit 1
fi

new_brightness=$(( $current_brightness $1 ))
if [ $new_brightness -lt 51 ]; then
		new_brightness=50
elif [ $new_brightness -gt $max_brightness ]; then
		new_brightness=$max_brightness
fi
echo "$new_brightness" > "$backlight_dir/brightness"
