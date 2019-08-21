#!/bin/sh

# Simply captures an image with regional selection.

# Here are the dependencies needed to successfully 
# run this script (as of creating this script):
# * cat (version 8.31; also unlikely to be missing)
# * slop (version 7.4)
# * maim (version 5.5.3)
# * date (version 8.31)

# setting up variables for the color
red="\u001b[31m"
green="\u001b[32m"
reset="\u001b[0m"

function error_cleanup() {
    # rm "$pic_filepath"    
    printf "$red An error occurred on line $1\n $reset"
}

help_section="
Simply captures a screenshot with maim.

Usage: $0 [-o/--output <OUTPUT_PATH>] [-s/--select] 
[-d/--delay <SECONDS>] [--help]

Options:
--help - show the help section
-s, --select - set the screenshot capture to selection mode
-d, --delay <SECONDS> - set a delay for the capture 
                        (in <SECONDS> seconds)
-o, --output <OUTPUT_PATH> - set the output path for the picture;
                             when given no output, the picture will 
                             be moved to \$PICTURES_DIRECTORY (or 
                             at \$HOME/Pictures if it's missing)
"

# setting up a exit trap in case of error
trap 'error_cleanup $LINENO' ERR

while [[ $# -gt 0 ]]
do
    case $1 in 
        -h|--help)
            echo "$help_section"
            exit 0;;
        -d|--delay)
            DELAY="$2"
            shift
            shift;;
        -s|--select)
            SELECT=1
            shift;;
        -o|--output)
            OUTPUT="$2"
            shift
            shift;;
        *)
            shift;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ -n "$OUTPUT" ]]; then
    pic_filepath=$OUTPUT
else
    pic_directory=${PICTURES_DIRECTORY:-"$HOME/Pictures"}
    date_format=$(date +%F-%H-%M-%S)

    pic_filepath="$pic_directory/$date_format.png"
fi

echo "$pic_filepath"
maim_command="maim $pic_filepath "

if [[ $SELECT -eq 1 ]]; then
    geometry_coordinates=$(slop)

    if [[ -z $geometry_coordinates ]]; then
        exit 1;
    fi

    maim_command+="--geometry=$geometry_coordinates "

    if [[ -n $OUTPUT ]]; then
        pic_filepath="$pic_directory/$date_format-$geometry_coordinates.png"
    fi
fi

if [[ $DELAY -gt 0 ]]; then
    maim_command+="--delay=$DELAY "
    notify-send "Delayed screenshot" "A delayed screenshot is about to be taken in $DELAY seconds." --expire-time=$(( ($DELAY * 1000) - 1000 ))
fi

maim_process=$($maim_command)

notify-send "Screenshot taken" "It is saved at $pic_filepath."
