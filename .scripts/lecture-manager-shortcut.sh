#!/bin/sh 

help_section="
This simply creates a quick rofi interface for my lectures manager. 
The notes manager is a program I created. 
You can find it in the following link:
https://github.com/foo-dogsquared/a-remote-repo-full-of-notes-of-things-i-do-not-know-about/ .

This shell script is specifically written for my system. 
Don't expect it to work out-of-the-box so please edit this script accordingly. 

Options:
-h, --help      -   Shows the help section. 
-p, --program   -   The path of the notes manager folder with the executable (`manager.py` inside of the folder). 
-c, --config    -   The location of the config. 
-t, --target    -   The target location of the notes. 
"

LECTURES=${LECTURES_DIRECTORY:-"$HOME/Documents/lectures"}
TERM="alacritty" # binary name of your terminal emulator

# The default values
TEXTURE_NOTES_MANAGER="$HOME/texture-notes"
TARGET="$HOME"
CONFIG="$HOME/config.py"

while [[ $# -gt 0 ]]
do
    case $1 in 
        -h|--help)
            echo "$help_section"
            exit 0;;
        -p|--program)
            TEXTURE_NOTES_MANAGER="$2"
            shift
            shift;;
        -c|--config)
            CONFIG="$2"
            shift
            shift;;
        -t|--target)
            TARGET="$2"
            shift
            shift;;
        *)
            shift;;
    esac
done

function prompt() {
    value=$(exec "$1" || exit)

    return value
}


options='Create a new subject
Create a new lecture
Remove a subject
Remove a lecture
List all subjects and its notes
Open a note'

actions=$(echo "$options" | rofi -dmenu -p "What do you want to do for the lectures?")

if [[ $? != 0 ]]; then exit; fi

lecture_manager_cmd="python $TEXTURE_NOTES_MANAGER/manager.py --target $TARGET --config $CONFIG "
notes_list=$(eval "$lecture_manager_cmd list :all:")

if [[ $actions == 'Create a new subject' ]]; then 
    subject=$(rofi -dmenu -p "What subject to be added into the binder?" || exit)
    if [[ $? != 0 ]]; then exit; fi
    
    lecture_manager_cmd+="add --subject \"$subject\""
elif [[ $actions == 'Create a new lecture' ]]; then 
    subject_list=$(echo "$notes_list" | sed "/^Subject \".+\" has [[:digit:]]+ notes?$/p" | awk -F "[\"\"]" '{ for (i=2; i<NF; i+=2) print $i }')
    subject=$(echo "$subject_list" | rofi -dmenu -p "What subject the lecture is for?" )
    if [[ $? != 0 ]]; then exit; fi

    title=$(rofi -dmenu -p "Title of new lecture?")
    if [[ $? != 0 ]]; then exit; fi
    
    lecture_manager_cmd+="add --note \"$subject\" \"$title\" "
elif [[ $actions == 'Remove a subject' ]]; then 
    subject_list=$(echo "$notes_list" | sed "/^Subject \".+\" has [[:digit:]]+ notes?$/p" | awk -F "[\"\"]" '{ for (i=2; i<NF; i+=2) print $i }')
    subject=$(echo "$subject_list" | rofi -dmenu -p "What subject do you want to remove?")
    if [[ $? != 0 ]]; then exit; fi
    lecture_manager_cmd+="remove --subject \"$subject\""
elif [[ $actions == 'Remove a lecture' ]]; then
    subject_list=$(echo "$notes_list" | sed "/^Subject \".+\" has [[:digit:]]+ notes?$/p" | awk -F "[\"\"]" '{ for (i=2; i<NF; i+=2) print $i }')
    subject=$(echo "$subject_list" | rofi -dmenu -p "What subject does the lecture belongs to?")
    if [[ $? != 0 ]]; then exit; fi

    note_list=$(eval $lecture_manager_cmd 'list' "$subject" | sed -n "s/^\s*-\s*//p")
    title=$(echo "$note_list" | rofi -dmenu -p "What is the title of the note to be removed?" | sed --regexp-extended "s/^\s*\([[:digit:]]+\)\s*//")
    if [[ $? != 0 ]]; then exit; fi

    delete=$(echo -e "Yes\nNo" | rofi -dmenu -p "Delete the files on the disk?")
    if [[ $? != 0 ]]; then exit; fi
    
    lecture_manager_cmd+="rm --note \"$subject\" \"$title\" "
    if [[ $delete == "Yes" ]]; then 
        $lecture_manager_cmd+="--delete " 
    fi
elif [[ $actions == 'List all subjects and its notes' ]]; then 
    lecture_manager_cmd+="list :all: "
    notes=$(eval $lecture_manager_cmd)
    echo "$notes" | rofi -dmenu -p "Here are the notes"
    exit 0
elif [[ $actions == 'Open a note' ]]; then 
    notes=$(echo "$notes_list" | grep --regexp="^\s*-\s*" | sed -n "s/^\s*-\s*//p")

    selected_note=$(echo "$notes" | rofi -dmenu -p "Select a note to be opened." | awk -F "[()]" '{ for (i=2; i<NF; i+=2) print $i }')
    if [[ $selected_note < 0 || $? != 0 ]]; then exit; fi
    
    # I have my Pygmentize package in a virtual env, so I have the line below. 
    # You can omit the line, if you have Pygmentize installed.
    source texture-notes-env/bin/activate
    exec "$TERM" --command python "$TEXTURE_NOTES_MANAGER/manager.py" --target "$TARGET" --config "$CONFIG" open $selected_note
    if [[ $? != 0 ]]; then 
        notify-send "Opening note has failed."
    fi
    
    exit
fi

status=$(eval "$lecture_manager_cmd")


if [[ $? != 0 ]]; then
    notify-send "$status"
else 
    notify-send "Lecture manager action successful!" "Resulting command: \"$lecture_manager_cmd\""
fi