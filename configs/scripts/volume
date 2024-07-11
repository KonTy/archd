#!/bin/bash

get_volume() {
    pamixer --get-volume
}

get_mic_volume() {
    pamixer --default-source --get-volume
}

get_icon() {
    local volume=$(get_volume)
    local mute=$(pamixer --get-mute)
    
    if [ "$mute" = "true" ]; then
        echo ""  # Mute icon
    elif [ "$volume" -eq 0 ]; then
        echo ""  # Mute icon
    elif [ "$volume" -lt 33 ]; then
        echo ""  # Low volume icon
    elif [ "$volume" -lt 67 ]; then
        echo ""  # Medium volume icon
    else
        echo ""  # High volume icon
    fi
}

get_mic_icon() {
    local volume=$(get_mic_volume)
    local mute=$(pamixer --default-source --get-mute)
    
    if [ "$mute" = "true" ]; then
        echo ""  # Mic mute icon
    elif [ "$volume" -eq 0 ]; then
        echo ""  # Mic mute icon
    elif [ "$volume" -lt 33 ]; then
        echo ""  # Mic low volume icon
    elif [ "$volume" -lt 67 ]; then
        echo ""  # Mic medium volume icon
    else
        echo ""  # Mic high volume icon
    fi
}

# Handle different actions based on arguments
case "$1" in
    --getvolume)
        get_volume
        ;;
    --getmicvolume)
        get_mic_volume
        ;;
    --geticon)
        get_icon
        ;;
    --getmicicon)
        get_mic_icon
        ;;
    --inc)
        pamixer --increase 5
        pkill -RTMIN+10 dwmblocks
        ;;
    --dec)
        pamixer --decrease 5
        pkill -RTMIN+10 dwmblocks
        ;;
    --toggle)
        pamixer --toggle-mute
        pkill -RTMIN+10 dwmblocks
        ;;
    --incmic)
        pamixer --default-source --increase 5
        pkill -RTMIN+11 dwmblocks
        ;;
    --decmic)
        pamixer --default-source --decrease 5
        pkill -RTMIN+11 dwmblocks
        ;;
    --togglemic)
        pamixer --default-source --toggle-mute
        pkill -RTMIN+11 dwmblocks
        ;;
    *)
        # Handle mouse click actions
        case "$1" in
            1)  # Left click (volume)
                pavucontrol    # Launch PulseAudio control panel
                ;;
            3)  # Right click (mic)
                pamixer --default-source --toggle-mute
                pkill -RTMIN+11 dwmblocks
                ;;
            4)  # Right click (volume)
                pamixer --toggle-mute
                pkill -RTMIN+10 dwmblocks
                ;;
        esac
        ;;
esac
