#!/bin/sh

lemonbar_script="$HOME/.bin/lemonbar.sh"
if [ "$(pgrep "lemonbar" | sed -n '1p')" ];then
		killall "lemonbar"
		herbstclient pad 0 0
else
		herbstclient pad 0 20
		exec "$lemonbar_script"
fi
