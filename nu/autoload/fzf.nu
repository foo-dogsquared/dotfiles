# Nushell module based from the `fzf --bash` output.
#
# This port takes some liberty from the Bash script and does not have the same
# integrations such as tmux for now.
#
# It accepts the following envvars and their following description:
#
# - FZF_TMUX_HEIGHT should be the height of the prompt interface and mainly
# used in considering for opening inside of tmux env.
# - FZF_CTRL_T_COMMAND is the default command for Ctrl+T keybinding set for
# this Nu script.
# - FZF_DEFAULT_OPTS is a string

let __fzf_defaults = [
    --height ($env.FZF_TMUX_HEIGHT? | default "40%")
    --bind=ctrl-z:ignore
]

def __fzf_select [...flags: string] {
    with-env {
        FZF_CTRL_T_COMMAND: ($env.FZF_CTRL_T_COMMAND? | default "fzf")
        FZF_DEFAULT_OPTS: ($env.FZF_DEFAULT_OPTS? | default $__fzf_defaults)
    } {
        fzf ...$flags ...$env.FZF_DEFAULT_OPTS
    }
}

def __fzf_cd [...flags: string] {
    with-env {
        FZF_CTRL_T_COMMAND: ($env.FZF_CTRL_T_COMMAND? | default "fzf")
        FZF_DEFAULT_OPTS: ($env.FZF_DEFAULT_OPTS? | default $__fzf_defaults)
    } {
        fzf ...$env.FZF_DEFAULT_OPTS --reverse --walker=dir,hidden,follow ...$flags
    }
}

$env.config.keybindings = $env.config.keybindings | append [
    {
        name: fzf_select
        modifier: control
        keycode: char_t
        mode: [emacs vi_normal vi_insert]
        event: {
            send: ExecuteHostCommand
            cmd: "commandline edit --insert (
                __fzf_select '--multi'
                | lines
                | str join ' '
            )"
        }
    }

    {
        name: fzf_cd
        modifier: alt
        keycode: char_c
        mode: [emacs vi_normal vi_insert]
        event: {
            send: ExecuteHostCommand
            cmd: "cd (__fzf_cd)"
        }
    }
]
