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

clock() {
		echo "c$(date "+%H:%M  %a  %m-%d-%Y")"

}

#run each applet in subshell and output to fifo
while :; do workspaces; sleep 0.2s; done > "$fifo" &
#while :; do media; mpc idle player; done > "$fifo" &
#while :; do pacheck; sleep 60m; done > "$fifo" &
#while :; do volume; sleep 0.5s; done > "$fifo" &
while :; do clock; sleep 30s; done > "$fifo" &
#while :; do launcher; break; done > "$fifo" &

#################
# Build the bar #
#################

while read -r line ; do
    case "${line::1}" in
        w)
            workspace_info="${line:1}"
            ;;
        c)
            clock_info="${line:1}"
            ;;
    esac
	echo "%{c}$workspace_info%{r}$clock_info"
done < "$fifo" | /opt/bar/lemonbar -F "$FG_COLOR" -B "$BG_COLOR" -o 0 -f "$FONT1" -o -2 -f "$FONT2"
