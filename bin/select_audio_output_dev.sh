#!/bin/bash

sink_indexes=($(pacmd list-sinks | grep "index" | awk '{print $NF}'))
mapfile sink_names < <(pacmd list-sinks | grep 'device.description' | cut -d '"' -f '2')
current_sink_name="$(pacmd list-sinks | sed -n '/\*/,$p' | sed -n '/device.description/p' | head -n 1 | cut -d '"' -f '2')"
sink_inputs=($(pacmd list-sink-inputs | grep "index" | awk '{print $NF}'))

choice="$(echo -n "${sink_names[@]}" | sed "s/$current_sink_name/[*] $current_sink_name/" | sed 's/^ //' | rofi -p "" -dmenu)"
if [ -z "$choice" ]; then
    exit 1
fi

choice="$(echo -n "$choice" | sed 's/\[\*\] //')"

index=0
for name in "${sink_names[@]}"; do
    if [ "$choice" = "$(echo "$name" | tr -d '\n')" ]; then
	break
    else
	index=$(( $index + 1 ))
    fi
done

new_sink="${sink_indexes[$index]}"
pacmd set-default-sink "$new_sink"
for i in "${sink_inputs[@]}"; do
    pacmd move-sink-input "$i" "$new_sink" 
done
