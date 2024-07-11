#!/bin/sh

getforecast() {
    local city="$1"
    ping -q -c 1 1.1.1.1 >/dev/null || exit 1
    
    # Fetch weather data using wttr.in for the specified city
    curl -sf "wttr.in/${city}?format=%t+%C+%w" > "$HOME/.local/share/weatherreport" || exit 1
}

showweather() {
    weather=$(cat "$HOME/.local/share/weatherreport")
    printf "%s" "$weather"
}

# Prompt user for city name
prompt_city() {
    echo "Enter your city name:"
    read city
}

case $BLOCK_BUTTON in
    1) $TERMINAL -e less -S "$HOME/.local/share/weatherreport" ;;
    2) prompt_city && getforecast "$city" && showweather ;;
    3) pgrep -x dunst >/dev/null && notify-send "🌈 Weather module" "\- Left click for full forecast.
- Middle click to update forecast." ;;
esac

# Update weather data if file doesn't exist or it's older than today
if [ ! -f "$HOME/.local/share/weatherreport" ] || [ "$(stat -c %y "$HOME/.local/share/weatherreport" | awk '{print $1}')" != "$(date '+%Y-%m-%d')" ]; then
    prompt_city
    getforecast "$city"
fi

# Always show weather
showweather
