# This is the part that configures the interactive shell. 

export function git_directory() {
    git_branch=$(git branch --show-current 2>/dev/null)

    return "$git_branch"
}

# Add pywal to the bootup of the interactive shell
cat ~/.cache/wal/sequences

# The prompt. 
# This is based from Luke Smith's setup. 
# https://github.com/LukeSmithxyz/voidrice/blob/master/.config/zsh/.zshrc 
autoload -U colors && colors
PS1="%F%(0?.%{$fg[red](T%}.%{$fg[green](F%})) %B%{$fg[magenta]%}%~%{$reset_color%} $%f%b "

# Configuring the command history.
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history

# Shell keybindings in Vim mode. 
# bindkey -v

# Keybindings.
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# History searching.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Enable prompts
autoload -Uz promptinit
promptinit

# Loading completion feature. 
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-prvileges 1
compinit

setopt COMPLETE_ALIASES

# This block is managed by conda. 
__conda_setup="$('/home/foo-dogsquared/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/foo-dogsquared/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/foo-dogsquared/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/foo-dogsquared/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
