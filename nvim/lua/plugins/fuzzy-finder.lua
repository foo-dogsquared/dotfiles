return {
  -- Need a telescope to see your johnsons.
  {
    "nvim-telescope/telescope.nvim",
    depedencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-project.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    module = true,
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_config = {
            height = 0.95,
            width = 0.9,
            anchor_padding = 0,
          },
        },
        extensions = {
          project = {
            base_dirs = {
              { "~/library/projects/software", max_depth = 2 },
              { "~/library/projects/packages" },
              { "~/library/writings" },
            },
          },
          fzf = {},
        },
      })

      local builtins = require("telescope.builtin")
      local opts = { noremap = true }
      local get_builtin = function(fun, ...)
        local fargs = arg
        return function()
          builtins[fun](fargs)
        end
      end

      vim.keymap.set("n", "<leader>ff", get_builtin("find_files", { hidden = true, preview = false }), {
        noremap = true,
        desc = "Find files in project",
      })
      vim.keymap.set("n", "<leader>fF", function()
        builtins.find_files({
          cwd = require("telescope.utils").buffer_dir(),
          hidden = true,
          preview = false,
        })
      end, { noremap = true, desc = "Find files in current directory" })

      vim.keymap.set(
        "n",
        "<leader>fv",
        get_builtin("grep_string"),
        { noremap = true, desc = "Grep for string in cursor" }
      )

      vim.keymap.set(
        "n",
        "<leader>fg",
        get_builtin("live_grep"),
        { noremap = true, desc = "Grep for string in project" }
      )
      vim.keymap.set(
        "n",
        "<leader>fG",
        function ()
          builtins.live_grep({
            cwd = require("telescope.utils").buffer_dir()
          })
        end,
        { noremap = true, desc = "Grep for string in current directory" }
      )

      vim.keymap.set(
        "n",
        "<leader>fb",
        get_builtin("buffers", { ignore_current_buffer = true }),
        { noremap = true, desc = "Search currently opened buffers" }
      )
      vim.keymap.set(
        "n",
        "<leader>fB",
        function ()
          builtins.buffers({
            cwd = require("telescope.utils").buffer_dir(),
            ignore_current_buffer = true,
            show_all_buffers = false,
            only_cwd = true,
          })
        end,
        { noremap = true, desc = "Search currently opened buffers in current directory" }
      )

      vim.keymap.set("n", "<leader>fh", get_builtin("help_tags"), { noremap = true, desc = "Search help pages" })
      vim.keymap.set(
        "n",
        "<leader>ft",
        get_builtin("treesitter"),
        { noremap = true, desc = "Search treesitter objects" }
      )
      vim.keymap.set("n", "<leader>fM", get_builtin("man_pages"), { noremap = true, desc = "Search manpages" })
      vim.keymap.set(
        "n",
        "<leader>fS",
        get_builtin("spell_suggest"),
        { noremap = true, desc = "Pick spell suggestions" }
      )

      vim.keymap.set("n", "<leader>fA", get_builtin("resume"), { noremap = true, desc = "Return last search" })

      vim.keymap.set("n", "<leader>fp", [[<cmd>lua require("telescope").extensions.project.project({})<cr>]], opts)
    end,
  },

  -- Marks in ~~steroids~~ coconut oil
  {
    "ThePrimeagen/harpoon",
    config = function()
      vim.keymap.set(
        "n",
        "<leader>fm",
        "<cmd>lua require('harpoon.mark').add_file()<cr>",
        { desc = "Add mark to file" }
      )

      local has_telescope, telescope = pcall("telescope")
      if has_telescope then
        vim.keymap.set("n", "<leader>fM", "<cmd>lua require('telescope').extensions.harpoon.harpoon({})<cr>", {})
        require("telescope").load_extension("harpoon")
      end
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
