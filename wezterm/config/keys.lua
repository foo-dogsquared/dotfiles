local wezterm = require("wezterm")
local base = require("config/base")
local act = wezterm.action

local keymod = base.keymod
local alt_keymod = base.alt_keymod
local module = {}

local copy_mode = nil
if wezterm.gui then
  copy_mode = wezterm.gui.default_key_tables().copy_mode
  table.insert(
    copy_mode,
    {
      key = 'z',
      mods = keymod,
      action = act.CopyMode { MoveBackwardZoneOfType = 'Output' },
    }
  )
end

function module.apply_to_config(config)
  -- I'm very used to setting <SPACE> as the leader so I'm continuing the tradition.
  config.leader = { key = "Space", mods = keymod, timeout_milliseconds = 1000 }

  -- I'm liking the workflow I have with Kitty so no thanks for the default
  -- shortcuts. So this is what it feels like to be obnoxiously stubborn.
  config.disable_default_key_bindings = true

  config.mouse_bindings = {
    {
      event = { Down = { streak = 3, button = "Left" } },
      action = { SelectTextAtMouseCursor = "SemanticZone" },
      mods = keymod,
    },

    {
      event = { Down = { streak = 1, button = "Left" } },
      action = act.ExtendSelectionToMouseCursor("Word"),
      mods = keymod,
    },
  }

  -- It also makes use of key tables which is defined after.
  config.keys = {
    -- Clipboard
    { key = "c", mods = keymod,     action = act.CopyTo("Clipboard") },
    { key = "v", mods = keymod,     action = act.PasteFrom("Clipboard") },

    -- Font resize.
    { key = "+", mods = keymod,     action = act.IncreaseFontSize },
    { key = "_", mods = keymod,     action = act.DecreaseFontSize },
    { key = ")", mods = keymod,     action = act.ResetFontSize },

    -- Scrollback
    { key = "j", mods = keymod,     action = act.ScrollByPage(1) },
    { key = "k", mods = keymod,     action = act.ScrollByPage(-1) },
    { key = "j", mods = "CTRL|ALT", action = act.ScrollToPrompt(1) },
    { key = "k", mods = "CTRL|ALT", action = act.ScrollToPrompt(-1) },
    { key = "G", mods = keymod,     action = act.ScrollToBottom },
    { key = "g", mods = "CTRL|ALT", action = act.ScrollToTop },

    -- Pane navigation.
    {
      key = "p",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "pane_navigation",
        timeout_milliseconds = 1000,
        replace_current = true,
        one_shot = true,
      }),
    },

    {
      key = "r",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "resize_pane",
        replace_current = true,
        one_shot = false,
      }),
    },

    { key = "h",          mods = keymod,     action = act.ActivatePaneDirection("Left") },
    { key = "l",          mods = keymod,     action = act.ActivatePaneDirection("Right") },
    { key = "LeftArrow",  mods = keymod,     action = act.ActivatePaneDirection("Left") },
    { key = "DownArrow",  mods = keymod,     action = act.ActivatePaneDirection("Down") },
    { key = "UpArrow",    mods = keymod,     action = act.ActivatePaneDirection("Up") },
    { key = "RightArrow", mods = keymod,     action = act.ActivatePaneDirection("Right") },
    { key = "^",          mods = keymod,     action = act.ActivateLastTab },

    -- More pane-related niceties.
    { key = "f",          mods = "LEADER",   action = act.TogglePaneZoomState },
    { key = "f",          mods = keymod,     action = act.TogglePaneZoomState },
    { key = "n",          mods = "LEADER",   action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "n",          mods = keymod,     action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "n",          mods = alt_keymod, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "d",          mods = keymod,     action = act.CloseCurrentPane({ confirm = false }) },

    -- Tab navigation
    {
      key = "t",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "tab_navigation",
        timeout_milliseconds = 1000,
        replace_current = true,
        one_shot = true,
      }),
    },
    { mods = alt_keymod, key = "h",         action = act.ActivateTabRelative(-1) },
    { mods = alt_keymod, key = "j",         action = act.ActivateTab(-1) },
    { mods = alt_keymod, key = "k",         action = act.ActivateTab(0) },
    { mods = alt_keymod, key = "l",         action = act.ActivateTabRelative(1) },
    { key = "t",         mods = alt_keymod, action = act.ShowTabNavigator },
    { key = "d",         mods = alt_keymod, action = act.CloseCurrentTab({ confirm = false }) },

    -- Hints and quick selections
    {
      key = "h",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "hints",
        timeout_milliseconds = 1000,
        replace_current = true,
        one_shot = true,
      }),
    },

    { key = "h",     mods = "ALT",    action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "j",     mods = "ALT",    action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "k",     mods = "ALT",    action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "l",     mods = "ALT",    action = act.AdjustPaneSize({ "Right", 1 }) },

    { key = "r",     mods = keymod,   action = act.ReloadConfiguration },
    { key = "o",     mods = keymod,   action = act.ShowDebugOverlay },
    { key = "p",     mods = keymod,   action = act.ActivateCommandPalette },
    { key = "y",     mods = keymod,   action = act.ActivateCopyMode },
    { key = "e",     mods = keymod,   action = act.EmitEvent("view-last-output-in-new-pane") },

    -- Selection
    { key = "Space", mods = "LEADER", action = act.QuickSelect },
    { key = "a",     mods = keymod,   action = act.QuickSelect },
    { key = "s",     mods = keymod,   action = act.Search({ CaseSensitiveString = "" }) },
  }

  config.key_tables = {
    hints = {
      { key = "g",     action = act.Search({ Regex = "[0-9a-f]{6,}" }) },
      {
        key = "h",
        action = act.QuickSelectArgs({
          patterns = {
            "[0-9a-f]{7,40}",                       -- SHA1 hashes, usually used for Git.
            "[0-9a-f]{7,64}",                       -- SHA256 hashes, used often for getting hashes for Guix packaging.
            "sha256-[[:alpha:][:digit:]-=+/?]{44}", -- SHA256 hashes in Base64, used often in getting hashes for Nix packaging.
            "[[:alpha:][:digit:]-=+/?]{44,64}",
          },
        }),
      },

      -- Basically the equivalent of `kitty hints word`.
      {
        key = "w",
        action = act.QuickSelectArgs({
          patterns = {
            "\\S+",
          },
        }),
      },

      -- The equivalent to `kitty hints line`.
      {
        key = "l",
        action = act.QuickSelectArgs({
          patterns = {
            ".+",
          },
        }),
      },

      { key = "Space", action = act.QuickSelect },
      { key = "s",     action = act.QuickSelect },
      { key = "f",     action = act.Search({ CaseSensitiveString = "" }) },
    },

    pane_navigation = {
      { key = "d", action = act.CloseCurrentPane({ confirm = false }) },
      { key = "h", action = act.ActivatePaneDirection("Left") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
      { key = "k", action = act.ActivatePaneDirection("Up") },
      { key = "l", action = act.ActivatePaneDirection("Right") },
      { key = "n", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    },

    tab_navigation = {
      { key = "d", action = act.CloseCurrentTab({ confirm = false }) },
      { key = "h", action = act.ActivateTabRelative(-1) },
      { key = "j", action = act.ActivateTab(-1) },
      { key = "k", action = act.ActivateTab(0) },
      { key = "l", action = act.ActivateTabRelative(1) },
      { key = "n", action = act.SpawnTab("CurrentPaneDomain") },
    },

    resize_pane = {
      { key = "h",      action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "j",      action = act.AdjustPaneSize({ "Down", 1 }) },
      { key = "k",      action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "l",      action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "q",      action = act.PopKeyTable },
      { key = "Escape", action = act.PopKeyTable },
      { key = "Enter",  action = act.PopKeyTable },
    },

    copy_mode = copy_mode,
  }
  return config
end

return module
