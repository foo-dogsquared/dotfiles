-- A local jumpstart for creating my base configuration.
local module = {}

local wezterm = require("wezterm")

function module.apply_to_config(config)
  config.default_prog = { "bash" }

  -- I'm liking the workflow I have with Kitty so no thanks for the default
  -- shortcuts. So this is what it feels like to be obnoxiously stubborn.
  config.disable_default_key_bindings = true

  -- Don't tease me with the upcoming releases, man.
  config.check_for_updates = false

  -- Enable some things for Wayland.
  config.enable_wayland = true
  config.force_reverse_video_cursor = true

  -- Desaturate any inactive panes.
  config.inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.5,
  }

  -- Thankfully, wezterm can detect fontconfig aliases.
  config.font = wezterm.font_with_fallback({
    "monospace",
    "Noto Color Emoji",
  })

  config.color_scheme = "Batman"
  return config
end

-- The keymod to be used for the entire configuration.
module.keymod = "CTRL|SHIFT"

return module
