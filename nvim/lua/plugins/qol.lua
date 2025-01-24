return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        char = "┊",

        scope = {
          underline = true,
        },

        chunk = {
          enabled = true,
        },
      },
      input = { enabled = true },
      notifier = { enabled = true },
      git = { enabled = true, },
      lazygit = {
        enabled = vim.fn.executable("lazygit") == 1,
      },
      quickfile = { enabled = true },
      rename = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      toggle = {
        enabled = true,
        which_key = pcall(require, "which-key"),
      },
      words = { enabled = true },
    },
    keys = {
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Open blame lines for current file" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Open lazygit" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Open current file history in lazygit" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark style" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
      default_file_explorer = true,
      columns = { "icon", "permissions" },
      view_options = {
        hidden = true,
      },
    },

    keys = {
      { "-", "<cmd>Oil<CR>", { desc = "Open parent directory in file explorer" } },
    },
  },
}
