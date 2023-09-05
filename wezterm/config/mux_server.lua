-- A configuration set for remote multiplexer-related options.
local module = {}

function module.apply_to_config(config)
  config.unix_domains = {
    { name = "unix" },
  }

  config.tls_clients = {
    {
      name = "mux.foodogsquared.one",
      remote_address = "mux.foodogsquared.one:9801",
      bootstrap_via_ssh = "plover@mux.foodogsquared.one",
    },
  }

  config.default_gui_startup_args = { "connect", "unix" }
  return config
end

return module
