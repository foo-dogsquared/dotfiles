-- A local jumpstart for creating my base configuration.
local module = {}

function module.apply_to_config(config)
  -- Quick select-related options. Quite similar to Kitty hints which is
  -- nice.
  config.quick_select_patterns = {
    "[0-9a-f]{7,40}", -- SHA1 hashes, usually used for Git.
    "[0-9a-f]{7,64}", -- SHA256 hashes, used often for getting hashes for Guix packaging.
    "sha256-.{44,128}", -- SHA256 hashes in Base64, used often in getting hashes for Nix packaging.
  }

  -- Don't tease me with the upcoming releases, man.
  config.check_for_updates = false

  -- Enable some things for Wayland.
  if os.getenv "XDG_SESSION_TYPE" == "wayland" then
    config.enable_wayland = true
    config.force_reverse_video_cursor = true
  end

  -- Use some IME.
  config.use_ime = true

  -- Set up the visual bell.
  config.audible_bell = "SystemBeep"
  config.visual_bell = {
    fade_in_duration_ms = 50,
    fade_out_duration_ms = 50,
  }

  return config
end

-- The keymod to be used for the entire configuration. The purpose of the
-- keymod is to assign it as a "global modifier" for the Wezterm program since
-- usual modifiers like CTRL and ALT are typically used for programs like Vim
-- and Emacs. It's quite similar to tmux's prefix key for its keybindings.
module.keymod = "CTRL|SHIFT"
module.alt_keymod = "CTRL|SHIFT|ALT"

return module
