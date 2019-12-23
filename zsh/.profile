# This is where environmental variables are set. 
# If you're looking for the aliases, keybindings, and prompts, they are in the equivalent `.rc` (i.e., `.zshrc`, `.bashrc`) file. 

# For more information, see the following Unix Exchange thread (https://unix.stackexchange.com/q/71253). 
# Or the Arch Linux Wiki on zsh (https://wiki.archlinux.org/index.php/Zsh#Startup/Shutdown_files). 
# Also check the manual pages for `zshall` (i.e., `man zshall`). 

# My custom variables (only applicable at user level)
export PICTURES_DIRECTORY=$HOME/Pictures
export DOCUMENTS_DIRECTORY=$HOME/Documents
export BIN_DIRECTORY=$HOME/bin
export VIDEO_DIRECTORY=$HOME/recordings

# If you come from bash you might have to change your $PATH.
export PATH="$BIN_DIRECTORY:/usr/local/bin:$HOME/.cargo/bin:$PATH"

# Common environmental variables. 
# Or at least that'll be used by my setup. 
export EDITOR="vim"
export TERMINAL="alacritty"
export BROWSER="firefox"
export READ="zathura"
export FILE="ranger"
