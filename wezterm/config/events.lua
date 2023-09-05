local module = {}
local wezterm = require("wezterm")
local io = require("io")
local os = require("os")

wezterm.on("update-right-status", function(window, pane)
  local key = window:active_key_table()
  if key then
    key = "TABLE: " .. key
  end
  window:set_right_status(key or "")
end)

wezterm.on("view-last-output-in-new-pane", function(_, pane)
  local zones = pane:get_semantic_zones("Output")
  local last_zone = zones[#zones - 1]

  if not last_zone then
    return nil
  end

  local output = pane:get_text_from_semantic_zone(last_zone)

  local tmpname = os.tmpname()
  local f = io.open(tmpname, "w+")
  if f ~= nil then
    f:write(output)
    f:flush()
    f:close()
  end

  pane:split({
    args = { os.getenv("PAGER") or "less", tmpname },
    direction = "Bottom",
    domain = { DomainName = "local" },
  })

  -- Without this, it would quickly close all of the process immediately.
  wezterm.sleep_ms(1000)

  -- While it isn't required, it is nice to clean it up.
  os.remove(tmpname)
end)

return module
