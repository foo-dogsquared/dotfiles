$env.config = $env.config | merge deep --strategy=append {
    show_banner: false
    shell_integration: {
        osc7: true
        osc133: true
        osc633: true
    }
}
