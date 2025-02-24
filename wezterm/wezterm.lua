local config = require("wezterm").config_builder()
config:set_strict_mode(true)

require("config/events").apply_to_config(config)
require("config/base").apply_to_config(config)
require("config/keys").apply_to_config(config)
require("config/appearance").apply_to_config(config)
require("config/mux_server").apply_to_config(config)

local wezterm = require("wezterm")

wezterm.plugin
  .require("https://github.com/mikkasendke/sessionizer.wezterm")
  .apply_to_config(config)

wezterm.plugin
  .require("https://github.com/mrjones2014/smart-splits.nvim")
  .apply_to_config(config, {
    direction_keys = { 'h', 'j', 'k', 'l' },
    modifiers = {
      move = 'CTRL',
      resize = 'META',
    },
    log_level = 'info',
  })

wezterm.plugin
  .require("https://github.com/yriveiro/wezterm-status")
  .apply_to_config(config, {
    cells = {
      battery = { enabled = true },
      date = { format = "%F %M:%h" },
      mode = { enabled = true },
    },
  })

return config
