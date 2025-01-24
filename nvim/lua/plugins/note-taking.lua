local function get_note(subfolder)
  return vim.fn.expand("~/Documents/Notes/") .. subfolder
end

return {
  {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.journal"] = {
          config = {
            strategy = "flat",
          },
        },
        ["core.summary"] = {},
        ["core.ui.calendar"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              personal = get_note("Personal"),
              work = get_note("Work"),
              wiki = get_note("Wiki"),
            },
          },
        },
      },
    },
  }
}
