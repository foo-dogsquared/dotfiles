return {
  -- Need a telescope to see your johnsons.
  {
    "nvim-telescope/telescope.nvim",
    depedencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-project.nvim",
    },
    module = true,
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          project = {
            base_dirs = {
              { "~/library/projects/software", max_depth = 2 },
              { "~/library/projects/packages" },
              { "~/library/writings" },
            },
          },
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

      vim.keymap.set("n", "<leader>ff", get_builtin("find_files", { hidden = true }), opts)
      vim.keymap.set("n", "<leader>fF", function()
        builtins.find_files({
          cwd = require("telescope.utils").buffer_dir(),
          hidden = true,
        })
      end, opts)

      vim.keymap.set("n", "<leader>fg", get_builtin("grep_string"), opts)
      vim.keymap.set("n", "<leader>fG", get_builtin("live_grep"), opts)
      vim.keymap.set("n", "<leader>fb", get_builtin("buffers"), opts)
      vim.keymap.set("n", "<leader>fh", get_builtin("help_tags"), opts)
      vim.keymap.set("n", "<leader>ft", get_builtin("treesitter"), opts)
      vim.keymap.set("n", "<leader>fb", get_builtin("buffers"), opts)
      vim.keymap.set("n", "<leader>fM", get_builtin("man_pages"), opts)

      vim.keymap.set("n", "<leader>fA", get_builtin("resume"), opts)

      -- Ekeymap.set
      vim.keymap.set("n", "<leader>fp", [[<cmd>lua require("telescope").extensions.project.project({})<cr>]], opts)
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
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
