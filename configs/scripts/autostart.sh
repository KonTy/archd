#!/usr/bin/env bash

function setup_firewall() {
    # Set default policies
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    # Allow SSH
    sudo ufw allow ssh

    # Allow HTTP and HTTPS for web servers
    # sudo ufw allow 80
    # sudo ufw allow 443

    # Enable UFW
    sudo ufw enable
    sudo ufw start
    sudo ufw status
}


pkill picom
pkill eww
ps -aux | grep bar | grep -v grep | grep dwm | awk '{print $2}' | while read -r line; do kill -9 $line; done

xrdb merge $HOME/.Xresources
picom --config=./picom.conf -b
# feh --bg-scale $HOME/.config/dwm/wallpaper.jpg
# $HOME/.config/dwm/scripts/bar.sh
#eww -c $HOME/.config/dwm/eww daemon
dwmblocks
