#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xset s off
(sleep 0; setxkbmap -model pc104 -layout us,ar -option grp:alt_shift_toggle) &
(sleep 0; xfce4-panel) &
(sleep 0; nitrogen --restore) &
(sleep 0; cbatticon) &
(sleep 0; compton) &
(sleep 1; tilda -g /home/raabdela/.config/tilda/config_0) &
(sleep 1; tilda -g /home/raabdela/.config/tilda/config_1) &
(sleep 1; tilda -g /home/raabdela/.config/tilda/config_2) &
(sleep 1; tilda -g /home/raabdela/.config/tilda/config_3) &
(sleep 1; conky -c /home/raabdela/.config/conkyconf/conky.conf) &

exec openbox
