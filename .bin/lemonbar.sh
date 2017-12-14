#!/bin/bash

###################
# Inital Settings #
###################

#colors and fonts
FONT1="xft:DejaVuSansMono:bold:size=11"
FONT2="fontawesome"
FG_COLOR="#bcbcbc"
BG_COLOR="#1c1c1c"
#UNFOCUSED_COLOR="#4f4f4f"
UNFOCUSED_COLOR="#505050"

#icons
battery_full=$(echo -n -e "\\uf240")
battery_75=$(echo -n -e "\\uf241")
battery_50=$(echo -n -e "\\uf242")
battery_25=$(echo -n -e "\\uf243")
bolt=$(echo -n -e "\\uf0e7")

#stop processes on kill
trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# remove old panel fifo, create new one
fifo="/tmp/panel_fifo"
[ -e "$fifo" ] && rm "$fifo"
mkfifo "$fifo"

###################
#     Applets     #
###################

workspaces() {
		output=""
		tag_status=($(herbstclient tag_status | sed 's/\t/\n/g' | sed '/^$/d'))
		for i in ${tag_status[@]}; do
				case "${i::1}" in
						"#")
								output+="%{R}"
								;;
						".")
								output+="%{F$UNFOCUSED_COLOR}"
								;;
				esac

				output+=" ${i:1} "
				output+="%{F-}%{B-}"
		done
		echo "w$output"
}

battery() {
		capacity=$(cat /sys/class/power_supply/BAT0/capacity)
		status="$(cat /sys/class/power_supply/BAT0/status)"
		output=""
		
		if [ "$status" = "Discharging" ]; then
				if [ $capacity -gt 75 ]; then
						output+="$battery_full"
				elif [ $capacity -gt 50 ]; then
						output+="$battery_75"
				elif [ $capacity -gt 25 ]; then
						output+="$battery_50"
				else
						output+="$battery_25"
				fi
		else
				output+="$bolt"
		fi

		output+=" $capacity% "
		echo "b$output"
}


clock() {
		echo "c$(date "+%H:%M  %a  %m-%d-%Y")"

}

#run each applet in subshell and output to fifo
while :; do workspaces; sleep 0.2s; done > "$fifo" &
while :; do battery; sleep 1m; done > "$fifo" &
while :; do clock; sleep 30s; done > "$fifo" &

#################
# Build the bar #
#################

while read -r line ; do
    case "${line::1}" in
        w)
            workspace_info="${line:1}"
            ;;
		b)
			battery_info="${line:1}"
			;;
        c)
            clock_info="${line:1}"
            ;;
    esac
	echo "%{c}$workspace_info%{r}$battery_info  |  $clock_info"
done < "$fifo" | /opt/bar/lemonbar -F "$FG_COLOR" -B "$BG_COLOR" -o 0 -f "$FONT1" -o -1 -f "$FONT2"
