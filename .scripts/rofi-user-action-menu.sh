#!/bin/sh 

options='shutdown 0 -P
reboot
i3-msg exit'

command=$(echo -e "$options" | rofi -dmenu -p "Select the command to execute.")

continue=$(echo -e "No\nYes" | rofi -dmenu -p "You really want to continue with '$command'?")

if [[ $continue == "Yes" ]]; then 
    eval "$command"
fi
