#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}



#starting utility applications at boot time
#lxsession &
run nm-applet &
run pamac-tray &
numlockx on &
blueman-applet &
start-pulseaudio-x11 &
flameshot &
#picom --config $HOME/.config/picom/picom.conf &
picom --config $HOME/.config/awesome/scripts/picom.conf &
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dunst &
#feh --randomize --bg-fill /usr/share/wallpapers/garuda-wallpapers/*
feh --bg-fill $HOME/.config/awesome/themes/wallpapers/gruvbox/skull_gruvboxified.jpg --bg-fill $HOME/.config/awesome/themes/wallpapers/gruvbox/houses.jpg
#starting user applications at boot time
#run caffeine -a &
#run vivaldi-stable &
#run insync start &
conky -d
run brave &
run spotify &
run discord &

#run telegram-desktop &
