#! /bin/sh

chosen=$(printf "  Power Off\n  Restart\n  Lock" | rofi -dmenu -i)

case "$chosen" in
	"  Power Off") sudo poweroff ;;
	"  Restart") reboot ;;
	"  Lock") xlock -size 50 -count 100 -mode swarm ;;
	*) exit 1 ;;
esac
