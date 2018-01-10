#!/bin/sh

# /etc/X11/xinit/xinitrc
#

# merge .Xresources
xrdb -merge $HOME/.Xresources

# use .Xmodmap, set caps lock to control
xmodmap $HOME/.Xmodmap

# disable screen turn off from inactivity
xset s off
xset -dpms

# start udiskie for automounting
udiskie &

# toggle numlock to on
numlockx &

# Set a random wallpaper
feh --bg-scale --randomize --no-fehbg ~/images/wallpapers/* &

# set screen temperature with redshift
redshift -O 5000 -b 0.6 &

# start emacs daemon
emacs --daemon &

# start notification daemon dunst
dunst -conf $HOME/.config/dunst/dunstrc.example &

# start herbstluftwm
exec herbstluftwm --locked
