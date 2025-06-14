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
vesktop &
streamcontroller -b &

if [ "$(pgrep -x obsidian)" = "" ]; then
	obsidian &
fi
flameshot &
ferdium &
otd-daemon &
conky -c "$HOME/.config/conky/frappe.conf"
morgen
