#!/bin/sh

IS_US_LAYOUT="$(setxkbmap -query | grep se | wc -l)"

if [ "$IS_US_LAYOUT" -eq 0 ];
then
	setxkbmap se
else
    setxkbmap us altgr-intl
fi
