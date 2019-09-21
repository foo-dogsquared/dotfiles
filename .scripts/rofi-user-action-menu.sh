#!/bin/sh 

options='shutdown 0 -P
reboot
i3-msg exit'

command=$(echo -e "$options" | rofi -dmenu -p "Select the command to execute.")

if [[ $? != 0 ]]; then 
    exit $?
fi

continue=$(echo -e "No\nYes" | rofi -dmenu -p "You really want to continue with '$command'?")

if [[ $continue == "Yes" ]]; then 
    eval "$command"
fi
