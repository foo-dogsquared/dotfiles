$env.config.menus = $env.config.menus | append [
    {
        name: vars_menu
        only_buffer_difference: true
        marker: "var "
        type: {
            layout: list
            page_size: 10
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
        source: { |buffer, position|
            scope variables
            | where name =~ $buffer
            | sort-by name
            | each { |row| {value: $row.name description: $row.type} }
        }
    }
]

$env.config.keybindings = $env.config.keybindings | append [
    {
        name: vars_menu
        modifier: control
        keycode: char_u
        mode: [emacs vi_normal vi_insert]
        event: {
            send: menu name: vars_menu
        }
    }
]
