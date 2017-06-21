#!/bin/sh
dir=`realpath $0 | sed 's/[^\/]*$//'`

if [ "$USER" != "root" ]; then
    echo "This script required root privileges"
    exit 1
fi

usage() {
    echo "Usage: $0 <i[nstall]|u[ninstall]|d[eps]|h[elp]>"
}

deps() {
    echo "Installing dependencies"
    if [[ -x `which pacman` ]]; then
        pacman -S --needed zsh wmctrl lm_sensors bc
        [[ -x `which X` ]] && pacman -S --needed xorg-xprop xorg-xrandr mesa-demos
    elif [[ -x `which apt-get` ]]; then
        apt-get install zsh wmctrl lm_sensors bc
        [[ -x `which X` ]] && apt-get install xorg-xprop xorg-xrandr mesa-demos
    elif [[ -x `which aptitude` ]]; then
        aptitude install zsh wmctrl lm_sensors bc
        [[ -x `which X` ]] && aptitude install xorg-xprop xorg-xrandr mesa-demos
    elif [[ -x `which emerge` ]]; then
        emerge zsh wmctrl lm_sensors bc
        [[ -x `which X` ]] &&  emerge xorg-xprop xorg-xrandr mesa-demos
    else
        echo "No default package manager found (it may simply not be listed)"
        echo "Please install the following packages manually and relaunch this script:"
        echo "zsh wmctrl lm_sensors bc [xorg-xprop]"
        exit 1
    fi
}

install() {
    echo "Installing screenfetch"
    if [[ -x `which screenfetch` ]]; then
        echo "This program conflicts with \"`which screenfetch`\""
        echo "Please uninstall it manually and relaunch this script"
        exit 1
    fi
    deps
    
    cp $dir/screenfetch /bin/screenfetch
    echo "Successfully installed"
}

uninstall() {
    echo "Uninstalling screenfetch"
    rm /bin/screenfetch
    echo "Successfully uninstalled"
}

case $1 in
    d | deps)
        deps;;
    i | install)
        install;;
    u | uninstall)
        uninstall;;
    h | help | '-h' | '--help')
        usage;;
    *)
        install;;
esac
