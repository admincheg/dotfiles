#!/bin/bash

export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit

if [ -f ${HOME}/.config/panel.pid ]; then
	kill `cat ${HOME}/.config/panel.pid`
	rm -f ${HOME}/.config/panel.pid
fi

xrdb -merge ${HOME}/.Xresources

if command -v dbus-launch >/dev/null && test -z "${DBUS_SESSION_BUS_ADDRESS}"; then
       eval $(dbus-launch --sh-syntax --exit-with-session bspwm)
fi
