-- This module should set the appearance-related options.
local module = {}

local wezterm = require("wezterm")

-- This has to be setup outside of this configuration. I don't want to have the
-- same code fetching the colors all over various config files.
local xdg_data_home = os.getenv("XDG_DATA_HOME") or "~/.local/share"
local theme_dir = xdg_data_home .. "/base16/bark-on-a-tree"
local light_scheme, light_scheme_metadata = wezterm.color.load_base16_scheme(theme_dir .. "/albino-bark-on-a-tree.yaml")
local dark_theme, dark_theme_metadata = wezterm.color.load_base16_scheme(theme_dir .. "/bark-on-a-tree.yaml")

local function scheme_for_appearance()
  -- We're just following the default XDG appearance spec.
  local scheme = wezterm.gui.get_appearance()
  if scheme == "Dark" then
    return dark_theme_metadata.name
  else
    return light_scheme_metadata.name
  end
end

function module.add_base16_scheme_to_config(path, config)
  local scheme, metadata = wezterm.color.load_base16_scheme(path)
  config.color_schemes[metadata.name] = scheme

  return config
end

--- Apply the configuration with the given table.
-- @param config: the table containing Wezterm configuration.
function module.apply_to_config(config)
  config.color_schemes = {}

  config.font_size = 16

  -- Thankfully, wezterm can detect fontconfig aliases.
  config.font = wezterm.font_with_fallback({
    "monospace",
    "Noto Color Emoji",
  })

  -- Desaturate any inactive panes.
  config.inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.5,
  }

  -- Set with my color schemes.
  config.color_schemes[dark_theme_metadata.name] = dark_theme
  config.color_schemes[light_scheme_metadata.name] = light_scheme
  config.color_scheme = scheme_for_appearance()

  config.command_palette_fg_color = config.color_schemes[config.color_scheme].foreground
  config.command_palette_bg_color = config.color_schemes[config.color_scheme].background
  config.command_palette_font_size = config.font_size

  -- Disable some annoying mouse thingies.
  config.hide_mouse_cursor_when_typing = false
  config.pane_focus_follows_mouse = true

  -- Disable some more annoyances.
  config.enable_tab_bar = true
  config.tab_bar_at_bottom = false
  config.window_decorations = "NONE"

  -- Configuring the appearance of the tab bar.
  config.window_frame = {
    font = config.font,
    font_size = config.font_size - 2,
  }

  -- Configuring the windows padding.
  config.window_padding = {
    left = 0,
    right = "1cell",
    top = 0,
    bottom = 0,
  }

  return config
end

return module
