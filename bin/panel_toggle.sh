#!/bin/bash

lemonbar_script="$HOME/bin/lemonbar.sh"
monitors=($(herbstclient list_monitors | cut -d ':' -f '1'))
if [ "$(pgrep "lemonbar" | sed -n '1p')" ];then
    killall "lemonbar"
    for i in ${monitors[@]}; do
	herbstclient pad "$i" 0
    done
else
    for i in ${monitors[@]}; do
	herbstclient pad "$i" 20
    done
    exec "$lemonbar_script"
fi
