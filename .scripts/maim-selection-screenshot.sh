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

pic_directory=${PICTURES_DIRECTORY:-"$HOME/Pictures"}

geometry_coordinates=$(slop)
date_format=$(date +%F-%H-%M-%S)

pic_filepath=$pic_directory/$date_format-$geometry_coordinates.png 

maim_process=$(maim $pic_filepath --geometry=$geometry_coordinates)

notify-send "screenshot" --hint:string:path:$pic_filepath
