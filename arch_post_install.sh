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

# dwmblocks and dwm click is done using GitHub - LukeSmithxyz/dwmblocks:  example

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
# set background swww img $HOME/.config/configs/backgrounds/$VER'-background-dark.jpg'
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
    [make]="Make"
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
    [networkmanager]="Network Manager"
    [dunst]="Lightweight notification service"
    [libnotify]="command-line utility on Linux systems used to send desktop notifications"
    [eww]="Bar for dwm"
    [fail2ban]="ban clients that try to connect several times"
    [audit]="Audit nextwork and system"
    [ossec-hids-local]="Virus/Intrusion detection tool"
)

#     [calcurse-git]="CLI calendar"
#     [dmenu]="Dynamic Menu"

declare -A audio_stage=(
    [mvp]="Multimedia player"
    [pipewire]="Multimedia server"
    [wireplumber]="PipeWire session manager"
    [pipewire-alsa]="ALSA support for PipeWire"
    [pipewire-pulse]="PulseAudio support for PipeWire"
    [alsa-utils]="ALSA utilities"
    [helvum]="GTK patchbay for PipeWire"
)

declare -A audio_stage=(
    [pipewire]="Multimedia server"
    [wireplumber]="PipeWire session manager"
    [pipewire-alsa]="ALSA support for PipeWire"
    [pipewire-pulse]="PulseAudio support for PipeWire"
    [helvum]="GTK patchbay for PipeWire"
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
    [ufw]="Uncomplicated Firewalll"
    [fzf-git]="Fuzzy finder for terminal"
    [rust]="rust libs"
    [suricata]="Comprehensive network intrusion detection tool"
    [gcc]="Compiler"
    [pamixer]="Pulseaudio command-line mixer like amixer"
    [pavucontrol]="PulseAudio Volume Control"
    [pipewire-jack]="JACK support for PipeWire"
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

    echo -e "Compiling ${app_name}..."

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
    
    # Check if $HOME/.xprofile exists and if background setting section exists
    if [ -f "$HOME/.xprofile" ]; then
        if ! grep -q "set-background" "$HOME/.xprofile"; then
            # Append call to set-background in $HOME/.xprofile
            echo >> "$HOME/.xprofile"
            echo "# Set background based on current desktop tag" >> "$HOME/.xprofile"
            echo "/bin/bash set-background 1 &" >> "$HOME/.xprofile"
            
            echo "Background setup completed. Please restart your X session to apply changes."
        else
            echo "Background setup already exists in $HOME/.xprofile. No changes made."
        fi
    else
        # Create $HOME/.xprofile and add background setting section
        echo "# Set background based on current desktop tag" > "$HOME/.xprofile"
        echo "/bin/bash set-background 1 &" >> "$HOME/.xprofile"
        
        echo "Background setup completed. Please restart your X session to apply changes."
    fi
}

# network monitoring tool
function setup_ossec() {
    echo "Setting up OSSEC configuration..."
    echo -e "$CNT - copying ossec config ..."
    sudo mkdir -p /var/ossec/etc/
    sudo cp -f -u -R configs/ossec/* /var/ossec/etc/

    echo "Enabling and starting OSSEC service..."
    sudo systemctl enable ossec
    sudo systemctl start ossec

    echo "OSSEC setup complete. Please review the configuration file (/var/ossec/etc/ossec.conf) and adjust as necessary."
}

# Function to configure Suricata
function  setup_suricata() {
    echo "Configuring Suricata..."

    # Create configuration directory if it doesn't exist
    sudo mkdir -p /etc/suricata

    echo -e "$CNT - copying ossec config ..."
    sudo mkdir -p /etc/suricata/
    sudo cp -f -u -R configs/suricata/* /etc/suricata/

    echo "Starting Suricata..."
    sudo systemctl start suricata
    sudo systemctl enable suricata
    echo "Suricata service started."
}

function setup_fzf() {
    # Install fzf using pacman
    if ! command -v fzf &> /dev/null; then
        echo "Installing fzf..."
        sudo pacman -S fzf --noconfirm
    else
        echo "fzf is already installed."
    fi

    # Define the necessary aliases and functions
    fzf_setup_script=$(cat <<'EOF'
# Aliases for fzf
alias ff='find . -type f | fzf'
alias fh='history | fzf'

# Git integration with fzf
gfb() {
    git branch --all | fzf --preview 'echo {} | sed "s/^..//" | xargs -I % git log --oneline -n 10 %'
}

gfc() {
    git log --oneline | fzf --preview 'echo {} | awk "{print \$1}" | xargs -I % git show --stat %'
}

gff() {
    git ls-files | fzf
}

# Customizing fzf
export FZF_DEFAULT_OPTS='--height 40% --border --ansi'
EOF
    )

    # Append the setup script to the shell configuration file if not already present
    if ! grep -q 'fzf setup' ~/.bashrc; then
        echo "Adding fzf setup to ~/.bashrc"
        echo -e "\n# fzf setup\n$fzf_setup_script" >> ~/.bashrc
    fi

    if ! grep -q 'fzf setup' ~/.zshrc; then
        echo "Adding fzf setup to ~/.zshrc"
        echo -e "\n# fzf setup\n$fzf_setup_script" >> ~/.zshrc
    fi

    # Reload the shell configuration
    echo "Reloading shell configuration..."
    source ~/.bashrc 2> /dev/null || true
    source ~/.zshrc 2> /dev/null || true

    echo "fzf setup completed."
}

# Function to harden Arch Linux
function harden_system() {
    # echo "Configuring UFW..."
    # sudo ufw default deny incoming
    # sudo ufw default allow outgoing
    # # Enable and start UFW
    # sudo systemctl enable ufw
    # sudo systemctl start ufw

    echo "Configuring Fail2Ban..."
    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban

    echo "Configuring Auditd..."
    sudo systemctl enable auditd
    sudo systemctl start auditd

    setup_ossec
    #setup_suricata

    echo "System hardening complete."
    # to monitor
    # sudo tail -f /var/log/ufw.log
    # sudo tail -f /var/log/fail2ban.log
    # sudo tail -f /var/log/audit/audit.log
}


function configure_quet_systemd_boot() {
  # Get the UUID of the root partition
  local root_uuid=$(findmnt -no UUID /)
  
  # Check if UUID was found
  if [ -z "$root_uuid" ]; then
    echo "Failed to get root partition UUID."
    exit 1
  fi

  # Path to the systemd-boot entry file
  local boot_entry_file="/boot/loader/entries/arch.conf"

  # Update the boot entry file
  if [ -f "$boot_entry_file" ]; then
    echo "Updating $boot_entry_file with quiet and loglevel=0"

    # Check if 'quiet' and 'loglevel=0' are already present
    if grep -q 'quiet' "$boot_entry_file" && grep -q 'loglevel=0' "$boot_entry_file"; then
      echo "'quiet' and 'loglevel=0' options are already present."
    else
      # Add 'quiet' and 'loglevel=0' options if they are not present
      sudo sed -i "s/options .*/options root=UUID=${root_uuid} rw quiet loglevel=0/" "$boot_entry_file"
      echo "Added 'quiet' and 'loglevel=0' options."
    fi
  else
    echo "[ERROR] Boot entry file $boot_entry_file not found!"
    return 1
  fi

  # Rebuild the initial ramdisk
  echo "Rebuilding initial ramdisk..."
  sudo mkinitcpio -P

  echo "Configuration completed. Please reboot to apply changes."
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

    # Create $HOME/.xprofile file with dwm if it does not exist
    if [ ! -f $HOME/.xprofile ]; then
        cat > $HOME/.xprofile << EOF
#!/bin/sh
exec dwm
EOF
        chmod +x $HOME/.xprofile
        echo "Created $HOME/.xprofile with exec dwm."
    else
        if ! grep -q "exec dwm" $HOME/.xprofile; then
            echo "exec dwm" >> $HOME/.xprofile
            echo "Appended exec dwm to $HOME/.xprofile."
        else
            echo "$HOME/.xprofile already contains exec dwm."
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
    echo "export GTK_THEME=$THEME_NAME" >> "$HOME/.bashrc" # or $HOME/.zshrc, depending on your shell

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

    chmod 755 "$script_dir"
    # Loop through all files in the directory and apply chmod +x
    for file in "$script_dir"/*; do
        if [ -f "$file" ]; then
            chmod +x "$file"
            echo "[OK] Made executable: $file"
        fi
    done
}

function setup_slock_for_dwm() {
    
   # Check if $HOME/.xprofile exists and does not already contain slock setup
    if [ -f $HOME/.xprofile ] && ! grep -q 'slock' $HOME/.xprofile; then
        # Add slock setup to $HOME/.xprofile
        cat >> $HOME/.xprofile <<'EOF'

# Start xautolock to automatically lock the screen after 10 minutes of inactivity
xautolock -time 10 -locker slock &

EOF
        echo "slock setup added to $HOME/.xprofile."
    else
        echo "slock setup already exists in $HOME/.xprofile or $HOME/.xprofile does not exist."
    fi

    # Make $HOME/.xprofile executable
    chmod +x $HOME/.xprofile
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

# Function to set Neovim color scheme to moonfly
function set_nvim_colorscheme_to_moonfly() {
    # Paths to your Neovim configuration files
    NVIM_INIT_VIM="$HOME/.config/nvim/init.vim"
    NVIM_INIT_LUA="$HOME/.config/nvim/init.lua"
    NVIM_BACKUP_VIM="$HOME/.config/nvim/init.vim.bak"
    NVIM_BACKUP_LUA="$HOME/.config/nvim/init.lua.bak"
    
    # Check if the init.vim or init.lua exists
    if [[ -f "$NVIM_INIT_VIM" ]]; then
        CONFIG_FILE="$NVIM_INIT_VIM"
        BACKUP_FILE="$NVIM_BACKUP_VIM"
    elif [[ -f "$NVIM_INIT_LUA" ]]; then
        CONFIG_FILE="$NVIM_INIT_LUA"
        BACKUP_FILE="$NVIM_BACKUP_LUA"
    else
        echo "Neovim configuration file not found."
        exit 1
    fi

    # Check if the vim-moonfly-colors plugin is mentioned in the configuration
    if ! grep -q "bluz71/vim-moonfly-colors" "$CONFIG_FILE"; then
        echo "The vim-moonfly-colors plugin is not installed in your Neovim configuration."
        exit 1
    fi

    # Create a backup of the Neovim configuration
    cp "$CONFIG_FILE" "$BACKUP_FILE"

    # Function to set the color scheme
    if grep -q "colorscheme moonfly" "$CONFIG_FILE"; then
        echo "The color scheme is already set to moonfly."
    else
        echo "Setting Neovim color scheme to moonfly..."
        if grep -q "colorscheme " "$CONFIG_FILE"; then
            # Update existing colorscheme line
            sed -i 's/colorscheme .*/colorscheme moonfly/' "$CONFIG_FILE"
        else
            # Add colorscheme line for vim-plug or lazy.nvim
            if [[ "$CONFIG_FILE" == "$NVIM_INIT_VIM" ]]; then
                echo "colorscheme moonfly" >> "$CONFIG_FILE"
            else
                echo "require('lazy').setup({" >> "$CONFIG_FILE"
                echo "  'bluz71/vim-moonfly-colors'," >> "$CONFIG_FILE"
                echo "  config = function()" >> "$CONFIG_FILE"
                echo "    vim.cmd('colorscheme moonfly')" >> "$CONFIG_FILE"
                echo "  end" >> "$CONFIG_FILE"
                echo "})" >> "$CONFIG_FILE"
            fi
        fi
        echo "Color scheme set to moonfly in $CONFIG_FILE."
    fi
}

function setup_picom() {
    # Add picom startup command to $HOME/.xprofile if not already present
    # Source and destination paths
    src_file=configs/picom/picom.conf
    dest_file=$HOME/.config/picom.conf

    # Create the symbolic link
    cp -f "$src_file" "$dest_file"

    if ! grep -q "picom --config $HOME/.config/picom.conf &" $HOME/.xprofile; then
        echo >> $HOME/.xprofile
        echo "# Start picom" >> $HOME/.xprofile
        echo "picom --config $HOME/.config/picom.conf &" >> $HOME/.xprofile
        # --experimental-backends 
        echo "Added picom startup command to $HOME/.xprofile"
    else
        echo "Picom startup command already exists in $HOME/.xprofile"
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

# TODO, maybe move this to DWMBLocks doing all the checks and hybernate?
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

function add_dunst_to_autostart() {
    local xprofile="$HOME/.xprofile"
    local dunst_command="dunst &"

    # Create .xprofile if it doesn't exist
    if [ ! -f "$xprofile" ]; then
        touch "$xprofile"
    fi

    # Remove old dunst command if exists and add the new one
    if grep -q "^dunst" "$xprofile"; then
        sed -i '/^dunst/d' "$xprofile"
    fi

    echo "$dunst_command" >> "$xprofile"
    echo "Dunst has been added to $xprofile for autostart."
}

# Function to ask for sudo password once
ask_for_sudo() {
    # Prompt for sudo password once
    sudo -v
    # Keep sudo credentials alive in the background
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &
}

# clear the screen
clear

ask_for_sudo

export PATH="$HOME/.local/bin:$PATH"

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
if [ -f "$HOME/.xprofile" ]; then
    # Delete the file
    rm -f "$HOME/.xprofile"
    echo "$HOME/.xprofile has been deleted."
else
    echo "$HOME/.xprofile does not existn no need to delete it"
fi


# TODO: 
# Start the bluetooth service
# echo -e "$CNT - Starting the Bluetooth Service..."
# sudo systemctl enable --now bluetooth.service &>> $INSTLOG
# sleep 2
# Clean out other portals
# echo -e "$CNT - Cleaning out conflicting xdg portals..."
# yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk &>> $INSTLOG
# configure_quet_systemd_boot


# all patches that are on
#define BAR_DWMBLOCKS_PATCH 1
#define BAR_LTSYMBOL_PATCH 1
#define BAR_STATUS_PATCH 1
#define BAR_STATUSCMD_PATCH 1
#define BAR_TAGS_PATCH 1
#define BAR_UNDERLINETAGS_PATCH 1
#define BAR_WINTITLE_PATCH
#define BAR_ALPHA_PATCH 1
#define BAR_CENTEREDWINDOWNAME_PATCH 1
#define BAR_HEIGHT_PATCH 1
#define BAR_PADDING_PATCH 1
#define BAR_PADDING_VANITYGAPS_PATCH 1
#define ALT_TAB_PATCH 1
#define ALWAYSCENTER_PATCH 1
#define AUTOSTART_PATCH 1
#define AUTORESIZE_PATCH 1
#define INPLACEROTATE_PATCH 1
#define PERTAG_PATCH 1
#define PERTAGBAR_PATCH 1
#define ROUNDED_CORNERS_PATCH 1
#define VANITYGAPS_PATCH 1
#define TILE_LAYOUT 1
#define MONOCLE_LAYOUT 1
compile_app dwm
compile_app dwmblocks
compile_app slock

# ********************************************************************
# Config files 
# ********************************************************************
make_scripts_executable "configs/scripts"

echo -e "$CNT - Copying config files..."
sudo cp -R -f configs "$HOME/.config/"

echo -e "$CNT - Copying all scripts to /usr/local/bin..."
sudo cp -Rf configs/scripts/* /usr/local/bin/

echo -e "$CNT - Copying autostart.sh..."
sudo cp -f "configs/scripts/autostart.sh" "$HOME/.local/share/dwm/autostart.sh"

echo -e "$CNT - Copying rofi config..." 
sudo mkdir -p $HOME/.config/rofi
sudo cp -Rf $HOME/.config/configs/rofi/* $HOME/.config/rofi/

echo -e "$CNT - Copy dunst config..."
sudo mkdir -p $HOME/.config/dunst/
sudo cp -Rf $HOME/.config/configs/dunst/* $HOME/.config/dunst/

echo -e "$CNT - Alacritty config..."
sudo mkdir -p $HOME/.config/alacritty/
sudo cp -Rf $HOME/.config/configs/alacritty/* $HOME/.config/alacritty/

echo -e "$CNT - Midnight commander config..."
sudo mkdir -p $HOME/.config/mc/
sudo cp -f -u $HOME/.config/configs/mc/ini $HOME/.config/mc/ini 
sudo cp -f -u $HOME/.config/configs/mc/darkened.ini /usr/share/mc/skins/darkened.ini

setup_backgrounds
add_dunst_to_autostart
setup_slock_for_dwm
setup_hibernation_after_idle
setup_picom
#setup_fzf
setup_video_hibernation
harden_system


# ********************************************************************
# setup the first look and feel as dark
# ********************************************************************
# TODO:
# mkdir -p $HOME/.themes
# cp -r -f -d -u $HOME/.config/configs/gtktheme/Arc-BLACKEST $HOME/.themes/
# xfconf-query -c xsettings -p /Net/ThemeName -s "BWnB-GTK"
# xfconf-query -c xsettings -p /Net/IconThemeName -s "BWnB-GTK"
# xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "BWnB-GTK"

#setup_dark_theme
#install_custom_theme
# xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
# xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
# gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
# gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
# cp -f $HOME/.config/configs/backgrounds/background-dark.jpg /usr/share/sddm/themes/sdt/wallpaper.jpg

# ********************************************************************
# Install the starship shell 
# ********************************************************************
echo -e "$CNT - Install Starship"
echo -e "$CNT - Updating .bashrc..."
add_if_not_exists 'eval "$(starship init bash)"' $HOME/.bashrc
add_if_not_exists 'eval "$(starship init zsh)"' $HOME/.zshrc
echo -e "$CNT - copying starship config file to $HOME/.config ..."
sudo mkdir -p $HOME/.config
sudo cp -f -u configs/starship/starship.toml $HOME/.config/

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

set_nvim_colorscheme_to_moonfly

echo "Starting dwm..."
add_dwm_to_sddm
# pkill dwm
# startx  