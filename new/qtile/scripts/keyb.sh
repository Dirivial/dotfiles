#!/bin/sh

IS_US_LAYOUT="$(setxkbmap -query | grep us | wc -l)"

if [ "$IS_US_LAYOUT" -eq 0 ];
then
	setxkbmap us
else
	setxkbmap se
fi
