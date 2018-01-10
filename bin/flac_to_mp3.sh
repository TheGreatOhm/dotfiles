#!/bin/sh

album_name=$(metaflac --export-tags=- "$1"  | grep -i "album=" | cut -d '=' -f '2-')
track_date=$(metaflac --export-tags=- "$1"  | grep -i "date=" | cut -d '=' -f '2-')
target_dir="($track_date) - $album_name [mp3]"
if [ ! -d "$target_dir" ];then
    mkdir "$target_dir"
fi

echo "Converting $1 to mp3"
ffmpeg -i "$1" -codec:a libmp3lame -q:a 0 -map_metadata 0 -id3v2_version 3 "$target_dir/${1%.*}.mp3"
