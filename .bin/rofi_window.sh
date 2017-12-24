#!/bin/sh

rofi -show window -lines $(herbstclient attr clients | sed -n '/children/,/^$/p' | sed '/children/d;/focus/d;/^$/d' | wc -l)
