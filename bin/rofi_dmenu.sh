#!/bin/sh

if [ -z "$1" ]; then
		echo "no dmenu list file specified"
		exit 1
fi

width=20
lines=$(cat "$1" | wc -l)
prompt=""

choice=$(cut -d ";" -f 1 "$1" | rofi -p "$prompt" -dmenu -lines "$lines" -width "$width")

#echo "choice is $choice"
if [ -n "$choice" ]; then
		#echo "$(grep "^$choice" "$1" | cut -d ";" -f 2-)"
    command="$(grep "^$choice" "$1" | cut -d ";" -f 2-)"
    exec $command
fi
