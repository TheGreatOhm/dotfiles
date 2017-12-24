#!/bin/sh

ffmpeg -i "$1" -codec:a libmp3lame -q:a 0 "${1%.*}".mp3
