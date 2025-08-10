#!/bin/sh

run() {
    if ! pgrep -f "$1" ; then
        "$@" &
    fi
}

# Systray apps
run nm-applet
run blueman-tray
run redshift-gtk
run flameshot
run dropbox start -i
run volumeicon
