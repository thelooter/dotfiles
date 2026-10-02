#!/usr/bin/env bash
# Fixed-width network throughput for Waybar (custom/netspeed module).
# Emits one line every INTERVAL seconds. Each rate is rendered to a constant
# number of characters so the pill never reflows as throughput changes.
# Pair with a monospace/tabular font in style.css for constant *pixel* width.
#
# Icons:  (U+F063, down)  and  (U+F062, up) from FontAwesome.

INTERVAL=2
DOWN=$''
UP=$''

# Active default-route interface (empty when offline).
iface_of() { ip route 2>/dev/null | awk '/^default/ {print $5; exit}'; }

# rx,tx byte counters for an interface ("" if it is gone).
counters() { awk -v dev="$1:" '$1 == dev {print $2, $10}' /proc/net/dev; }

# bytes/sec -> fixed 7-char field, e.g. "   1.2K", " 123.4M".
human() {
	awk -v b="$1" 'BEGIN {
		u = "BKMGT"; i = 1
		while (b >= 1024 && i < 5) { b /= 1024; i++ }
		printf "%6.1f%s", b, substr(u, i, 1)
	}'
}

iface=$(iface_of)
read -r prx ptx <<<"$(counters "$iface")"

while true; do
	sleep "$INTERVAL"
	iface=$(iface_of)

	if [ -z "$iface" ]; then
		printf '%s %7s  %s %7s\n' "$DOWN" 'off' "$UP" 'off'
		prx=; ptx=
		continue
	fi

	read -r crx ctx <<<"$(counters "$iface")"
	# Need a previous sample (first run, or just reconnected) before we can rate.
	if [ -z "$prx" ] || [ -z "$crx" ]; then
		prx=$crx; ptx=$ctx
		continue
	fi

	dl=$(( (crx - prx) / INTERVAL ))
	ul=$(( (ctx - ptx) / INTERVAL ))
	[ "$dl" -lt 0 ] && dl=0
	[ "$ul" -lt 0 ] && ul=0

	printf '%s %s  %s %s\n' "$DOWN" "$(human "$dl")" "$UP" "$(human "$ul")"
	prx=$crx; ptx=$ctx
done
