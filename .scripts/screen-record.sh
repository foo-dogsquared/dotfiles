#!/bin/sh 

# Records the screen with OBS Studio.

# This script depends on the following 
# programs along with the indicated version:
# OBS Studio - 23.2.1-2 
# xdotool - version 3.20160805.1
# echo (part of coreutils 8.31)
# notify-send - 0.7.8

# Having a notify-send means you also need to 
# have a notification server (such as dunst) to be up at the time.

function error_cleanup() {
    # rm "$pic_filepath"    
    echo "$red An error occurred on line $1\n $reset"
}

help_section="
Simply captures a recording with OBS Studio.

Note it requires you to set a hotkey for recording in 
OBS Studio in order to run this script properly.
The default hotkey set in this script is 'Shift+R'. 
If your hotkey is any different,
change the OBS_RECORDING_HOTKEY variable 
in this script accordingly.

Usage: $0 [-o/--output <OUTPUT_PATH>] [-s/--select] 
[-d/--delay <SECONDS>] [--help]

Options:
-h, --help - show the help section
-p, --profile <string> - indicate the profile (default: 'Untitled')
-s, --scene <string> - the scene to be used (default: 'Untitled')
"

# setting up a exit trap in case of error
trap 'error_cleanup $LINENO' ERR

while [[ $# -gt 0 ]]
do
    case $1 in 
        -h|--help)
            echo "$help_section"
            exit 0;;
        -p|--profile)
            PROFILE="$2"
            shift
            shift;;
        -s|--scene)
            SCENE="$2"
            shift;;
        *)
            shift;;
    esac
done

RECORDING_FILE="/tmp/currently-recording"
OBS_RECORDING_HOTKEY="shift+r"

# The program simply checks for the 
if [[ ! -f $RECORDING_FILE ]]; then 
    obs_command="obs --startrecording --minimize-to-tray "

    if [[ -n "$PROFILE" ]]; then
        obs_command+="--profile $PROFILE "
    fi

    if [[ -n "$SCENE" ]]; then
        obs_command+="--scene $SCENE "
    fi

    eval $obs_command &
    sleep 1;

    if [[ $? != 0 ]]; then
        notify-send "Recording starting failed" "Did not successfully started recording."
        exit 1;
    fi

    WINDOW_ID=$(xdotool search --name "OBS [[:digit:]]+" | head -n1)
    notify-send "Recording started." "Found a OBS Studio window instance with the window ID $WINDOW_ID." --expire-time=1000
    
    touch $RECORDING_FILE
    echo $WINDOW_ID >> $RECORDING_FILE
else
    current_window_id=$(xdotool getactivewindow)

    WINDOW_ID=$(<"$RECORDING_FILE")
    
    xdotool windowkill $WINDOW_ID
    
    if [[ $? != 0 ]]; then
        notify-send "Recording stop process failed" "There's a problem with stopping recording. Might want to manually stop the recording yourself."
        exit 1;
    fi

    notify-send "Recording ended." "The recording should be cancelled now."
    xdotool windowactivate $current_window_id
    rm "$RECORDING_FILE"
fi
