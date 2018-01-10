#!/bin/bash

current_sink="$(pacmd list-sinks | grep '*' | awk '{print $NF}')"
available_sinks=($(pacmd list-sinks | grep "index" | awk '{print $NF}'))
available_sink_inputs=($(pacmd list-sink-inputs | grep "index" | awk '{print $NF}'))
index=0

for i in "${available_sinks[@]}"; do
    if [ $i -eq $current_sink ]; then
	break
    else
	index=$(( $index + 1 ))
    fi
done

if [ $(( $index + 1 )) -eq ${#available_sinks[@]} ]; then
    index=0
else
    index=$(( $index + 1 ))
fi

new_sink="${available_sinks[$index]}"
pacmd set-default-sink "$new_sink"
for i in "${available_sink_inputs[@]}"; do
    pacmd move-sink-input "$i" "$new_sink" 
done
