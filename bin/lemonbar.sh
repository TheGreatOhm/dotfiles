
#!/bin/bash

###################
# Inital Settings #
###################

#colors and fonts
FONT1="xft:DejaVuSansMono:bold:size=11"
FONT2="fontawesome"
FONT3="fontawesome:size=9"
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
wifi_icon=$(echo -n -e "\\uf1eb")
power_off=$(echo -n -e "\\uf011")
bars=$(echo -n -e "\\uf0c9")
play=$(echo -n -e "\\uf04b")
pause=$(echo -n -e "\\uf04c")
backward=$(echo -n -e "\\uf04a")
forward=$(echo -n -e "\\uf04e")

#stop processes on kill
trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# remove old panel fifo, create new one
fifo="/tmp/panel_fifo"
[ -e "$fifo" ] && rm "$fifo"
mkfifo "$fifo"

### Static Content

power_button="%{A:rofi_dmenu.sh ~/.config/rofi/dmenu-system.list:}$power_off%{A}"
launch_menu="%{A:rofi_dmenu.sh ~/.config/rofi/dmenu-favorites.list:}$bars%{A}"

###################
#     Applets     #
###################

cmus_music() {
    char_limit=50
    output=""

    if [ "x$(pgrep cmus)" != 'x' ]; then
	cmus_status=$(cmus-remote -Q)
	playing_status="$( echo -n "$cmus_status" | grep '^status ' | cut -d ' ' -f '2')"
	if [ "$playing_status" != "stopped" ]; then
	    artist="$( echo -n "$cmus_status" | grep '^tag artist ' | cut -d ' ' -f '3-')"
	    song_title="$( echo -n "$cmus_status" | grep '^tag title' | cut -d ' ' -f '3-')"
	    duration="$( echo -n "$cmus_status" | grep '^duration ' | cut -d ' ' -f '2')"
	    position="$( echo -n "$cmus_status" | grep '^position ' | cut -d ' ' -f '2')"

	    duration_min=$(( $duration / 60 ))
	    duration_sec=$(( $duration % 60 ))
	    if [ $duration_sec -lt 10 ]; then
		duration_sec="0$duration_sec"
	    fi
	    position_min=$(( $position / 60 ))
	    position_sec=$(( $position % 60 ))
	    if [ $position_sec -lt 10 ]; then
		position_sec="0$position_sec"
	    fi

	    output+="%{T3}"
	    output+="%{A:cmus-remote -r:}$backward%{A}  "
	    if [ "$playing_status" = "playing" ]; then
		output+="%{A:cmus-remote -u:}$pause%{A}  "
	    else
		output+="%{A:cmus-remote -u:}$play%{A}  "
	    fi

	    output+="%{A:cmus-remote -n:}$forward%{A}   "
	    output+="%{T-}"
	    output+="$position_min:$position_sec / $duration_min:$duration_sec   "

	    artist_and_title="$artist - $song_title"
	    if [ ${#artist_and_title} -gt $char_limit ]; then
		artist_and_title="${artist_and_title:0:$char_limit}..."
	    fi
	    output+="$artist_and_title"
	else
	    output+="%{F$UNFOCUSED_COLOR}(cmus stopped)%{F-}"
	fi
    else
	output+=" "
    fi

    echo "m$output"
}

workspaces() {
    output=""
    tag_status=($(herbstclient tag_status | sed 's/\t/\n/g' | sed '/^$/d'))
    index=0
    for i in ${tag_status[@]}; do
	# output+="%{A:rofi_window.sh:}"
	case "${i::1}" in
	    "#")
		output+="%{R}"
		;;
	    ".")
		output+="%{F$UNFOCUSED_COLOR}"
		;;
	esac
	
	output+="%{A:herbstclient use_index $index:}"
	output+=" ${i:1} "
	output+="%{F-}%{B-}%{A}"

	index=$(( $index + 1 ))
    done
    echo "w$output"
}

wifi() {
    output=""
    essid="$(sudo iw dev wlp4s0 link | grep "SSID" | awk '{print $NF}')"

    if [ -z "$essid" ]; then
	output+="%{F$UNFOCUSED_COLOR}$wifi_icon [NONE]%{F-}"
    else
        output+="$wifi_icon $essid"
    fi
    echo "i$output"
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

    output+=" $capacity%"
    echo "b$output"
}


clock() {
    echo "c$(date "+%H:%M  %a  %m-%d-%Y")"

}

#run each applet in subshell and output to fifo
while :; do cmus_music; sleep 1s; done > "$fifo" &
while :; do workspaces; sleep 0.2s; done > "$fifo" &
while :; do battery; sleep 1m; done > "$fifo" &
while :; do clock; sleep 30s; done > "$fifo" &
while :; do wifi; sleep 30s; done > "$fifo" &

#################
# Build the bar #
#################

monitors=($(herbstclient list_monitors | cut -d ':' -f '1'))

while read -r line ; do
    case "${line::1}" in
	m)
	    cmus_music_info="${line:1}"
	    ;;
        w)
            workspace_info="${line:1}"
            ;;
	i)
	    wifi_info="${line:1}"
	    ;;
	b)
	    battery_info="${line:1}"
	    ;;
        c)
            clock_info="${line:1}"
            ;;
    esac
    final_output=""
    for i in ${monitors[@]}; do
	final_output+="%{S$i}%{l} $power_button  |  $launch_menu%{O100}$cmus_music_info%{c}$workspace_info%{r}$wifi_info  |  $battery_info  |  $clock_info "
    done
    echo "$final_output"
done < "$fifo" | /opt/bar/lemonbar -a 30 -F "$FG_COLOR" -B "$BG_COLOR" -o 0 -f "$FONT1" -o -1 -f "$FONT2" -o -3 -f "$FONT3" | sh
