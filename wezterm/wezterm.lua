local base = require("config/base")
local keys = require("config/keys")
local appearance = require("config/appearance")

local config = {}

base.apply_to_config(config)
keys.apply_to_config(config)
appearance.apply_to_config(config)

return config
