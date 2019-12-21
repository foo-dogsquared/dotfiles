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

Usage: $0 [-o/--output <OUTPUT_PATH>] 

Options:
-h, --help - show the help section
-o, --output <string> - the path of the output (default: '~/Videos')
--disable-cursor - disable rendering of the mouse cursor in the recording
--follow-mouse - enable following of the mouse in the center of the recording
--enable-notification - disable success notification 
"

# setting up a exit trap in case of error
trap 'error_cleanup $LINENO' ERR

OUTPUT=${VIDEOS:-"$HOME/Videos"}
MOUSELESS=0
FOLLOW_MOUSE=0
ENABLE_NOTIFICATION=0

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
        --disable-cursor)
            MOUSELESS=1
            shift;;
        --follow-mouse)
            FOLLOW_MOUSE=1
            shift;;
        --enable-notification)
            ENABLE_NOTIFICATION=1
            shift;;
        *)
            shift;;
    esac
done

# Constants
RECORDING_FILE="/tmp/fds-ffmpeg-currently-recording";

if [[ ! -f $RECORDING_FILE ]]; then 
    notify-send --expire-time=1500 "Screen capture selection" "Select a region to record.";

    dimensions=$(slop -f "%x %y %w %h %g %i") || { 
        notify-send --expire-time=1500 "Screen capture failed" "Selection mode has been exited. Cancelling the recording.";
        exit 1; 
    };
    read -r pos_x pos_y width height grid id <<< $dimensions

    date_format=$(date +%F-%H-%M-%S)
    
    recording_command="ffmpeg -y -f x11grab " 

    if [[ $MOUSELESS == 1 ]]; then 
        recording_command+="-draw_mouse 0 ";
    fi

    if [[ $FOLLOW_MOUSE == 1 ]]; then 
        recording_command+="-follow_mouse centered ";
    fi
    
    recording_command+="-s ${width}x${height} -i :0.0+${pos_x},$pos_y ${OUTPUT}/$date_format.mkv -nostdin"

    $recording_command &
    PROCESS_ID="$!"
    RETURN_CODE="$?"
    sleep 1;

    if [[ "$RETURN_CODE" != 0 ]]; then
        notify-send "Recording start has failed";
        exit 1;
    fi

    if [[ $ENABLE_NOTIFICATION == 1 ]]; then 
        notify-send --expire-time=1000 "Recording started successfully" "Process ID is at "$PROCESS_ID"";
    fi

    touch "$RECORDING_FILE";
    echo "$PROCESS_ID" >> $RECORDING_FILE;
else
    PROCESS_ID=$(<"$RECORDING_FILE")
    
    kill $PROCESS_ID

    if [[ $? != 0 ]]; then 
        notify-send "Recording stop failed" "There's a problem while trying to kill the process. Process ID is at $WINDOW_ID";
        exit 1;
    fi

    notify-send "Recording stop successful"
    rm "$RECORDING_FILE"
fi