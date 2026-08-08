#!/bin/bash

set_monitor() {
  connected=( $(xrandr | awk '/ connected/ {print $1}') )
  left=""
  for i in ${connected[@]}; do
    if [[ "${left}" ]]; then
      xrandr --output ${i} --auto --right-of ${left}
	else
	  xrandr --output ${i} --auto
    fi

    bspc monitor ${i} -d I II III IV V VI VII VIII IX X
    left=${i}
  done

  if [[ ${connected[@]} =~ DisplayPort-0 ]]; then
    xrandr --output DisplayPort-0 --primary
  elif [[ ${connected[@]} =~ DisplayPort-1 ]]; then
    xrandr --output DisplayPort-1 --primary
  else
    xrandr --output eDP --primary
  fi
}

if [[ $(basename "$0") == "monitors.sh" ]]; then
  echo "[:::] Direct run. Reconfigure monitors."
  declare -x PATH="/home/owlbook/.bin:/home/owlbook/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin"
  set_monitor
fi
