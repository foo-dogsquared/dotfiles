local wezterm = require("wezterm")
local base = require("config/base")
local events = require("config/events")

local keymod = base.keymod
local module = {}

function module.apply_to_config(config)
  -- I'm very used to setting <SPACE> as the leader so I'm continuing the tradition.
  config.leader = { key = "Space", mods = keymod, timeout_milliseconds = 1000 }

  -- Quick select-related options. Quite similar to Kitty hints which is
  -- nice.
  config.quick_select_patterns = {
    "[0-9a-f]{7,40}", -- SHA1 hashes, usually used for Git.
    "[0-9a-f]{7,64}", -- SHA256 hashes, used often for getting hashes for Guix packaging.
    "sha256-.{44,128}", -- SHA256 hashes in Base64, used often in getting hashes for Nix packaging.
  }

  config.mouse_bindings = {
    {
      event = { Down = { streak = 3, button = "Left" } },
      action = { SelectTextAtMouseCursor = "SemanticZone" },
      mods = keymod,
    },
  }

  -- It also makes use of key tables which is defined after.
  config.keys = {
    -- Clipboard
    { key = "c", mods = keymod, action = wezterm.action({ CopyTo = "Clipboard" }) },
    { key = "v", mods = keymod, action = wezterm.action({ PasteFrom = "Clipboard" }) },

    -- Font resize.
    { key = "+", mods = keymod, action = "IncreaseFontSize" },
    { key = "_", mods = keymod, action = "DecreaseFontSize" },
    { key = ")", mods = keymod, action = "ResetFontSize" },

    -- Scrollback
    { key = "j", mods = keymod, action = wezterm.action({ ScrollByPage = 1 }) },
    { key = "k", mods = keymod, action = wezterm.action({ ScrollByPage = -1 }) },
    { key = "j", mods = "CTRL|ALT", action = wezterm.action({ ScrollToPrompt = 1 }) },
    { key = "k", mods = "CTRL|ALT", action = wezterm.action({ ScrollToPrompt = -1 }) },

    -- Pane navigation.
    {
      key = "p",
      mods = "LEADER",
      action = wezterm.action.ActivateKeyTable({
        name = "pane_navigation",
        timeout_milliseconds = 1000,
        replace_current = true,
        one_shot = true,
      }),
    },
    {
      key = "r",
      mods = "LEADER",
      action = wezterm.action({
        ActivateKeyTable = { name = "resize_pane", replace_current = true, one_shot = false },
      }),
    },
    { key = "h", mods = keymod, action = wezterm.action({ ActivatePaneDirection = "Left" }) },
    { key = "l", mods = keymod, action = wezterm.action({ ActivatePaneDirection = "Right" }) },
    { key = "LeftArrow", mods = keymod, action = wezterm.action({ ActivatePaneDirection = "Left" }) },
    { key = "DownArrow", mods = keymod, action = wezterm.action({ ActivatePaneDirection = "Down" }) },
    { key = "UpArrow", mods = keymod, action = wezterm.action({ ActivatePaneDirection = "Up" }) },
    { key = "RightArrow", mods = keymod, action = wezterm.action({ ActivatePaneDirection = "Right" }) },

    -- More pane-related niceties.
    { key = "f", mods = "LEADER", action = "TogglePaneZoomState" },
    { key = "f", mods = keymod, action = "TogglePaneZoomState" },
    { key = "n", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "n", mods = keymod, action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    { key = "d", mods = keymod, action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },

    -- Tab navigation
    {
      key = "t",
      mods = "LEADER",
      action = wezterm.action({
        ActivateKeyTable = {
          name = "tab_navigation",
          timeout_milliseconds = 1000,
          replace_current = true,
          one_shot = true,
        },
      }),
    },

    -- Hints and quick selections
    {
      key = "h",
      mods = "LEADER",
      action = wezterm.action({
        ActivateKeyTable = { name = "hints", timeout_milliseconds = 1000, replace_current = true, one_shot = true },
      }),
    },

    { key = "r", mods = keymod, action = "ReloadConfiguration" },
    { key = "t", mods = keymod, action = wezterm.action.ShowDebugOverlay },

    -- Selection
    { key = "Space", mods = "LEADER", action = "QuickSelect" },
    { key = "a", mods = keymod, action = "QuickSelect" },
    { key = "s", mods = keymod, action = wezterm.action({ Search = { CaseSensitiveString = "" } }) },
  }

  config.key_tables = {
    hints = {
      { key = "g", action = wezterm.action({ Search = { Regex = "[0-9a-f]{6,}" } }) },
      {
        key = "h",
        action = wezterm.action({
          QuickSelectArgs = {
            patterns = {
              "[0-9a-f]{7,40}", -- SHA1 hashes, usually used for Git.
              "[0-9a-f]{7,64}", -- SHA256 hashes, used often for getting hashes for Guix packaging.
              "sha256-[[:alpha:][:digit:]-=+/?]{44}", -- SHA256 hashes in Base64, used often in getting hashes for Nix packaging.
              "[[:alpha:][:digit:]-=+/?]{44,64}",
            },
          },
        }),
      },

      -- Basically the equivalent of `kitty hints word`.
      {
        key = "w",
        action = wezterm.action({
          QuickSelectArgs = {
            patterns = {
              "\\S+",
            },
          },
        }),
      },

      -- The equivalent to `kitty hints line`.
      {
        key = "l",
        action = wezterm.action({
          QuickSelectArgs = {
            patterns = {
              ".+",
            },
          },
        }),
      },

      { key = "p", action = wezterm.action({ Search = { Regex = "legacyPackages[[:alpha:][:digit:]]+" } }) },

      { key = "Space", action = "QuickSelect" },
      { key = "s", action = "QuickSelect" },
      { key = "f", action = wezterm.action({ Search = { CaseSensitiveString = "" } }) },
    },

    pane_navigation = {
      { key = "d", action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
      { key = "h", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
      { key = "j", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
      { key = "k", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
      { key = "l", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
      { key = "n", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
    },

    tab_navigation = {
      { key = "d", action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },
      { key = "h", action = wezterm.action({ ActivateTabRelative = -1 }) },
      { key = "j", action = wezterm.action({ ActivateTab = -1 }) },
      { key = "k", action = wezterm.action({ ActivateTab = 0 }) },
      { key = "l", action = wezterm.action({ ActivateTabRelative = 1 }) },
      { key = "n", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    },

    resize_pane = {
      { key = "h", action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }) },
      { key = "j", action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }) },
      { key = "k", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
      { key = "l", action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }) },
      { key = "q", action = "PopKeyTable" },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },
  }

  return config
end

return module
