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

xsetroot -cursor_name left_ptr
#setxkbmap -variant dvorak
setxkbmap -layout "us,ru" -variant "dvorak," -option "grp:caps_toggle,grp_led:scroll"

-e "keycode 135 = Menu"
xmodmap -e "keysym Menu = Super_R"

feh --bg-center ~/Pictures/The_Ocean_Above_Us_by_MangoSango.jpg &

xmobar &

export _volume_pipe=/tmp/.volume-pipe
[[ -S $_volume_pipe ]] || mkfifo $_volume_pipe
nohup /bin/sh -c "while true;do ~/.xmonad/getvolume.sh > /tmp/.volume-pipe;sleep 5;done" &

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
exec xmonad
