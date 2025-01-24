return {
  -- Enable visuals for addition/deletion of lines in the gutter (side) similar
  -- to Visual Studio Code.
  "airblade/vim-gitgutter",

  -- Make your Neovim pretty
  {
    "rktjmp/lush.nvim",
    priority = 1000,
    module = true,
    config = function()
      vim.cmd("colorscheme fds-theme")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      icons_enabled = true,
      always_divide_middle = true,
      globalstatus = true,

      -- Disable the section separators.
      section_separators = {
        left = "",
        right = "",
      },

      sections = {
        lualine_a = { "mode" },
        lualine_c = {
          {
            "filename",
            newline_status = true,
            shorting_target = 10,
            path = 1,
          },
        },
        lualine_z = { "location" },
      },
    },
  },

  -- Remember your keys.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Colorize common color strings
  {
    "norcalli/nvim-colorizer.lua",
    config = true,
  },
}
