#!/bin/sh

# Simply captures an image with regional selection.

# Here are the dependencies needed to successfully 
# run this script (as of creating this script):
# * slop (version 7.4)
# * maim (version 5.5.3)
# * date (version 8.31)

# setting up variables for the color
red="\u001b[31m"
green="\u001b[32m"
reset="\u001b[0m"

function error_cleanup() {
    rm "$pic_filepath"    
    printf "$red An error occurred on line $1\n $reset"
}

# setting up a exit trap in case of error
trap 'error_cleanup $LINENO' ERR

delay=0

if [[ -n "$1" || "$1" -gt 0 ]]; then
    delay=$1
fi

pic_directory=${PICTURES_DIRECTORY:-"$HOME/Pictures"}

geometry_coordinates=$(slop)

if [[ -z $geometry_coordinates ]]; then
   exit 1;
fi

date_format=$(date +%F-%H-%M-%S)

pic_filepath="$pic_directory/$date_format-$geometry_coordinates.png"

if [[ $delay -gt 0 ]]; then
    notify-send "Delayed screenshot" "A delayed screenshot is about to be taken in $delay seconds." --expire-time=$(( ($delay * 1000) - 1000 ))
fi

maim_process=$(maim $pic_filepath --hidecursor --delay=$delay --geometry=$geometry_coordinates)

notify-send "Screenshot taken" "It is saved at $pic_filepath."

