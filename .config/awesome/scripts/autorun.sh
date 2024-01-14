#!/bin/bash
killall -q picom
picom -b

killall -q polybar

if type "xrandr"; then
	for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
		MONITOR=$m polybar --reload &
	done
else
	polybar --reload &
fi

keepassxc &
discord &
streamdeck -n &
obsidian &
thunderbird
