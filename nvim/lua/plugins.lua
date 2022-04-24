-- This is where I install my package manager and plugins of choice. For more
-- details, just look for `packger.nvim` help tag.

-- Bootstrapping for the package manager
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({"git", "clone", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup(function(use)
  -- Let the package manager manage itself.
  use { "wbthomason/packer.nvim" }

  -- Custom color themes!
  use { "rktjmp/lush.nvim" }

  -- EditorConfig plugin
  use { "editorconfig/editorconfig-vim" }

  -- Colorize common color strings
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  }

  -- Snippets engine.
  -- A must have for me.
  use {
    "L3MON4D3/LuaSnip",
    requires = {
      "rafamadriz/friendly-snippets",
    },
    config = function ()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load()

      local ls = require("luasnip")
      local types = require("luasnip.util.types")
      ls.config.set_config {
        history = true,
        update_events = "TextChanged,TextChangedI",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { {"<- Current choice", "Comment"} },
            },
          },

          [types.insertNode] = {
            active = {
              virt_text = { {"<>", "Comment"} },
            },
          },
        },
      }

      vim.keymap.set({ "i", "s" }, "<c-j>", function()
        if ls.jumpable(1) then
          ls.jump(1)
        end
      end)

      vim.keymap.set({ "i", "s" }, "<c-k>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end)

      vim.keymap.set({ "i", "s" }, "<c-l>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end)

      vim.keymap.set({ "i", "s" }, "<c-u>", function()
        require("luasnip.extras.select_choice")()
      end)
    end,
  }

  -- Fuzzy finder of lists
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      {"nvim-lua/popup.nvim"},
      {"nvim-lua/plenary.nvim"},
      {"nvim-telescope/telescope-project.nvim"}
    },

    config = function()
      -- Telescope setup
      require("telescope").setup {
        extensions = {
          project = {
            base_dirs = {
              {"~/library/projects/software", max_depth = 2},
              {"~/library/projects/packages"},
              {"~/library/writings"},
            },
          },
        },
      }

      require("telescope").load_extension("project")

      vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files({ hidden = true })<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fF', '<cmd>lua require("telescope.builtin").find_files({ cwd = require("telescope.utils").buffer_dir(), hidden = true })<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>lua require("telescope.builtin").grep_string()<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fG', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>ft', '<cmd>lua require("telescope.builtin").treesitter()<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fr', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fR', '<cmd>lua require("telescope.builtin").oldfiles({ only_cwd = true })<cr>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>fA', '<cmd>lua require("telescope.builtin").resume()<cr>', { noremap = true })

      -- Extensions
      vim.api.nvim_set_keymap('n', '<leader>fp', '<cmd>lua require("telescope").extensions.project.project({})<cr>', { noremap = true })
    end,
  }

  -- Marks in ~~steroids~~ coconut oil
  use {
      "ThePrimeagen/harpoon",
      config = function()
        vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>lua require('harpoon.mark').add_file()<cr>", {})

        local has_telescope, telescope = pcall("telescope")
        if has_telescope then
          vim.api.nvim_set_keymap("n", "<leader>fM", "<cmd>lua require('telescope').extensions.harpoon.harpoon({})<cr>", {})
          require("telescope").load_extension("harpoon")
        end
      end,
      requires = { {"nvim-lua/plenary.nvim"} }
  }

  -- A completion engine.
  -- nvim-cmp is mostly explicit by making the configuration process manual unlike bigger plugins like CoC
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function (args)
            ls.lsp_expand(args.body)
          end,
        },

        sources = {
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
        },

        mapping = {
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
          ["<C-g>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
        },
      })
  end
  }

  -- A linting engine, a DAP client, and an LSP client entered into a bar.
  use {
    "dense-analysis/ale",
    config = function()
      vim.g.ale_disable_lsp = 1
    end,
  }
  use { "neovim/nvim-lspconfig" }
  use { "mfussenegger/nvim-dap" }
  use { "puremourning/vimspector" }

  -- tree-sitter
  use {
    "nvim-treesitter/nvim-treesitter",
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects"
    },
    run = ":TSUpdate",
    config = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },

        indent = { enable = true },

        -- custom text objects with nvim-treesitter-textobjects
        -- I've just copied this from the README but they are reasonable additions to me.
        textobjects = {
          select = {
            enable = true,
            lookahead = true,

            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ae"] = "@block.outer",
              ["ie"] = "@block.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aC"] = "@conditional.outer",
              ["iC"] = "@conditional.inner",
            },
          },
        },
      })
      end
  }

  -- One of the most popular plugins.
  -- Allows to create more substantial status bars.
  use { "vim-airline/vim-airline" }

  -- Fuzzy finder for finding files freely and fastly.
  use {
    "junegunn/fzf",
    requires = "junegunn/fzf.vim"
  }

  -- Enable visuals for addition/deletion of lines in the gutter (side) similar to Visual Studio Code.
  use { "airblade/vim-gitgutter" }

  -- Language plugins.
  use { "LnL7/vim-nix" } -- Nix
  use { "vmchale/dhall-vim" } -- Dhall
  use { "ziglang/zig.vim" } -- Zig

  if packer_bootstrap then
    require("packer").sync()
  end
end)
