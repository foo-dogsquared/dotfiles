local module = {}
local wezterm = require("wezterm")

wezterm.on("update-right-status", function(window, pane)
  local key = window:active_key_table()
  if key then
    key = "TABLE: " .. key
  end
  window:set_right_status(key or "")
end)

return module
