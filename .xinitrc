#!/bin/sh

# /etc/X11/xinit/xinitrc
#

# merge .Xresources
xrdb -merge $HOME/.Xresources

# use .Xmodmap, set caps lock to control
xmodmap $HOME/.Xmodmap

# Set a random wallpaper
feh --bg-scale --randomize --no-fehbg ~/images/wallpapers/* &

# set screen temperature with redshift
redshift -O 5000 &

# start emacs daemon
emacs --daemon &

# start herbstluftwm
exec herbstluftwm --locked
