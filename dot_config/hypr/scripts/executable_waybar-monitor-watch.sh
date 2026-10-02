#!/usr/bin/env bash
# waybar-monitor-watch.sh
#
# Launch waybar, keep it alive, and keep it correct across monitor changes.
#
# Why (monitor changes): the two HDMI displays come up staggered at boot — the
# old LG E2210 (HDMI-A-1) finishes mode-setting later than the TERRA — and
# waybar reliably fails to attach a monitor that appears *after* it has already
# initialised, leaving the bar on only one screen. A fixed startup delay can't
# fix this (it's a race, not a constant offset). Instead we listen to Hyprland's
# event socket and restart waybar whenever a monitor is added or removed, which
# also handles live hotplug.
#
# Why (supervision): waybar is otherwise launched once and — before this — was
# only ever relaunched on a monitor add/remove event. So if waybar exited for
# ANY other reason (crash, Wayland hiccup, DPMS/monitor-sleep, stray kill) the
# bar simply vanished and stayed gone until the next monitor event, which looks
# exactly like "waybar keeps crashing". We now run waybar under a supervisor
# loop that respawns it whenever it exits.
#
# Waybar is *meant* to track outputs natively (it watches the Wayland output
# protocol), but loses sync with Hyprland's IPC on monitor changes — a known
# upstream bug, aggravated by the hyprland/* modules this config uses. SIGUSR2
# reload is the intended in-process refresh but is itself unreliable (incomplete
# reload / duplicate bars), so a full restart is the accepted workaround. Retire
# the monitor-watch half of this script if these are fixed upstream:
#   Waybar   #3975  https://github.com/Alexays/Waybar/issues/3975
#   Hyprland #8394  https://github.com/hyprwm/Hyprland/issues/8394

set -u

socket="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Supervisor: keep exactly one waybar alive. Because waybar runs in the
# foreground of this loop, the loop only ever relaunches after the current
# instance has fully exited — so there is never more than one bar, and no need
# to poll/wait for the old process to die. A resync (below) or a crash both just
# make waybar exit, and the loop respawns a fresh instance. The `sleep 1` throttles
# a persistently-failing waybar to one respawn per second instead of a hot spin.
supervise_waybar() {
	while :; do
		waybar
		sleep 1
	done
}

supervise_waybar &
disown

# Resync on monitor changes: just kill the running waybar. The supervisor then
# respawns a fresh instance that re-attaches every current output.
resync_waybar() {
	pkill -x waybar 2>/dev/null
}

# Without socat we can't watch events; the bar is already up (and supervised),
# there is just no monitor-change resync.
command -v socat >/dev/null 2>&1 || exit 0
[ -S "$socket" ] || exit 0

pending=
socat -u "UNIX-CONNECT:${socket}" - | while read -r line; do
	case "$line" in
	monitoradded* | monitorremoved*)
		# debounce bursts of events into a single resync
		[ -n "$pending" ] && kill "$pending" 2>/dev/null
		{
			sleep 1
			resync_waybar
		} &
		pending=$!
		;;
	esac
done
