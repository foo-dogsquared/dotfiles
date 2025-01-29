use std/dirs
use std/dirs shells-aliases *

$env.config.keybindings = $env.config.keybindings | append [
    {
        name: dirs_quickadd
        modifier: control
        keycode: char_f
        mode: [emacs vi_normal vi_insert]
        event: {
            send: ExecuteHostCommand
            cmd: "dirs add .."
        }
    }

    {
        name: dirs_drop
        modifier: alt
        keycode: char_f
        mode: [emacs vi_normal vi_insert]
        event: {
            send: ExecuteHostCommand
            cmd: "dirs drop"
        }
    }

    {
        name: dirs_prev
        modifier: control
        keycode: char_h
        mode: [emacs vi_normal vi_insert]
        event: [
            {
                send: ExecuteHostCommand
                cmd: "dirs prev"
            }

            {
                send: ExecuteHostCommand
                cmd: "cd -"
            }
        ]
    }
]
