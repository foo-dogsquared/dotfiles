if [[ -f $HOME/.profile ]]; then 
    source $HOME/.profile
fi

# This is a program that `sudo -a` needs for prompting the user and password. 
export SUDO_ASKPASS="$HOME/bin/askpass"
