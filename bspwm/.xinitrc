#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# setxkbmap -layout us,us,ru -variant dvorak,dvp, -option grp:alt_shift_toggle
setxkbmap -layout us -variant dvp
-e "keycode 135 = Menu"
xmodmap -e "keysym Menu = Super_R"

xsetroot -cursor_name left_ptr
hsetroot -center ~/images/arch-bg-01.png

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

~/scripts/java_nonreparenting_wm_hack.sh &
sxhkd &
exec bspwm
