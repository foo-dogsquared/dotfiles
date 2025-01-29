-- A configuration set for remote multiplexer-related options.
local module = {}

function module.apply_to_config(config)
  config.unix_domains = {
    { name = "unix" },
  }

  config.tls_clients = {
    {
      name = "foodogsquared.one",
      remote_address = "plover.foodogsquared.one:9801",
      bootstrap_via_ssh = "plover@plover.foodogsquared.one",
    },
  }

  config.default_gui_startup_args = { "connect", "unix" }
  return config
end

return module
