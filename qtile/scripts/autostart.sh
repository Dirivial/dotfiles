#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}



#starting utility applications at boot time
lxsession &
run nm-applet &
run pamac-tray &
numlockx on &
blueman-applet &
#flameshot &
picom --config $HOME/.config/picom/picom.conf &
#picom --config .config/picom/picom-blur.conf --experimental-backends &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dunst &
#feh --randomize --bg-fill /usr/share/wallpapers/garuda-wallpapers/*
feh --randomize --bg-fill ~alch/Pictures/wall/gruvbox/*
#starting user applications at boot time
run volumeicon &
#nitrogen --random --set-zoom-fill &
#run caffeine -a &
#run vivaldi-stable &
run firedragon &
#run thunar &
#run dropbox &
#run insync start &
run spotify &
run discord &
run ~alch/.screenlayout/dp_primary.sh &
#run atom &
#run telegram-desktop &

/usr/bin/emacs --daemon &
