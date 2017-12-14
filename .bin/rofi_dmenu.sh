#!/bin/sh

if [ -z "$1" ]; then
		echo "no dmenu list file specified"
		exit 1
fi

WIDTH=20
LINES=$(cat "$1" | wc -l)

choice=$(cut -d ";" -f 1 "$1" | rofi -dmenu -lines "$LINES" -width "$WIDTH")

#echo "choice is $choice"
if [ -n "$choice" ]; then
		#echo "$(grep "^$choice" "$1" | cut -d ";" -f 2-)"
		$(grep "^$choice" "$1" | cut -d ";" -f 2-)
fi
