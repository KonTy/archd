#!/bin/sh

case $BLOCK_BUTTON in
	1) $TERMINAL -e nmtui ;;
	3) pgrep -x dunst >/dev/null && notify-send "🌐 Internet module" "\- Click to connect
📡: no wifi connection
📶: wifi connection with quality
❎: no ethernet
🌐: ethernet working
" ;;
esac

[ "$(cat /sys/class/net/w*/operstate)" = 'down' ] && wifiicon="📡"

[ ! -n "${wifiicon+var}" ] && wifiicon=$(grep "^\s*w" /proc/net/wireless | awk '{ print "📶", int($3 * 100 / 70) "%" }')

printf "%s %s\n" "$wifiicon" "$(cat /sys/class/net/e*/operstate | sed "s/down/❎/;s/up/🌐/")"