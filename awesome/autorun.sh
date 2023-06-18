#!/bin/sh

run() {
    if ! pgrep -f "$1" ; then
        "$@" &
    fi
}

run numlockx

# Systray apps
run pnmixer
run nm-applet
run blueman-tray
run redshift-gtk
run flameshot
run dropbox start -i
