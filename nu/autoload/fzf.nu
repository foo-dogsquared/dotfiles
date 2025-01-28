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
# - FZF_DEFAULT_OPTS contains default arguments to be passed to fzf when
# executing.
# - FZF_ALT_C_COMMAND contains the executable and its arguments used for
# entering directories (with Alt+C keybinding).

let __fzf_defaults = [
    --height ($env.FZF_TMUX_HEIGHT? | default "40%")
    --bind=ctrl-z:ignore
    --reverse
]

let envconvert_cmdstring = {
    from_string: { |s| $s | split row ' ' }
    to_string: { |s| $s | str join ' ' }
}

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
        FZF_DEFAULT_OPTS: ($env.FZF_DEFAULT_OPTS | default $__fzf_defaults)
    } {
        if "FZF_ALT_C_COMMAND" in $env {
            let command = $env.FZF_ALT_C_COMMAND
            run-external ($command | get 0) ...($command | range 1..) | fzf ...$env.FZF_DEFAULT_OPTS ...$flags
        } else {
            fzf ...$env.FZF_DEFAULT_OPTS --walker=dir,hidden,follow ...$flags
        }
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
        name: fzf_parent_select
        modifier: alt
        keycode: char_t
        mode: [emacs vi_normal vi_insert]
        event: {
            send: ExecuteHostCommand
            cmd: "commandline edit --insert (
                __fzf_select '--multi' '--walker-root=../'
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

$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge deep --strategy=append {
    FZF_CTRL_T_COMMAND: $envconvert_cmdstring
    FZF_ALT_C_COMMAND: $envconvert_cmdstring
    FZF_DEFAULT_OPTS: $envconvert_cmdstring
    FZF_DEFAULT_COMMAND: $envconvert_cmdstring
}
