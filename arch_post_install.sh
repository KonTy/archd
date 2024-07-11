# Check if the script is run with sudo
# if [ "$EUID" -ne 0 ]; then
#   echo "Please run as root"
#   sudo "$0" "$@"
#   exit
# fi

# Change to the directory where this script is located
cd "$(dirname "$0")"


#notes
# sudo pacman -S rofi



# TODO: how to make brave dark?
# Install https://framagit.org/Daguhh/naivecalendar
# How to lock system with win+L
# how to control volume and brigtness
#how to show wifi and bluetooth and airplane mode
# how to auto mount usb
# how to change SDDM to dark theme
# set background
# how to show windows title
# invoke hybernation
# set computer so it goes to sleep hybernaes after some time
# set background swww img ~/.config/configs/backgrounds/$VER'-background-dark.jpg'
# auto detect surface 
# auto detect and install intel video
# auto detect and install amd video
# test screen sharing with teams and obs
# test screen capture
# figure out hyprv.conf local how to set and how it works
# figure out how to switch keyboards by keypress


# Example: Create a swap file for hibernation
# fallocate -l 2G /swapfile
# chmod 600 /swapfile
# mkswap /swapfile
# swapon /swapfile
# echo '/swapfile none swap defaults 0 0' | tee -a /etc/fstab
# echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet resume=/dev/mapper/$(lsblk -no UUID $DEVICE-crypt)"' | tee -a /etc/default/grub
# grub-mkconfig -o /boot/grub/grub.cfg



# https://github.com/bakkeby/dwm-flexipatch

ISNVIDIA=false

# https://wiki.hyprland.org/Useful-Utilities/Must-have/
# for XDPH doesn’t implement a file picker. For that, I recommend installing xdg-desktop-portal-gtk alongside XDPH.
# The most basic way of seeing if everything is OK is by trying to screenshare anything, or by opening OBS and selecting the PipeWire source. If XDPH is running, a Qt menu will pop up asking you what to share.
declare -A prep_stage=(
    [base-devel]="Base development tools"
    [git]="Version control system"
    [libxext]="This library is for window effects for DWM"
    [libxrandr]="Provides an X Window System extension for dynamic resizing and rotation of X screen"
    [ttf-jetbrains-mono-nerd]="JetBrains Mono Nerd Font"
    [ttf-font-awesome]="Font awesome"
    [ttf-dejavu]="Dejavu fonts"
    [noto-fonts-emoji]="Google Noto emoji fonts"
    [gvfs]="GNOME Virtual File System support for NTFS and other file systems"
    [xorg-server]="Xorg Server"
    [sddm]="Display Manager"
    [rofi]="A window switcher, application launcher, and dmenu replacement for X11."
    [alacritty]="Terminal Emulator"
    [xautolock]="Autolocking app"
    [xclip]="Command-line interface to X selections"
    [xsel]="Command-line tool to access X clipboard and selection buffers"
    [libxinerama]="X11 Xinerama extension library"
    [xorg-server]="X.Org X server"
    [xorg-xinit]="X.Org initialization program"
    [xorg-xrandr]="X.Org XRandR extension library"
    [xorg-xsetroot]="X.Org utility to set the root window properties"
    [feh]="Background setter for dwm"
    [picom-ftlabs-git]="Windows effects and animations, fork of picom with animations"
    [dmenu]="Dynamic Menu"
    [networkmanager]="Network Manager"
)

declare -A audio_stage=(
    [pipewire]="Multimedia server"
    [wireplumber]="PipeWire session manager"
    [pipewire-alsa]="ALSA support for PipeWire"
    [pipewire-jack]="JACK support for PipeWire"
    [pipewire-pulse]="PulseAudio support for PipeWire"
    [alsa-utils]="ALSA utilities"
    [helvum]="GTK patchbay for PipeWire"
    [pamixer]="Pulseaudio command-line mixer like amixer"
    [pavucontrol]="PulseAudio Volume Control"
)

#software for nvidia GPU
declare -A nvidia_stage=(
    [linux-headers]="Header files and scripts for building modules for the Linux kernel"
    [nvidia-dkms]="NVIDIA driver with DKMS support"
    [nvidia-settings]="NVIDIA driver settings utility"
    [libva]="Video Acceleration (VA) API for Linux"
    [libva-nvidia-driver-git]="VA-API implementation for NVIDIA driver"
)

#the main packages
declare -A install_stage=(
    [sddm]="Simple Desktop Display Manager"
    [kitty]="A fast, feature-rich, GPU-based terminal emulator"
    [starship]="Cross-shell prompt for astronauts"
    [mc]="Midnight commander terminal file manager"
    [thunderbird]="Email client from Mozilla"
    [brave-bin]="Brave browser"
    [mpv]="Media player"
    [fastfetch]="Show system info"
)

declare -A optional_stage=(

        [Dunst]="notification service"
    [gtk2-engines-murrine]="GTK+ theme tools for custom theme support "
    [papirus-icon-theme]="Icon theme for Linux"
    [lxappearance]="GTK+ theme switcher"
    [xfce4-settings]="Settings manager for Xfce"
    [nwg-look-bin]="GTK3 settings editor for wlroots-based compositors"
    [ardour]="Digital audio workstation"    
    [davinci-resolve-studio]="Professional video editing software"
    [firefox]="Web browser from Mozilla"
)

# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

######

function compile_app() {
    app_name=$1
    RED='\033[0;31m'
    NC='\033[0m' # No Color

    if [ -z "$app_name" ]; then
        echo -e "${RED}[ERROR] No application name provided.${NC}"
        exit 1
    fi

    # Change to the application directory
    cd ./"$app_name" || { echo -e "${RED}[ERROR] ./$app_name directory not found.${NC}"; exit 1; }

    # Compile the application
    sudo make clean install || { echo -e "${RED}[ERROR] Compilation failed.${NC}"; exit 1; }

    # Get current time in seconds since Epoch
    current_time=$(date +%s)

    # Get modification time of the application binary
    echo "Checking $app_name in /usr/local/bin/$app_name"
    app_modification_time=$(stat -c %Y /usr/local/bin/"$app_name") || { echo -e "${RED}[ERROR] Could not get modification time.${NC}"; exit 1; }

    # Calculate the difference in seconds
    time_diff=$((current_time - app_modification_time))

    # Check if the application was compiled in the last 3 minutes (180 seconds)
    if [ $time_diff -le 180 ]; then
        echo "$app_name was compiled within the last 3 minutes."
    else
        echo "$app_name was not compiled recently."
    fi

    # Optionally restart the display manager (commented out)
    # sudo systemctl restart display-manager

    # Change back to the original directory
    cd - >/dev/null || exit

    echo "$app_name compiled and installed successfully."
}

function setup_backgrounds() {
    # Path to your background images directory
    backgrounds_dir="$HOME/.config/configs/backgrounds"
    
    # Check if ~/.xprofile exists and if background setting section exists
    if [ -f "$HOME/.xprofile" ]; then
        if ! grep -q "set-background.sh" "$HOME/.xprofile"; then
            # Append call to set-background.sh in ~/.xprofile
            echo >> "$HOME/.xprofile"
            echo "# Set background based on current desktop tag" >> "$HOME/.xprofile"
            echo "/bin/bash $HOME/.config/configs/scripts/set-background.sh 1 &" >> "$HOME/.xprofile"
            
            echo "Background setup completed. Please restart your X session to apply changes."
        else
            echo "Background setup already exists in ~/.xprofile. No changes made."
        fi
    else
        # Create ~/.xprofile and add background setting section
        echo "# Set background based on current desktop tag" > "$HOME/.xprofile"
        echo "/bin/bash $HOME/.config/configs/scripts/set-background.sh 1 &" >> "$HOME/.xprofile"
        
        echo "Background setup completed. Please restart your X session to apply changes."
    fi
}

function add_dwm_to_sddm() {
    # Check if dwm.desktop file already exists
    if [ ! -f /usr/share/xsessions/dwm.desktop ]; then
        # Create the dwm.desktop file
        sudo bash -c 'cat > /usr/share/xsessions/dwm.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=DWM
Comment=Dynamic Window Manager
Exec=dwm
Icon=dwm
Type=XSession
EOF'
        echo "Created /usr/share/xsessions/dwm.desktop."
    else
        echo "/usr/share/xsessions/dwm.desktop already exists."
    fi

    # Ensure that dwm is in the PATH
    if ! command -v dwm &> /dev/null; then
        echo "dwm is not in your PATH. Please ensure dwm is installed and available in your PATH."
        return 1
    fi

    # Create ~/.xprofile file with dwm if it does not exist
    if [ ! -f ~/.xprofile ]; then
        cat > ~/.xprofile << EOF
#!/bin/sh
exec dwm
EOF
        chmod +x ~/.xprofile
        echo "Created ~/.xprofile with exec dwm."
    else
        if ! grep -q "exec dwm" ~/.xprofile; then
            echo "exec dwm" >> ~/.xprofile
            echo "Appended exec dwm to ~/.xprofile."
        else
            echo "~/.xprofile already contains exec dwm."
        fi
    fi
    
    echo "dwm has been added as an option to SDDM."
    echo "You can now select dwm from the session list on the SDDM login screen."
}

function setup_dark_theme() {
    # Environment Variables
    PROFILE_FILE="$HOME/.profile"
    XPROFILE_FILE="$HOME/.xprofile"
    
    # GTK Settings
    GTK3_SETTINGS_FILE="$HOME/.config/gtk-3.0/settings.ini"
    GTK4_SETTINGS_FILE="$HOME/.config/gtk-4.0/settings.ini"
    GTK_THEME="Matrix_OLED"
    
    # Qt Settings
    QT5CT_CONFIG_FILE="$HOME/.config/qt5ct/qt5ct.conf"
    
    # Add environment variables to .profile and .xprofile
    for file in "$PROFILE_FILE" "$XPROFILE_FILE"; do
        grep -qxF "export GTK_THEME=$GTK_THEME" "$file" || echo "export GTK_THEME=$GTK_THEME" >> "$file"
        grep -qxF "export QT_QPA_PLATFORMTHEME=qt5ct" "$file" || echo "export QT_QPA_PLATFORMTHEME=qt5ct" >> "$file"
        grep -qxF "export QT_STYLE_OVERRIDE=$GTK_THEME" "$file" || echo "export QT_STYLE_OVERRIDE=$GTK_THEME" >> "$file"
        grep -qxF "export XDG_CURRENT_DESKTOP=Unity:Unity7:GNOME" "$file" || echo "export XDG_CURRENT_DESKTOP=Unity:Unity7:GNOME" >> "$file"
    done
    
    # GTK Settings
    mkdir -p "$HOME/.config/gtk-3.0"
    mkdir -p "$HOME/.config/gtk-4.0"
    
    echo -e "[Settings]\ngtk-application-prefer-dark-theme=1\ngtk-theme-name=$GTK_THEME" > "$GTK3_SETTINGS_FILE"
    echo -e "[Settings]\ngtk-application-prefer-dark-theme=1\ngtk-theme-name=$GTK_THEME" > "$GTK4_SETTINGS_FILE"
    
    # Qt Settings
    mkdir -p "$(dirname "$QT5CT_CONFIG_FILE")"
    if [ ! -f "$QT5CT_CONFIG_FILE" ]; then
        echo -e "[Appearance]\nstyle=$GTK_THEME" > "$QT5CT_CONFIG_FILE"
    else
        sed -i "s/^style=.*/style=$GTK_THEME/" "$QT5CT_CONFIG_FILE"
    fi
    
    # Call function to install custom GTK theme
    install_custom_theme
    
    echo "Dark theme setup completed. Please log out and log back in to apply the changes."
}

function install_custom_theme() {
    THEME_NAME="Matrix_OLED"
    THEME_DIR="$HOME/.themes/$THEME_NAME"
    CONFIGS_DIR="$HOME/.config/configs/gtk"

    # Create directories for GTK themes
    mkdir -p "$THEME_DIR/gtk-3.0"
    mkdir -p "$THEME_DIR/gtk-4.0"
    mkdir -p "$THEME_DIR/gtk-2.0"

    # Copy gtk30.css to GTK3 directory
    cp -f "$CONFIGS_DIR/gtk30.css" "$THEME_DIR/gtk-3.0/gtk.css"

    # Copy gtk40.css to GTK4 directory
    cp -f "$CONFIGS_DIR/gtk40.css" "$THEME_DIR/gtk-4.0/gtk.css"

    # Copy gtkrc20 to GTK2 directory
    cp -f "$CONFIGS_DIR/gtkrc20" "$THEME_DIR/gtk-2.0/gtkrc"

    # Create directories for GTK settings
    mkdir -p "$HOME/.config/gtk-3.0"
    mkdir -p "$HOME/.config/gtk-4.0"

    # Copy settings.ini to GTK3 settings directory
    cp -f "$CONFIGS_DIR/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"

    # Copy settings.ini to GTK4 settings directory
    cp -f "$CONFIGS_DIR/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"

    # Set GTK_THEME environment variable
    echo "export GTK_THEME=$THEME_NAME" >> "$HOME/.profile"
    echo "export GTK_THEME=$THEME_NAME" >> "$HOME/.bashrc" # or ~/.zshrc, depending on your shell

    echo "Created and applied the $THEME_NAME theme."
}

function add_if_not_exists() {
    local line="$1"
    local file="$2"
    
    # Check if the file contains the line
    if ! grep -Fxq "$line" "$file"; then
        # If not, add the line to the file
        echo -e "\n$line" >> "$file"
        echo "Added '$line' to $file"
    else
        echo "Line '$line' already exists in $file"
    fi
}

# function that would show a progress bar to the user
function show_progress() {
    while ps | grep $1 &> /dev/null;
    do
        echo -n "."
        sleep 2
    done
    echo -en "Done!\n"
    sleep 2
}

function install_software() {
    declare -n packages=$1  # Use nameref to reference the dictionary passed as argument
    packages_to_install=""
    
    for package in "${!packages[@]}"; do
        packages_to_install+="$package "
        # Print package description
        echo "Installing $package - ${packages[$package]}"
    done
    
    # Install all packages at once, only if they are not already installed
    if [ -n "$packages_to_install" ]; then
        echo -en "$CNT - Now installing $packages_to_install."
        yay -S --needed --noconfirm $packages_to_install &>> $INSTLOG &
        show_progress $!
        
        # Verify installation of each package
        for package in $packages_to_install; do
            if yay -Q "$package" &> /dev/null ; then
                echo -e "\e[1A\e[K$COK - $package was installed."
            else
                echo -e "\e[1A\e[K$CER - $package install failed, please check the install.log"
                exit 1
            fi
        done
    fi
}

# Function to make all files in the specified directory executable
function make_scripts_executable() {
    local script_dir="$1"

    # Check if the directory exists
    if [ ! -d "$script_dir" ]; then
        echo "Directory $script_dir does not exist."
        return 1
    fi

    # Loop through all files in the directory and apply chmod +x
    for file in "$script_dir"/*; do
        if [ -f "$file" ]; then
            chmod +x "$file"
            echo "Made executable: $file"
        fi
    done
}

function setup_slock_for_dwm() {
    
   # Check if ~/.xprofile exists and does not already contain slock setup
    if [ -f ~/.xprofile ] && ! grep -q 'slock' ~/.xprofile; then
        # Add slock setup to ~/.xprofile
        cat >> ~/.xprofile <<'EOF'

# Start xautolock to automatically lock the screen after 10 minutes of inactivity
xautolock -time 10 -locker slock &

EOF
        echo "slock setup added to ~/.xprofile."
    else
        echo "slock setup already exists in ~/.xprofile or ~/.xprofile does not exist."
    fi

    # Make ~/.xprofile executable
    chmod +x ~/.xprofile
}

function setup_hibernation_after_idle() {
    # Adjusting Timeout Values
    # Screen Off Timeout: You can adjust the screen off timeout by changing the delay in xset dpms force off command (e.g., xset dpms 300 for 5 minutes).
    # Hibernation Timeout: Modify OnUnitActiveSec= in the hibernate-after-idle.timer file to change the hibernation timeout.

    # Check if hibernate-after-idle.service already exists
    if ! sudo systemctl cat hibernate-after-idle.service > /dev/null 2>&1; then
        # Create hibernate-after-idle.service
        sudo tee /etc/systemd/system/hibernate-after-idle.service > /dev/null <<EOF
[Unit]
Description=Hibernate after idle

[Service]
Type=simple
ExecStart=/bin/sh -c 'sleep 600 && systemctl hibernate'

[Install]
WantedBy=multi-user.target
EOF
        echo "Hibernate after idle service setup completed."
    else
        echo "Hibernate after idle service already exists."
    fi

    # Check if hibernate-after-idle.timer already exists
    if ! sudo systemctl cat hibernate-after-idle.timer > /dev/null 2>&1; then
        # Create hibernate-after-idle.timer
        sudo tee /etc/systemd/system/hibernate-after-idle.timer > /dev/null <<EOF
[Unit]
Description=Hibernate after idle timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=10min

[Install]
WantedBy=timers.target
EOF
        echo "Hibernate after idle timer setup completed."
    else
        echo "Hibernate after idle timer already exists."
    fi

    # Reload systemd
    sudo systemctl daemon-reload

    # Enable and start hibernate-after-idle.timer
    sudo systemctl enable --now hibernate-after-idle.timer

    echo "System will hibernate after 10 minutes of inactivity."
}

function install_nvidia() {
    # find the Nvidia GPU
    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
        ISNVIDIA=true
    else
        ISNVIDIA=false
    fi

    # Setup Nvidia if it was found
    if [[ "$ISNVIDIA" == true ]]; then
        echo -e "$CNT - Nvidia GPU support setup stage..."
        install_software nvidia_stage

        # update config
        sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
        echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf &>> $INSTLOG
    fi
}

function install_yay() {
    #### Check for package manager ####
    if [ ! -f /sbin/yay ]; then  
        echo -en "$CNT - Configuering yay."
        git clone https://aur.archlinux.org/yay.git &>> $INSTLOG
        cd yay
        makepkg -si --noconfirm &>> ../$INSTLOG &
        show_progress $!
        if [ -f /sbin/yay ]; then
            echo -e "\e[1A\e[K$COK - yay configured"
            cd ..
            
            # update the yay database
            echo -en "$CNT - Updating yay."
            yay -Suy --noconfirm --combinedupgrade --combinedupgrade &>> $INSTLOG &
            show_progress $!
            echo -e "\e[1A\e[K$COK - yay updated."
        else
            # if this is hit then a package is missing, exit to review log
            echo -e "\e[1A\e[K$CER - yay install failed, please check the install.log"
            exit
        fi
    fi
}

function setup_dunst() {
    # Check if ~/.xprofile exists and does not already contain dunst setup
    if [ -f ~/.xprofile ] && ! grep -q 'dunst &' ~/.xprofile; then
        # Add dunst setup to ~/.xprofile
        cat >> ~/.xprofile <<'EOF'
# Start Dunst for notifications
dunst &
EOF
        echo "Dunst setup added to ~/.xprofile."
    else
        echo "Dunst setup already exists in ~/.xprofile or ~/.xprofile does not exist."
    fi

    ln -sf ~/.config/configs/dunst/dunstrc ~/.config/dunst/dunstrc
}

function setup_picom() {
    # Add picom startup command to ~/.xprofile if not already present
    # Source and destination paths
    src_file=~/.config/configs/picom/picom.conf
    dest_file=~/.config/picom.conf

    # Check if the destination file already exists
    if [ -f "$dest_file" ]; then
        # Remove the existing file before creating the symbolic link
        rm -f "$dest_file"
    fi

    # Create the symbolic link
    ln -sf "$src_file" "$dest_file"

    if ! grep -q "picom --config ~/.config/picom.conf &" ~/.xprofile; then
        echo >> ~/.xprofile
        echo "# Start picom" >> ~/.xprofile
        echo "picom --config ~/.config/picom.conf &" >> ~/.xprofile
        # --experimental-backends 
        echo "Added picom startup command to ~/.xprofile"
    else
        echo "Picom startup command already exists in ~/.xprofile"
    fi

    echo "Transparency setup completed. Please restart your X session to apply changes."
}


function is_vm() {
    # attempt to discover if this is a VM or not
    echo -e "$CNT - Checking for Physical or VM..."
    ISVM=$(hostnamectl | grep Chassis)
    echo -e "Using $ISVM"
    if [[ $ISVM == *"vm"* ]]; then
        echo -e "$CWR - Please note that VMs are not fully supported and if you try to run this on
        a Virtual Machine there is a high chance this will fail."
        sleep 1
    fi
}


function setup_video_hibernation() {
    # Step 1: Create the monitor script
    sudo tee /usr/local/bin/monitor_video.sh > /dev/null << 'EOF'
#!/bin/bash

while true; do
    if pgrep -x "mpv" || pgrep -x "vlc"; then
        echo "Video playing, preventing hibernation"
        systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
    else
        echo "No video playing, hibernation allowed"
        systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
    fi

    sleep 60  # Check every minute
done
EOF

    # Step 2: Set permissions for the monitor script
    sudo chmod +x /usr/local/bin/monitor_video.sh

    # Step 3: Create the systemd service
    sudo tee /etc/systemd/system/monitor_video.service > /dev/null << 'EOF'
[Unit]
Description=Monitor video playback for hibernation prevention

[Service]
ExecStart=/usr/local/bin/monitor_video.sh

[Install]
WantedBy=multi-user.target
EOF

    # Step 4: Reload systemd configuration
    sudo systemctl daemon-reload

    # Step 5: Enable and start the systemd service
    sudo systemctl enable monitor_video.service
    sudo systemctl start monitor_video.service

    echo "Video playback monitoring and hibernation setup complete."
}


# clear the screen
clear

echo -e "$CNT - Setup starting..."
is_vm
install_yay
# Call the install function with all package names
echo -e "$CNT - Prep Stage - Installing needed components"
install_software prep_stage
echo -e "$CNT - Audio Stage - Installing audio components"
install_software audio_stage
install_nvidia

# this is for debugging only, remove this logic later
if [ -f "~/.xprofile" ]; then
    # Delete the file
    rm -f "~/.xprofile"
    echo "~/.xprofile has been deleted."
else
    echo "~/.xprofile does not existn no need to delete it"
fi

compile_app slock
compile_app dwm
compile_app dwmblocks

make_scripts_executable "~/.config/configs/scripts"

setup_backgrounds
setup_slock_for_dwm
setup_hibernation_after_idle
setup_picom
setup_video_hibernation
# setup_dunst


# echo -e "$CNT - Installing main components..."
# install_software install_stage

# Start the bluetooth service
# echo -e "$CNT - Starting the Bluetooth Service..."
# sudo systemctl enable --now bluetooth.service &>> $INSTLOG
# sleep 2
   
# Clean out other portals
# echo -e "$CNT - Cleaning out conflicting xdg portals..."
# yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk &>> $INSTLOG

echo -e "$CNT - Copying config files..."
# copy the configs directory
cp -R -u configs ~/.config/
# ********************************************************************
# Config files 
# ********************************************************************
echo -e "$CNT - Setting up the new config..." 

# Ensure destination directories exist
mkdir -p ~/.config/kitty
ln -sf ~/.config/configs/kitty/kitty.conf ~/.config/kitty/kitty.conf

mkdir -p ~/.config/wlogout
ln -sf ~/.config/configs/wlogout/layout ~/.config/wlogout/layout

mkdir -p ~/.config/rofi
ln -sf ~/.config/configs/rofi/config.rasi ~/.config/rofi/config.rasi
ln -sf ~/.config/configs/rofi/theme.rasi ~/.config/rofi/theme.rasi

mkdir -p ~/.config/alacritty
ln -sf ~/.config/configs/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

sudo cp -f -u ~/.config/configs/mc/ini ~/.config/mc/ini 
sudo cp -f -u ~/.config/configs/mc/darkened.ini /usr/share/mc/skins/darkened.ini


# ********************************************************************
# setup the first look and feel as dark
# ********************************************************************

# mkdir -p ~/.themes
# cp -r -f -d -u ~/.config/configs/gtktheme/Arc-BLACKEST ~/.themes/
# xfconf-query -c xsettings -p /Net/ThemeName -s "BWnB-GTK"
# xfconf-query -c xsettings -p /Net/IconThemeName -s "BWnB-GTK"
# xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "BWnB-GTK"

#setup_dark_theme
#install_custom_theme
# xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
# xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
# gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
# gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
# cp -f ~/.config/configs/backgrounds/background-dark.jpg /usr/share/sddm/themes/sdt/wallpaper.jpg

# ********************************************************************
# Install the starship shell 
# ********************************************************************
echo -e "$CNT - Install Starship"
echo -e "$CNT - Updating .bashrc..."
add_if_not_exists 'eval "$(starship init bash)"' ~/.bashrc
add_if_not_exists 'eval "$(starship init zsh)"' ~/.zshrc
echo -e "$CNT - copying starship config file to ~/.config ..."
mkdir -p ~/.config
cp -f -u configs/starship/starship.toml ~/.config/

# ********************************************************************
# sddm section
# ********************************************************************
echo -e "$CNT - Setting up the login screen."
sudo cp -R -u sddm/TerminalStyleLogin /usr/share/sddm/themes/
sudo chown -R $USER:$USER /usr/share/sddm/themes/TerminalStyleLogin
sudo mkdir /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=TerminalStyleLogin" | sudo tee -a /etc/sddm.conf.d/10-theme.conf &>> $INSTLOG


# Enable the sddm login manager service
echo -e "$CNT - Enabling the SDDM Service..."
sudo systemctl enable sddm &>> $INSTLOG
sleep 2

#exec sudo systemctl start sddm &>> $INSTLOG

sudo usermod -a -G audio $USER

# ********************************************************************
# done
# ********************************************************************
echo -e "$CNT - Script had completed!"
if [[ "$ISNVIDIA" == true ]]; then 
    echo -e "$CAT - Since we attempted to setup an Nvidia GPU the script will now end and you should reboot.
    Please type 'reboot' at the prompt and hit Enter when ready."
    exit
fi

echo "Starting dwm..."
add_dwm_to_sddm
# pkill dwm
# startx  