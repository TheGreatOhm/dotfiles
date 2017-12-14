#!/bin/sh

current_sink="$(pacmd list-sinks | grep '*' | awk '{print $NF}')"
is_muted="$(pacmd list-sinks | sed -n '/\*/,$p' | grep -m 1 "muted" | awk '{print $NF}')"

if [ "$is_muted" = "yes" ]; then
	pactl set-sink-mute "$current_sink" 0
else
	pactl set-sink-mute "$current_sink" 1
fi
