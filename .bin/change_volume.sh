#!/bin/sh

if [ -z "$1" ]; then
		echo "No argument given. Argument should the increment by which volume of current sink will be changed. Of the form {+|-}X% example: +5%"
		exit 1
fi
current_sink="$(pacmd list-sinks | grep '*' | awk '{print $NF}')"
echo "$current_sink"

pactl set-sink-mute "$current_sink" 0
pactl set-sink-volume "$current_sink" "$1"
