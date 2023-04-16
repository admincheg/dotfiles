#!/bin/bash

EVENT=$1; shift
INSTANCE=$(dbus-send --print-reply --dest=org.freedesktop.DBus  /org/freedesktop/DBus org.freedesktop.DBus.ListNames | awk -F'"' '/mpris/ {print $2}')

if [[ -z ${INSTANCE} ]]; then
	exit 1
fi

CMD="dbus-send --print-reply --dest="${INSTANCE}" /org/mpris/MediaPlayer2"

case "${EVENT}" in
play)
	${CMD} org.mpris.MediaPlayer2.Player.Play > /dev/null
	;;
toggle)
	${CMD} org.mpris.MediaPlayer2.Player.PlayPause > /dev/null
	;;
pause)
	${CMD} org.mpris.MediaPlayer2.Player.Pause > /dev/null
	;;
next)
	${CMD} org.mpris.MediaPlayer2.Player.Next > /dev/null
	;;
prev)
	${CMD} org.mpris.MediaPlayer2.Player.Previous > /dev/null
	;;
esac
