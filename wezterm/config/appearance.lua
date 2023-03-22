-- This module should set the appearance-related options.
local module = {}

local wezterm = require("wezterm")

local light_theme = "Albino bark on a tree"
local dark_theme = "Bark on a tree"

local function scheme_for_appearance()
  local scheme = wezterm.gui.get_appearance()
  if scheme == "Dark" then
    return dark_theme
  else
    return light_theme
  end
end

local albino_bark_on_a_tree =
  wezterm.color.load_base16_scheme(os.getenv("HOME") .. "/library/dotfiles/base16/albino-bark-on-a-tree.yaml")
local bark_on_a_tree =
  wezterm.color.load_base16_scheme(os.getenv("HOME") .. "/library/dotfiles/base16/bark-on-a-tree.yaml")

--- Apply the configuration with the given table.
-- @param config: the table containing Wezterm configuration.
function module.apply_to_config(config)
  config.color_schemes = {}
  config.color_schemes[light_theme] = albino_bark_on_a_tree
  config.color_schemes[dark_theme] = bark_on_a_tree
  config.color_scheme = scheme_for_appearance()

  return config
end

return module
