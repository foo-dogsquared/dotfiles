#!/bin/sh

# Records a part of the screen. 
# Note this is a toggle command. 
# There could only have one recording instance running at a time. 

# Minimum requirements:
# awk - GNU Awk v5.0.1
# date - v8.31 GNU implentation
# ffmpeg - version n4.2.1; built with GCC; based from the Arch Linux repo 
# slop - v7.4
# xwininfo - v1.1.5

# Having used `xwininfo`, it needs to have the legacy graphics stack (X11-based) on Linux

function error_cleanup() {
    # rm "$pic_filepath"    
    echo "$red An error occurred on line $1\n $reset"
}

help_section="
Simply captures a recording with ffmpeg. 

This is more reliable than OBS Studio (since I don't how to fully utilize it yet). 

Usage: $0 [-o/--output <OUTPUT_PATH>] [-s/--selection] 

Options:
-h, --help - show the help section
-o, --output <string> - the path of the output (default: '~/Videos')
"

# setting up a exit trap in case of error
trap 'error_cleanup $LINENO' ERR

OUTPUT=${VIDEOS:-"$HOME/Videos"}

while [[ $# -gt 0 ]]
do
    case $1 in 
        -h|--help)
            echo "$help_section"
            exit 0;;
        -o|--output)
            OUTPUT="$2"
            shift
            shift;;
        *)
            shift;;
    esac
done

# Constants
RECORDING_FILE="/tmp/fds-ffmpeg-currently-recording";

if [[ ! -f $RECORDING_FILE ]]; then 
    dimensions=$(slop -f "%x %y %w %h %g %i") || exit 1;
    read -r pos_x pos_y width height grid id <<< $dimensions

    date_format=$(date +%F-%H-%M-%S)
    
    recording_command="ffmpeg -y -f x11grab -s ${width}x${height} -i :0.0+${pos_x},$pos_y ${OUTPUT}/$date_format.mkv -nostdin"

    $recording_command &
    WINDOW_ID="$!"
    RETURN_CODE="$?"
    sleep 1;

    if [[ "$RETURN_CODE" != 0 ]]; then
        notify-send "Recording start has failed";
        exit 1;
    fi

    notify-send "Recording started successfully" "Process ID is at "$WINDOW_ID"";

    touch "$RECORDING_FILE";
    echo "$WINDOW_ID" >> $RECORDING_FILE;
else
    WINDOW_ID=$(<"$RECORDING_FILE")
    
    kill $WINDOW_ID

    if [[ $? != 0 ]]; then 
        notify-send "Recording stop failed" "There's a problem while trying to kill the process. Process ID is at $WINDOW_ID";
        exit 1;
    fi

    notify-send "Recording stop successful"
    rm "$RECORDING_FILE"
fi