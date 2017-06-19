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
        pacman -S --needed zsh wmctrl lm_sensors
    elif [[ -x `which apt-get` ]]; then
        apt-get install zsh wmctrl lm_sensors
    elif [[ -x `which aptitude` ]]; then
        aptitude install zsh wmctrl lm_sensors
    elif [[ -x `which emerge` ]]; then
        emerge zsh wmctrl lm_sensors
    else
        echo "No default package manager found"
        echo "Please install the following packages manually and relaunch this script:"
        echo "zsh wmctrl lm_sensors"
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
    
    cp $dir/lhs /usr/share/screenfetch
    cp $dir/screenfetch /bin/screenfetch
    echo "Successfully installed"
}

uninstall() {
    echo "Uninstalling screenfetch"
    rm /usr/share/screenfetch
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
    h | help)
        usage;;
    '-h' | '--help')
        usage;;
    *)
        install;;
esac
