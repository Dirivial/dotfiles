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
feh --randomize --bg-fill $HOME/Pictures/wall/gruvbox/*
#starting user applications at boot time
#run caffeine -a &
#run vivaldi-stable &
run brave &
#run thunar &
#run insync start &
run spotify &
run discord &
#run telegram-desktop &
