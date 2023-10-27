return {
  {
    "nvim-telescope/telescope.nvim",
    depedencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-project.nvim" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup {
        extensions = {
          project = {
            base_dirs = {
              { "~/library/projects/software", max_depth = 2 },
              { "~/library/projects/packages" },
              { "~/library/writings" },
            },
          },
        },
      }

      telescope.load_extension("project")

      local builtins = require("telescope.builtin")
      local get_builtin = function(fun, ...)
        local fargs = arg
        return function()
          builtins[fun](fargs)
        end
      end

      vim.keymap.set(
        "n",
        "<leader>ff",
        get_builtin("find_files", { hidden = true }),
        { noremap = true }
      )
      vim.keymap.set(
        "n",
        "<leader>fF",
        function()
          builtins.find_files {
            cwd = require("telescope.utils").buffer_dir(),
            hidden = true,
          }
        end,
        { noremap = true }
      )

      vim.keymap.set("n", "<leader>fg", get_builtin "grep_string", { noremap = true })
      vim.keymap.set("n", "<leader>fG", get_builtin "live_grep", { noremap = true })
      vim.keymap.set("n", "<leader>fb", get_builtin "buffers" , { noremap = true })
      vim.keymap.set("n", "<leader>fh", get_builtin "help_tags", { noremap = true })
      vim.keymap.set("n", "<leader>ft", get_builtin "treesitter", { noremap = true })
      vim.keymap.set("n", "<leader>fb", get_builtin "buffers", { noremap = true })
      vim.keymap.set("n", "<leader>fr", get_builtin "old_files", { noremap = true })
      vim.keymap.set(
        "n",
        "<leader>fR",
        get_builtin("old_files", { only_cwd = true }),
        { noremap = true }
      )
      vim.keymap.set("n", "<leader>fA", get_builtin "resume", { noremap = true })

      -- Ekeymap.set
      vim.keymap.set(
        "n",
        "<leader>fp",
        '<cmd>lua require("telescope").extensions.project.project({})<cr>',
        { noremap = true }
      )
    end,
  },

  -- Marks in ~~steroids~~ coconut oil
  {
    "ThePrimeagen/harpoon",
    config = function()
      vim.keymap.set("n", "<leader>fm", "<cmd>lua require('harpoon.mark').add_file()<cr>", {})

      local has_telescope, telescope = pcall("telescope")
      if has_telescope then
        vim.keymap.set("n", "<leader>fM", "<cmd>lua require('telescope').extensions.harpoon.harpoon({})<cr>", {})
        require("telescope").load_extension("harpoon")
      end
    end,
    dependencies = { { "nvim-lua/plenary.nvim" } },
  }
}
